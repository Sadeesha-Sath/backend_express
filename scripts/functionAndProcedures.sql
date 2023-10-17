
Delimiter $$
DROP FUNCTION IF EXISTS add_trn$$
CREATE function add_trn(fromAccNo varchar(20), toAccNo varchar(20), amount decimal(15,2), trnType varchar(20), description varchar(100))
returns varchar(100)
BEGIN
	START TRANSACTION;
    -- If it's an online transaction
    SELECT @fromBalance := Balance, @accType := AccType FROM Account WHERE AccountNo = fromAccNo FOR UPDATE;
    IF (trnType = 'Online') THEN
        -- Check if the account has exceeded the monthly withdrawal limit
        IF (@accType = 'Savings') THEN
            SELECT COUNT(*) AS count INTO @count FROM MonthlyTransactionView WHERE FromAccNo = fromAccNo FOR UPDATE;
            IF @count > 5 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Monthly Transaction Limit Exceeded';
            END IF;
        END IF;
        -- TODO Check if this need to amended with the minimum balance of the account
        IF @fromBalance < amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Insufficient Balance';
        END IF;
        UPDATE Account SET Balance = Balance - amount WHERE AccountNo = fromAccNo;
        UPDATE Account SET Balance = Balance + amount WHERE AccountNo = toAccNo;
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, toAccNo, amount, 'Online', description);
        RETURN 'Transaction Successful';
    -- If it's a loan transfer
    ELSEIF (trnType = 'Loan') THEN
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  description) VALUES (NULL, NULL, toAccNo, amount, trnType, description);
        UPDATE Account SET Balance = Balance + amount WHERE AccountNo = toAccNo;
        RETURN 'Transaction Successful';
    -- If it's an ATM transaction
    ELSEIF (trnType = 'ATM') THEN
        -- Check if the account has exceeded the monthly withdrawal limit
        IF @accType = 'Savings' THEN
            SELECT COUNT(*) AS count INTO @count FROM MonthlyTransactionView WHERE FromAccNo = fromAccNo;
            IF @count > 5 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Monthly Transaction Limit Exceeded';
            END IF;
        END IF;
        SET @TrnFee := 30; -- Transaction Fee of an ATM Withdrawal
        -- TODO Check if this need to amended with the minimum balance of the account
        IF @fromBalance < (amount+@TrnFee) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Insufficient Balance';
        END IF;
        UPDATE Account SET Balance = Balance - amount - @TrnFee WHERE accountNo = fromAccNo;
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, NULL, amount, trnType, description);
        INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, Amount, TrnType,  Description) VALUES (NULL, fromAccNo, NULL, amount, 'TrnFee', "Transaction Fee for TransactionID: " + LAST_INSERT_ID());
        RETURN 'Transaction Successful';
    END IF;
    COMMIT;
END$$

DROP FUNCTION IF EXISTS approve_loan$$
create function approve_loan (loanApplicationID int, userID int)
returns int
BEGIN
	START TRANSACTION;
    SELECT @customerID := customerID, @Amount := Amount, @Duration: Duration FROM LoanApplication WHERE LoanApplicationID = loanApplicationID FOR UPDATE;
    SELECT @InterestRate := InterestRate FROM LoanInterestRate WHERE Duration = @Duration;
    SELECT @CurDate := CURDATE();
    SELECT @EmployeeID := EmployeeID FROM Employee WHERE UserID = userID;
    UPDATE LoanApplication SET 
        status = 'Approved',
        CheckedDate = @CurDate,
        CheckedBy = @EmployeeID
        WHERE LoanInApplicationID = loanApplicationID;
    INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment) 
        VALUES (
            NULL, 
            @customerID, 
            loanApplicationID, 
            @Amount, 
            @Amount,
            @CurDate, 
            @CurDate + INTERVAL @Duration MONTH,
            (@Amount +  (@Amount * @InterestRate * @Duration / 12 ))/ @Duration);
    SELECT @LoanID := LAST_INSERT_ID();
    FOR i IN 1..@Duration LOOP
    INSERT INTO LoanInstallment (LoanID, DueDate) VALUES (@LoanID, @CurDate + INTERVAL i MONTH);
    END LOOP;
    RETURN @LoanID;
    COMMIT;
END$$

DROP FUNCTION IF EXISTS reject_loan$$
CREATE function reject_loan (loanApplicationID int, userID int)
returns varchar(100)
BEGIN
	START TRANSACTION;
    SELECT EmployeeID AS EmployeeID INTO @EmployeeID FROM Employee WHERE UserID = userID;
    UPDATE LoanApplication SET 
        status = 'Rejected',
        CheckedDate = CURDATE(),
        CheckedBy = @EmployeeID
        WHERE LoanApplicationID = loanApplicationID;
    RETURN "Application Rejected";
    COMMIT;
END$$

DROP FUNCTION IF EXISTS pay_installement$$
CREATE FUNCTION pay_installement (loanID int)
returns varchar(100)
BEGIN
	START TRANSACTION;
    SELECT @Balance := Balance, @Installment := Installment FROM Loan WHERE LoanID = loanID FOR UPDATE;
    IF @Balance > 0 THEN
        SELECT @DueDate := DueDate FROM LoanInstallment WHERE LoanID = loanID AND Status in ('Pending', 'Overdue') ORDER BY DueDate  LIMIT 1 FOR UPDATE;
        IF @DueDate IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'No Pending Installment';
        END IF;
        UPDATE LoanInstallment SET 
            Status = 'Paid',
            PaymentDate = CURDATE()
            WHERE LoanID = loanID AND DueDate = @DueDate;
        UPDATE Loan SET Balance = Balance - @Installment WHERE LoanID = loanID;
        RETURN 'Payment Successful';
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Loan Already Paid';
    END IF;
    COMMIT;
END$$

DROP FUNCTION IF EXISTS submit_online_loan$$
CREATE FUNCTION submit_online_loan (FixedId int, branchID int, duration decimal(2), type varchar(15), amount decimal(15,2), userID int)
returns int
BEGIN
	START TRANSACTION;
    SELECT @CustomerID := CustomerID from Customer WHERE UserID = userID;
    -- Check if the amount is greater than 500000 or 60% of the fixed deposit amount
    SELECT @StartingAmount := StartingAmount FROM FixedDeposit WHERE FixedId = FixedId FOR UPDATE;
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
    ELSE
        SELECT @InterestRate := InterestRate FROM LoanInterestRate WHERE Duration = duration AND Type = type;
        SELECT @CurDate := CURDATE();
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
        SELECT @LoanApplicationID := LAST_INSERT_ID();
        -- Create the Loan Directly
        INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment, IsOnline) 
            VALUES (
                NULL, 
                @CustomerID, 
                @LoanApplicationID, 
                amount, 
                amount,
                @CurDate, 
                @CurDate + INTERVAL duration MONTH,
                (amount +  (amount * @InterestRate * duration / 12 ))/ duration,
                1);
        SELECT @LoanID := LAST_INSERT_ID();
        -- Add Funds to the Savings Account Connected to the Fixed Deposit
        SELECT @SavingsAccNo := SavingsAccNo FROM FixedDeposit WHERE FixedId = FixedId FOR UPDATE;
        add_trn(NULL, @SavingsAccNo, amount, 'Loan', 'Credited Loan Amount for LoanID: ' + @LoanID);
        FOR i IN 1..duration LOOP
        INSERT INTO LoanInstallment (LoanID, DueDate) VALUES (@LoanID, @CurDate + INTERVAL i MONTH);
        END LOOP;
        RETURN @LoanID;
    END IF;
    COMMIT;
END$$

DROP FUNCTION IF EXISTS submit_offline_loan$$
CREATE FUNCTION submit_offline_loan (customerID int, branchID int, duration decimal(2), type varchar(15), amount decimal(15,2), userID int)
returns varchar(100)
BEGIN
	START TRANSACTION;
    SELECT @InterestRate := InterestRate FROM LoanInterestRate WHERE Duration = duration AND Type = type;
    SELECT @EmployeeID := EmployeeID FROM Employee WHERE UserID = userID;
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

-- DROP FUNCTION IF EXISTS get_own_account$$
-- CREATE FUNCTION get_own_account (userID int)
-- RETURNS @ReturnTable table (
--     AccountNo varchar(20),
--     CustomerID int,
--     AccType varchar(10) check (AccType in ('Savings', 'Checking')),
--     BranchID int,
--     Balance decimal(15,2),
--     SavingsPlanType varchar(20),
-- )
-- AS
-- BEGIN ATOMIC
--     SELECT @CustomerID := CustomerID FROM Customer WHERE UserID = userID;
--     RETURN TABLE (SELECT AccountNo, CustomerID, AccType, BranchID, Balance, SavingsPlanType FROM Account WHERE CustomerID = @CustomerID);
-- END$$

-- DROP FUNCTION IF EXISTS get_own_loan$$
-- CREATE FUNCTION add_customer (Name varchar(100), Email varchar(100), Username varchar(50), Password varchar(1000), NIC_BR varchar(30), Address varchar(155), Phone varchar(15),CustomerType int , DOB date)
-- returns TABLE (
--     Username varchar(100),
--     Email varchar(100)
-- )
-- AS
-- BEGIN ATOMIC
--     INSERT INTO User (UserID, Name, Email, Username, Password) VALUES (NULL, Name, Email, Username, Password);
--     INSERT INTO Customer (CustomerID, NIC_BR, Address, Phone, UserID, CustomerType, DOB) VALUES (NULL, NIC_BR, Address, Phone, LAST_INSERT_ID(), CustomerType, DOB);
-- END$$


Delimiter ;