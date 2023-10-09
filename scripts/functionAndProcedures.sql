
create function add_trn(fromAccNo int, toAccNo int, amount decimal(15,2), trnType varchar(20), description varchar(100))
returns varchar (100)
BEGIN ATOMIC
    IF (trnType = 'Online') THEN
        IF @accType = 'Savings' THEN
            SELECT COUNT(*) INTO @count FROM Transaction WHERE fromAccNo = fromAccNo AND trnType in ('Online', 'ATM') AND MONTH(transactionDate) = MONTH(CURDATE());
            IF @count > 5 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Monthly Transaction Limit Exceeded';
            END IF;
        END IF;
        SELECT @fromBalance := balance @accType := accType FROM Account WHERE accountNo = fromAccNo FOR UPDATE;
        IF @fromBalance < amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Insufficient Balance';
        END IF;
        UPDATE Account SET balance = balance - amount WHERE accountNo = fromAccNo;
        UPDATE Account SET balance = balance + amount WHERE accountNo = toAccNo;
        INSERT INTO Transaction (transactionID, fromAccNo, toAccNo, amount, trnType,  description) VALUES (NULL, fromAccNo, toAccNo, amount, 'Online', description);
        RETURN 'Transaction Successful';
    -- If it's a loan transfer
    ELSE IF (trnType = 'Loan') THEN
        INSERT INTO Transaction (transactionID, fromAccNo, toAccNo, amount, trnType,  description) VALUES (NULL, NULL, toAccNo, amount, trnType, description);
        UPDATE Account SET balance = balance + amount WHERE accountNo = toAccNo;
        RETURN 'Transaction Successful';
    -- If it's an ATM transaction
    ELSE IF (trnType = 'ATM') THEN
        IF @accType = 'Savings' THEN
            SELECT COUNT(*) INTO @count FROM Transaction 
                WHERE fromAccNo = fromAccNo AND trnType in ('Online', 'ATM') AND MONTH(transactionDate) = MONTH(CURDATE());
            IF @count > 5 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Monthly Transaction Limit Exceeded';
            END IF;
        END IF;
        SELECT @fromBalance := balance FROM Account WHERE accountNo = fromAccNo FOR UPDATE;
        SET @TrnFee := 30;
        IF @fromBalance < (amount+@TrnFee) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Insufficient Balance';
        END IF;
        UPDATE Account SET balance = balance - amount - @TrnFee WHERE accountNo = fromAccNo;
        INSERT INTO Transaction (transactionID, fromAccNo, toAccNo, amount, trnType,  description) VALUES (NULL, fromAccNo, NULL, amount, trnType, description);
        INSERT INTO Transaction (transactionID, fromAccNo, toAccNo, amount, trnType,  description) VALUES (NULL, fromAccNo, NULL, amount, 'TrnFee', "Transaction Fee for TransactionID: " + LAST_INSERT_ID());
        RETURN 'Transaction Successful';
    END IF;
END;

create function approve_loan (loanApplicationID int)
returns int
BEGIN ATOMIC
    SELECT @customerID := customerID, @Amount := Amount, @Duration: Duration FROM LoanApplication WHERE LoanApplicationID = loanApplicationID FOR UPDATE;
    SELECT @InterestRate := InterestRate FROM LoanInterestRate WHERE Duration = @Duration;
    SELECT @CurDate := CURDATE();
    UPDATE LoanApplication SET 
        status = 'Approved',
        ApprovedDate = @CurDate
        WHERE LoanInApplicationID = loanApplicationID;
    INSERT INTO Loan (LoanID, customerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment) 
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
END;

CREATE function reject_loan (loanApplicationID int)
returns int
BEGIN ATOMIC
    UPDATE LoanApplication SET status = 'Rejected' WHERE LoanApplicationID = loanApplicationID;
    RETURN 1;
END;

CREATE FUNCTION pay_installement (loanID int)
returns varchar(100)
BEGIN ATOMIC
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
END;

CREATE FUNCTION submit_online_loan (FixedId int, customerID int, branchID int, duration decimal(2), type varchar(15), amount decimal(15,2))
returns int
BEGIN ATOMIC
    -- Check if the amount is greater than 500000 or 60% of the fixed deposit amount
    SELECT @StartingAmount := StartingAmount FROM FixedDeposit WHERE FixedId = FixedId FOR UPDATE;
    IF amount > 500000 OR amount > (@StartingAmount * 0.6) THEN
        -- Insert the rejected LoanApplication Entry
        INSERT INTO LoanApplication (LoanApplicationID, isOnline, FixedId, CustomerID, BranchID, Duration, Type, ApplicationDate, Amount, Status) 
        VALUES (
            NULL, 
            1, 
            FixedId
            customerID, 
            branchID, 
            duration, 
            type, 
            @CurDate, 
            amount, 
            'Rejected');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  'Amount Exceeds Limit, Loan Rejected';
    ELSE
        SELECT @InterestRate := InterestRate FROM LoanInterestRate WHERE Duration = duration AND Type = type;
        SELECT @CurDate := CURDATE();
        -- If not approve the loan and insert the entry
        INSERT INTO LoanApplication (LoanApplicationID, isOnline, FixedId, CustomerID, BranchID, Duration, Type, ApplicationDate, Amount, Status) 
            VALUES (
                NULL, 
                1, 
                FixedId
                customerID, 
                branchID, 
                duration, 
                type, 
                @CurDate, 
                amount, 
                'Approved');
        SELECT @LoanApplicationID := LAST_INSERT_ID();
        -- Create the Loan Directly
        INSERT INTO Loan (LoanID, customerID, LoanApplicationID, Amount, Balance, StartDate, EndDate, Installment, isOnline) 
            VALUES (
                NULL, 
                customerID, 
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
END;

