CREATE VIEW ManagerView AS 
SELECT BranchID, EmployeeID, UserID, Position, Name, Role, Username, Email FROM Employee NATURAL JOIN User WHERE IsManager = TRUE;

CREATE VIEW EmployeeView AS
SELECT BranchID, EmployeeID, UserID, Position, Name, Role, Username, Email FROM Employee NATURAL JOIN User WHERE IsManager = FALSE;

CREATE VIEW CustomerView AS
SELECT CustomerID, NIC_BR, DOB, Address, Phone, UserID, CustomerType, Name, Role, Username, Email FROM Customer NATURAL JOIN User;

CREATE VIEW SavingsAccountView AS
SELECT a.AccountNo, a.CustomerID, a.AccType, a.BranchID, a.Balance, s.SavingsPlanType, s.InterestRate, s.MinimumBalance FROM Account a LEFT JOIN SavingsPlan s ON a.SavingsPlanType = s.SavingsPlanType WHERE a.AccType = 'Savings';

CREATE VIEW ChildrenSavingsAccountView AS
SELECT s.AccountNo, s.CustomerID, c.ParentID, s.AccType, s.BranchID, s.Balance, s.SavingsPlanType, s.InterestRate, s.MinimumBalance FROM SavingsAccountView s LEFT JOIN ChildrensAccount c ON s.AccountNo=c.AccountNo WHERE s.SavingsPlanType = 'Children';

CREATE VIEW MonthlyTransactionView AS
SELECT TransactionID, FromAccNo, Amount, TrnType, Description, TimeStamp FROM Transaction WHERE TrnType in ('Online', 'ATM') AND MONTH(TimeStamp) = MONTH(CURDATE()) AND YEAR(TimeStamp) = YEAR(CURDATE());