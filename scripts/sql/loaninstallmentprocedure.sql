DROP PROCEDURE IF EXISTS GetLoanInstallmentData;
DELIMITER //
CREATE PROCEDURE GetLoanInstallmentData(IN BrID varchar(20))
BEGIN
    SELECT LoanID, CustomerID, PaymentDate, DueDate From 
    LoanInstallment f 
    LEFT JOIN loanapplication la
        ON f.LoanId = la.LoanApplicationID
    WHERE la.BranchID = BrID AND f.status in ('Pending', 'Overdue');
            
END//
DELIMITER ;