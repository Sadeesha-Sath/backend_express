CREATE VIEW ManagerView AS 
SELECT BranchID, EmployeeID, UserID, Position, Name, Role, Username, Email 
FROM Employee NATURAL JOIN User 
WHERE IsManager = TRUE;

CREATE VIEW EmployeeView AS
SELECT BranchID, EmployeeID, UserID, Position, Name, Role, Username, Email 
FROM Employee NATURAL JOIN User 
WHERE IsManager = FALSE;

CREATE VIEW CustomerView AS
SELECT CustomerID, NIC_BR, DOB, Address, Phone, UserID, 
CustomerType, Name, Role, Username, Email 
FROM Customer NATURAL JOIN User;

CREATE VIEW SavingsAccountView AS
SELECT a.AccountNo, a.CustomerID, a.AccType, a.BranchID, a.Balance, a.ParentID,
s.SavingsPlanType, s.InterestRate, s.MinimumBalance 
FROM Account a LEFT JOIN SavingsPlan s 
ON a.SavingsPlanType = s.SavingsPlanType 
WHERE a.AccType = 'Savings';

CREATE VIEW ChildrenSavingsAccountView AS
SELECT AccountNo, CustomerID, ParentID, AccType, 
BranchID, Balance, SavingsPlanType, InterestRate, MinimumBalance 
FROM SavingsAccountView WHERE SavingsPlanType = 'Children';


CREATE VIEW MonthlyTransactionCountView AS
SELECT COUNT(*)
FROM Transaction 
WHERE TrnType in ('Online', 'ATM') 
AND MONTH(TimeStamp) = MONTH(CURDATE()) 
AND YEAR(TimeStamp) = YEAR(CURDATE()) GROUP BY FromAccNo;

CREATE VIEW PendingLoanApplications AS 
SELECT * From LoanApplication WHERE Status = 'Pending';