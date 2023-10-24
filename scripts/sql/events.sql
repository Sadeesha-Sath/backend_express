CREATE EVENT IF NOT EXISTS add_installements
	ON schedule EVERY 1 MONTH
    STARTS '2023-11-01 00:00:00'
    COMMENT "Adds the Installements to the table on the start of every month"
    DO
		INSERT INTO LoanInstallment (LoanID, DueDate) SELECT LoanID, ADDDATE(curdate(), DATE(StartDate)) FROM Loan;
        
CREATE EVENT IF NOT EXISTS mark_overdue_installments
	ON schedule EVERY 1 DAY
    STARTS '2023-11-01 00:00:00'
    COMMENT "Checks and Updates the transactions as overdued"
    DO
		UPDATE LoanInstallment SET
        Status = 'Overdue' WHERE DueDate < curdate();

CREATE EVENT IF NOT EXISTS reset_trn_count
	ON schedule EVERY 1 MONTH
    STARTS '2023-11-01 00:00:00'
    COMMENT "Resets the Transaction Counts of Accounts"
    DO
		UPDATE Account SET MonthlyTransactionCount = 0;