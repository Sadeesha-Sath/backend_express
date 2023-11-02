
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
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, NULL, @TrnFee, 'TrnFee', CONCAT("Transaction Fee For Transaction ID: ", last_insert_id()));
        UPDATE Account SET MonthlyTransactionCount = MonthlyTransactionCount + 1 WHERE AccountNo = fromAccNo;
    END IF;
    COMMIT;
END$$
Delimiter ;
		

Delimiter $$
DROP PROCEDURE IF EXISTS approve_loan$$
create PROCEDURE approve_loan (in loanApplicationID int, in userID int)
BEGIN
	START TRANSACTION;
    SELECT CustomerID, Amount, Duration, Type INTO @customerID, @Amount, @Duration, @Type FROM LoanApplication WHERE LoanApplicationID = loanApplicationID LIMIT 1 FOR UPDATE;
    SELECT InterestRate INTO @InterestRate FROM LoanInterestRate WHERE Duration = @Duration AND Type = @Type LIMIT 1;
    SELECT EmployeeID INTO @EmployeeID FROM ManagerView WHERE UserID = userID LIMIT 1;
    SET @CurrDate = CURDATE();
    UPDATE LoanApplication SET 
        Status = 'Approved',
        CheckedDate = @CurrDate,
        CheckedBy = @EmployeeID
        WHERE LoanApplicationID = loanApplicationID;
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

Delimiter $$
DROP PROCEDURE IF EXISTS reject_loan$$
CREATE PROCEDURE reject_loan (in loanApplicationID int, in userID int)
BEGIN
	START TRANSACTION;
    SELECT EmployeeID  INTO @EmployeeID FROM ManagerView WHERE UserID = userID;
    UPDATE LoanApplication SET 
        Status = 'Rejected',
        CheckedDate = CURDATE(),
        CheckedBy = @EmployeeID
        WHERE LoanApplicationID = loanApplicationID;
    COMMIT;
END$$
Delimiter ;

Delimiter $$
DROP PROCEDURE IF EXISTS pay_installment$$
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

DELIMITER $$
DROP PROCEDURE IF EXISTS submit_online_loan$$
CREATE PROCEDURE submit_online_loan ( IN FixedId varchar(20), IN duration decimal(2), IN type varchar(15), IN amount decimal(15,2), IN userID int)
BEGIN
	START TRANSACTION;
    SELECT CustomerID INTO @CustomerID from Customer WHERE UserID = userID LIMIT 1;
    SELECT a.BranchID into @BranchID from FixedDeposit f Join Account a on f.SavingsAccNo=a.AccountNo WHERE f.FixedId = FixedId LIMIT 1 FOR UPDATE;
    -- Check if the amount is greater than 500000 or 60% of the fixed deposit amount
    SELECT StartingAmount INTO @StartingAmount FROM FixedDeposit WHERE FixedId = FixedId LIMIT 1 FOR UPDATE;
    IF amount > 500000 OR amount > (@StartingAmount * 0.6) THEN
		SET @ERRORAM = 1;
        -- Insert the rejected LoanApplication Entry
        INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, Amount, Status) 
        VALUES (
            NULL, 
            1, 
            FixedId,
            @CustomerID, 
            @BranchID, 
            duration, 
            type, 
            amount, 
            'Rejected');
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
                @BranchID, 
                duration, 
                type, 
                amount, 
                'Approved');
        -- Create the Loan Directly
        INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment, IsOnline, FixedId) 
            VALUES (
                NULL, 
                @CustomerID, 
                LAST_INSERT_ID(), 
                amount, 
                amount,
                @CurDate, 
                @CurDate + INTERVAL duration MONTH,
                (amount +  (amount * @InterestRate * duration / 12 ))/ duration,
                1, 
                FixedId
                );
        SET @LoanID = LAST_INSERT_ID();
        -- Add Funds to the Savings Account Connected to the Fixed Deposit
        SELECT SavingsAccNo INTO @SavingsAccNo FROM FixedDeposit WHERE FixedId = FixedId LIMIT 1 FOR UPDATE;
        CALL add_trn(NULL, @SavingsAccNo, amount, 'Loan', CONCAT('Credited Loan Amount for LoanID: ', @LoanID));
        SELECT @LoanID;
    END IF;
    COMMIT;
    IF @ERRORAM = 1 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Amount Exceeds Limit, Loan Rejected';
	END IF;
END$$

DELIMITER $$
DROP PROCEDURE IF EXISTS submit_offline_loan$$
CREATE PROCEDURE submit_offline_loan (in customerID int, in duration decimal(2), in type varchar(15), in amount decimal(15,2), in userID int)
BEGIN
	START TRANSACTION;
    SELECT EmployeeID, BranchID INTO @EmployeeID, @BranchID FROM Employee WHERE UserID = userID LIMIT 1;
    -- Add the loan application entry
    INSERT INTO LoanApplication (LoanApplicationID, IsOnline, CustomerID, BranchID, Duration, Type, Amount, Status, CreatedBy) 
        VALUES (
            NULL, 
            0, 
            customerID, 
            @BranchID, 
            duration, 
            type,
            amount,
            'Pending',
            @EmployeeID
            );
	COMMIT;
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS add_customer$$
CREATE PROCEDURE add_customer (in Name varchar(100), in Email varchar(100), in Username varchar(50), 
in Password varchar(1000), in NIC_BR varchar(30), in Address varchar(155), in Phone varchar(15), 
in CustomerType varchar(30) , in DOB date)
BEGIN
	START TRANSACTION;
    INSERT INTO User (UserID, Name, Email, Username, Role, Password) VALUES (NULL, Name, Email, Username, "customer", Password);
    INSERT INTO Customer (CustomerID, NIC_BR, Address, Phone, UserID, CustomerType, DOB) VALUES (NULL, NIC_BR, Address, Phone, last_insert_id(), CustomerType, DOB);
    COMMIT;
END$$

Delimiter ;



DELIMITER $$
DROP PROCEDURE IF EXISTS add_employee$$
CREATE PROCEDURE add_employee (in Name varchar(100), in Email varchar(100), in Username varchar(50), 
in Password varchar(1000), in BranchID int)
BEGIN
-- DECLARE EXIT HANDLER FOR SQLEXCEPTION
-- BEGIN
-- 	GET DIAGNOSTICS CONDITION 1
-- 	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
-- 	ROLLBACK;
--     SELECT @p1 as RETURNED_SQLSTATE  , @p2 as MESSAGE_TEXT;
-- END;
	START TRANSACTION;
    INSERT INTO User (UserID, Name, Email, Username, Role, Password) VALUES (NULL, Name, Email, Username, "employee", Password);
    INSERT INTO Employee (EmployeeID, BranchID, UserID, IsManager) VALUES (NULL, BranchID, last_insert_id(), 0);
    COMMIT;
END$$

Delimiter ;

DELIMITER $$
DROP PROCEDURE IF EXISTS add_fd$$
CREATE PROCEDURE add_fd (in SavingsAccNo varchar(20), SAmount decimal(15,2), in Duration decimal(2))
BEGIN
	START TRANSACTION;
    SELECT CONVERT(SUBSTRING(FixedID, 2), UNSIGNED) INTO @LastID FROM FixedDeposit ORDER BY FixedID DESC LIMIT 1 FOR UPDATE;
    SET @newID = CONCAT("F", LPAD(@LastID + 1 , 6, 0));
    INSERT INTO FixedDeposit (FixedId, SavingsAccNo, StartingAmount, Duration, StartDate, LastDeptDate) VALUES (@newID, SavingsAccNo, SAmount, Duration, curdate(), NULL);
    COMMIT;
END$$

Delimiter ;
