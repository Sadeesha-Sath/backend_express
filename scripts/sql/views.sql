DROP VIEW IF EXISTS ManagerView;
CREATE VIEW ManagerView AS 
SELECT BranchID, EmployeeID, UserID, Name, Role, Username, Email 
FROM Employee NATURAL JOIN User 
WHERE IsManager = TRUE;

DROP VIEW IF EXISTS EmployeeView;
CREATE VIEW EmployeeView AS
SELECT b.BranchID, e.EmployeeID, u.UserID, u.Name, u.Role, u.Username, u.Email, b.BranchName
FROM Employee e LEFT JOIN User u on u.UserID = e.UserID LEFT JOIN Branch b on b.BranchID = e.BranchID;

DROP VIEW IF EXISTS CustomerView;
CREATE VIEW CustomerView AS
SELECT CustomerID, NIC_BR, DOB, Address, Phone, UserID, 
CustomerType, Name, Role, Username, Email 
FROM Customer NATURAL JOIN User;

DROP VIEW IF EXISTS BranchView;
CREATE VIEW BranchView AS
SELECT b.*, m.EmployeeID as ManagerID, m.Name as ManagerName 
FROM Branch b LEFT JOIN ManagerView m on b.BranchID=m.BranchID;

DROP VIEW IF EXISTS SavingsAccountView;
CREATE VIEW SavingsAccountView AS
SELECT a.AccountNo, a.CustomerID, a.BranchID, a.Balance, a.ParentID,
a.SavingsPlanType, s.InterestRate, s.MinimumBalance 
FROM Account a LEFT JOIN SavingsPlan s 
ON a.SavingsPlanType = s.SavingsPlanType 
WHERE a.SavingsPlanType is not null;

DROP VIEW IF EXISTS ChildrenSavingsAccountView;
CREATE VIEW ChildrenSavingsAccountView AS
SELECT AccountNo, CustomerID, ParentID,
BranchID, Balance, SavingsPlanType, InterestRate, MinimumBalance 
FROM SavingsAccountView WHERE SavingsPlanType = 'Children';

-- DROP VIEW IF EXISTS MonthlyTransactionCountView;
-- CREATE VIEW MonthlyTransactionCountView AS
-- SELECT a.AccountNo as AccountNo, 
-- COUNT(
-- t.TrnType in ('Online', 'ATM') 
-- AND MONTH(t.TimeStamp) = MONTH(CURDATE()) 
-- AND YEAR(t.TimeStamp) = YEAR(CURDATE()) ) AS Count
-- FROM Transaction t RIGHT OUTER JOIN Account a ON t.FromAccNo = a.AccountNo 
-- GROUP BY a.AccountNo ORDER BY a.AccountNo;

DROP VIEW IF EXISTS PendingLoanApplicationsView;
CREATE VIEW PendingLoanApplicationsView AS 
SELECT * From LoanApplication WHERE Status = 'Pending';

DROP VIEW IF EXISTS ActiveLoans;
CREATE VIEW ActiveLoans AS
SELECT * FROM Loan WHERE Balance > 0 AND EndDate > curdate();

DROP VIEW IF EXISTS LoanInstallmentView;
CREATE VIEW LoanInstallmentView AS
SELECT li.*, l.Installment, la.BranchID, l.CustomerID, c.UserID FROM LoanInstallment li INNER JOIN Loan l  ON li.LoanID = l.LoanID 
JOIN LoanApplication la ON l.LoanApplicationID=la.LoanApplicationID JOIN Customer c ON c.CustomerID=l.CustomerID;

DROP VIEW IF EXISTS PayableLoanInstallmentsView;
CREATE VIEW PayableLoanInstallmentsView AS 
SELECT * From LoanInstallmentView WHERE Status in ('Pending', 'Overdue');

DROP VIEW IF EXISTS FixedDepositView;
CREATE VIEW FixedDepositView AS
SELECT * FROM FixedDeposit NATURAL JOIN FixedDepositInterestRate;

DROP VIEW IF EXISTS MinimumBalanceView;
CREATE VIEW MinimumBalanceView AS
SELECT a.AccountNo as AccountNo, a.Balance as Balance, s.MinimumBalance as MinimumBalance, a.SavingsPlanType
FROM Account a INNER JOIN SavingsPlan s ON a.SavingsPlanType = s.SavingsPlanType
UNION
SELECT AccountNo, Balance, -100000, SavingsPlanType
FROM Account WHERE SavingsPlanType is null;

DROP VIEW IF EXISTS AccountView;
CREATE VIEW AccountView AS
SELECT a.AccountNo as AccountNo, a.Balance as Balance, a.CustomerID as CustomerID, 
	a.ParentID as ParentID, a.BranchID as BranchID, a.SavingsPlanType as SavingsPlanType,
    u2.Name as ParentName, a.MonthlyTransactionCount as MonthlyTransactionCount, b.BranchName as BranchName, 
    u1.Name as CustomerName, c.UserID as UserID 
    from Account a INNER JOIN Customer c on c.CustomerID = a.CustomerID
    INNER JOIN Branch b on b.BranchID = a.BranchID LEFT JOIN Customer p on p.CustomerID = a.ParentID
    INNER JOIN User u1 ON u1.UserID = c.UserID LEFT JOIN User u2 ON u2.UserID = p.UserID;
    
DROP VIEW IF EXISTS TransactionView;
CREATE VIEW TransactionView AS
(SELECT * FROM Transaction t LEFT JOIN AccountView a on t.FromAccNo=a.AccountNo) 
UNION (SELECT * FROM Transaction t LEFT JOIN AccountView a on t.ToAccNo=a.AccountNo);