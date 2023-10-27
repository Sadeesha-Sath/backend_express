CREATE VIEW ManagerView AS 
SELECT BranchID, EmployeeID, UserID, Position, Name, Role, Username, Email 
FROM Employee NATURAL JOIN User 
WHERE IsManager = TRUE;

-- Query Sep

CREATE VIEW EmployeeView AS
SELECT BranchID, EmployeeID, UserID, Position, Name, Role, Username, Email 
FROM Employee NATURAL JOIN User 
WHERE IsManager = FALSE;
-- Query Sep

CREATE VIEW CustomerView AS
SELECT CustomerID, NIC_BR, DOB, Address, Phone, UserID, 
CustomerType, Name, Role, Username, Email 
FROM Customer NATURAL JOIN User;
-- Query Sep

CREATE VIEW SavingsAccountView AS
SELECT a.AccountNo, a.CustomerID, a.BranchID, a.Balance, a.ParentID,
a.SavingsPlanType, s.InterestRate, s.MinimumBalance 
FROM Account a LEFT JOIN SavingsPlan s 
ON a.SavingsPlanType = s.SavingsPlanType 
WHERE a.SavingsPlanType is not null;
-- Query Sep

CREATE VIEW ChildrenSavingsAccountView AS
SELECT AccountNo, CustomerID, ParentID,
BranchID, Balance, SavingsPlanType, InterestRate, MinimumBalance 
FROM SavingsAccountView WHERE SavingsPlanType = 'Children';
-- Query Sep


DROP VIEW IF EXISTS PendingLoanApplicationsView;
-- Query Sep
CREATE VIEW PendingLoanApplicationsView AS 
SELECT * From LoanApplication WHERE Status = 'Pending';
-- Query Sep

DROP VIEW IF EXISTS PayableLoanInstallmentsView;
-- Query Sep
CREATE VIEW PayableLoanInstallmentsView AS 
SELECT * From LoanInstallment WHERE Status in ('Pending', 'Overdue');

-- Query Sep

DROP VIEW IF EXISTS MinimumBalanceView;
-- Query Sep
CREATE VIEW MinimumBalanceView AS
SELECT a.AccountNo as AccountNo, a.Balance as Balance, s.MinimumBalance as MinimumBalance, a.SavingsPlanType
FROM Account a INNER JOIN SavingsPlan s ON a.SavingsPlanType = s.SavingsPlanType
UNION
SELECT AccountNo, Balance, -100000, SavingsPlanType
FROM Account WHERE SavingsPlanType is null;
-- Query Sep
