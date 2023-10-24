
Delimiter $$
DROP procedure IF EXISTS add_trn$$
CREATE PROCEDURE add_trn(in fromAccNo varchar(20), in toAccNo varchar(20), in amount decimal(15,2), in trnType varchar(20), in description varchar(100))
BEGIN
	START TRANSACTION;
    -- If it's an online transaction
    SELECT Balance, SavingsPlanType, MinimumBalance INTO @fromBalance, @savingType, @MinimumBalance FROM minimumbalanceview WHERE AccountNo = fromAccNo LIMIT 1 FOR UPDATE;
    IF (trnType = 'Online') THEN
        -- Check if the account has exceeded the monthly withdrawal limit
        IF (@savingType  is not null) THEN
            SELECT MonthlyTransactionCount INTO @count FROM Account WHERE AccountNo = fromAccNo LIMIT 1 FOR UPDATE;
            IF @count is null or @count > 5 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Monthly Transaction Limit Exceeded';
                rollback;
            END IF;
            
        END IF;
        IF @fromBalance - amount < @MinimumBalance THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Insufficient Balance';
            rollback;
        END IF;
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, toAccNo, amount, 'Online', description);
        UPDATE Account SET MonthlyTransactionCount = MonthlyTransactionCount + 1 WHERE AccountNo = fromAccNo;

    -- If it's a loan transfer
    ELSEIF (trnType = 'Loan') THEN
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  description) VALUES (NULL, NULL, toAccNo, amount, trnType, description);
    -- If it's an ATM transaction
    ELSEIF (trnType = 'ATM') THEN
        -- Check if the account has exceeded the monthly withdrawal limit
        IF @savingType is not null THEN
            SELECT MonthlyTransactionCount INTO @count FROM Account WHERE AccountNo = fromAccNo LIMIT 1 FOR UPDATE;
            IF @count is null or @count > 5 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Monthly Transaction Limit Exceeded';
                rollback;
            END IF;
        END IF;
        SET @TrnFee = 30; -- Transaction Fee of an ATM Withdrawal
        IF @fromBalance - (amount+@TrnFee) < @MinimumBalance THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Insufficient Balance';
            Rollback;
        END IF;
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, NULL, amount, trnType, description);
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, NULL, amount, 'TrnFee', "Transaction Fee for TransactionID: " + LAST_INSERT_ID());
        UPDATE Account SET MonthlyTransactionCount = MonthlyTransactionCount + 1 WHERE AccountNo = fromAccNo;
    END IF;
    COMMIT;
END$$

-- Query Sep	

Delimiter $$
DROP PROCEDURE IF EXISTS approve_loan$$
-- Query Sep
Delimiter $$
create PROCEDURE approve_loan (in loanApplicationID int, in userID int)
BEGIN
	START TRANSACTION;
    SELECT customerID, Amount, Duration, Type INTO @customerID, @Amount, @Duration, @Type FROM LoanApplication WHERE LoanApplicationID = loanApplicationID LIMIT 1 FOR UPDATE;
    SELECT InterestRate INTO @InterestRate FROM LoanInterestRate WHERE Duration = @Duration AND Type = @Type LIMIT 1;
    SELECT EmployeeID INTO @EmployeeID FROM ManagerView WHERE UserID = userID LIMIT 1;
    SET @CurrDate = CURDATE();
    UPDATE LoanApplication SET 
        status = 'Approved',
        CheckedDate = @CurrDate,
        CheckedBy = @EmployeeID
        WHERE LoanInApplicationID = loanApplicationID;
    INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment) 
        VALUES (
            NULL, 
            @customerID, 
            loanApplicationID, 
            @Amount, 
            @Amount,
            @CurrDate, 
            @CurrDate + INTERVAL @Duration MONTH,
            (@Amount +  (@Amount * @InterestRate * @Duration / 12 ))/ @Duration);
    SELECT LAST_INSERT_ID();
    COMMIT;
END$$
Delimiter ;

-- Query Sep

Delimiter $$
DROP PROCEDURE IF EXISTS reject_loan$$
-- Query Sep
Delimiter $$
CREATE PROCEDURE reject_loan (in loanApplicationID int, in userID int)
BEGIN
	START TRANSACTION;
    SELECT EmployeeID AS EmployeeID INTO @EmployeeID FROM ManagerView WHERE UserID = userID;
    UPDATE LoanApplication SET 
        status = 'Rejected',
        CheckedDate = CURDATE(),
        CheckedBy = @EmployeeID
        WHERE LoanApplicationID = loanApplicationID;
    COMMIT;
END$$
Delimiter ;

-- Query Sep

Delimiter $$
DROP PROCEDURE IF EXISTS pay_installment$$
-- Query Sep
Delimiter $$
CREATE PROCEDURE pay_installment (in loanID int)
BEGIN
	START TRANSACTION;
    SELECT Balance, Installment INTO @Balance, @Installment FROM Loan WHERE LoanID = loanID LIMIT 1 FOR UPDATE;
    IF @Balance > 0 THEN
        SELECT DueDate INTO @DueDate FROM PayableLoanInstallmentsView WHERE LoanID = loanID ORDER BY DueDate LIMIT 1 FOR UPDATE;
		IF @DueDate IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'No Pending Installment';
        END IF;
        UPDATE LoanInstallment SET 
            Status = 'Paid',
            PaymentDate = CURDATE()
            WHERE LoanID = loanID AND DueDate = @DueDate;
        UPDATE Loan SET Balance = Balance - @Installment WHERE LoanID = loanID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Loan Already Paid';
    END IF;
    COMMIT;
END$$
Delimiter ;

-- Query Sep

DELIMITER $$
DROP PROCEDURE IF EXISTS submit_online_loan$$
-- Query Sep
Delimiter $$
CREATE PROCEDURE submit_online_loan ( IN FixedId varchar(20), IN branchID int, IN duration decimal(2), IN type varchar(15), IN amount decimal(15,2), IN userID int)
BEGIN
	START TRANSACTION;
    SELECT CustomerID INTO @CustomerID from Customer WHERE UserID = userID LIMIT 1;
    -- Check if the amount is greater than 500000 or 60% of the fixed deposit amount
    SELECT StartingAmount INTO @StartingAmount FROM FixedDeposit WHERE FixedId = FixedId LIMIT 1 FOR UPDATE;
    IF amount > 500000 OR amount > (@StartingAmount * 0.6) THEN
        -- Insert the rejected LoanApplication Entry
        INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, Amount, Status) 
        VALUES (
            NULL, 
            1, 
            FixedId,
            @CustomerID, 
            branchID, 
            duration, 
            type, 
            amount, 
            'Rejected');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Amount Exceeds Limit, Loan Rejected';
        rollback;
    ELSE
        SELECT InterestRate INTO @InterestRate FROM LoanInterestRate WHERE Duration = duration AND Type = type LIMIT 1;
        SET @CurDate = CURDATE();
        -- If not approve the loan and insert the entry
        INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, Amount, Status) 
            VALUES (
                NULL, 
                1, 
                FixedId,
                @CustomerID, 
                branchID, 
                duration, 
                type, 
                amount, 
                'Approved');
        -- Create the Loan Directly
        INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment, IsOnline) 
            VALUES (
                NULL, 
                @CustomerID, 
                LAST_INSERT_ID(), 
                amount, 
                amount,
                @CurDate, 
                @CurDate + INTERVAL duration MONTH,
                (amount +  (amount * @InterestRate * duration / 12 ))/ duration,
                1);
        SET @LoanID = LAST_INSERT_ID();
        -- Add Funds to the Savings Account Connected to the Fixed Deposit
        SELECT SavingsAccNo INTO @SavingsAccNo FROM FixedDeposit WHERE FixedId = FixedId LIMIT 1 FOR UPDATE;
        CALL add_trn(NULL, @SavingsAccNo, amount, 'Loan', 'Credited Loan Amount for LoanID: ' + @LoanID);
        SELECT @LoanID;
    END IF;
    COMMIT;
END$$

-- Query Sep

DELIMITER $$
DROP PROCEDURE IF EXISTS submit_offline_loan$$
-- Query Sep
Delimiter $$
CREATE PROCEDURE submit_offline_loan (in customerID int, in branchID int, in duration decimal(2), in type varchar(15), in amount decimal(15,2), in userID int)
BEGIN
	START TRANSACTION;
    SELECT EmployeeID INTO @EmployeeID FROM Employee WHERE UserID = userID LIMIT 1;
    -- Add the loan application entry
    INSERT INTO LoanApplication (LoanApplicationID, IsOnline, CustomerID, BranchID, Duration, Type, Amount, Status, CreatedBy) 
        VALUES (
            NULL, 
            0, 
            customerID, 
            branchID, 
            duration, 
            type,
            amount,
            'Pending',
            @EmployeeID
            );
	COMMIT;
END$$
DELIMITER ;

-- Query Sep

DELIMITER $$
DROP PROCEDURE IF EXISTS get_own_accounts$$
CREATE PROCEDURE get_own_accounts (in userID int)
BEGIN
    SELECT UserID, a.AccountNo, c.CustomerID, BranchID, Balance, SavingsPlanType, MonthlyTransactionCount 
		FROM Account a INNER JOIN Customer c 
        ON c.CustomerID = a.CustomerID 
        WHERE c.UserID = userID;
END$$
DELIMITER ;

-- Query Sep

DELIMITER $$
DROP PROCEDURE IF EXISTS add_customer$$
-- Query Sep
Delimiter $$
CREATE PROCEDURE add_customer (in Name varchar(100), in Email varchar(100), in Username varchar(50), 
in Password varchar(1000), in NIC_BR varchar(30), in Address varchar(155), in Phone varchar(15), 
in CustomerType varchar(30) , in DOB date)
BEGIN
    INSERT INTO User (UserID, Name, Email, Username, Role, Password) VALUES (NULL, Name, Email, Username, "customer", Password);
    INSERT INTO Customer (CustomerID, NIC_BR, Address, Phone, UserID, CustomerType, DOB) VALUES (NULL, NIC_BR, Address, Phone, last_insert_id(), CustomerType, DOB);
END$$

Delimiter ;

-- Query Sep