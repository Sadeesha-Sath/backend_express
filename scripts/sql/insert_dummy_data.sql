-- Insert data into Branch table
INSERT INTO Branch (BranchID, BranchName, Address, Phone, Email) VALUES 
(NULL, 'Main Branch', '123 Main St, Cityville, XYZ', '123-456-7890', 'mainbranch@example.com'),
(NULL, 'Downtown Branch', '456 Elm St, Cityville, XYZ', '987-654-3210', 'downtownbranch@example.com');
-- Query Sep

-- Insert data into User table
INSERT INTO User (UserID, Name, Role, Username, Email, Password) VALUES 
(NULL, 'Admin User', 'admin', 'admin', 'admin@example.com', 'admin_password'),
(NULL, 'Branch Manager', 'b_manager', 'manager_user', 'manager@example.com', 'manager_password'),
(NULL, 'Employee User', 'employee', 'employee_user', 'employee@example.com', 'employee_password'),
(NULL, 'Customer User 1', 'customer', 'customer_user_1', 'customer1@example.com', 'customer1_password'),
(NULL, 'Customer User 2', 'customer', 'customer_user_2', 'customer2@example.com', 'customer2_password');
-- Query Sep

-- Insert data into Employee table
INSERT INTO Employee (EmployeeID, BranchID, UserID, Position, IsManager) VALUES 
(NULL, 1, 2, 'Branch_Manager', TRUE),
(NULL, 2, 3, 'Other', FALSE);
-- Query Sep

-- Insert data into Customer table
INSERT INTO Customer (CustomerID, NIC_BR, DOB, Address, Phone, UserID, CustomerType) VALUES 
(NULL, '1234567890', '1990-01-15', '789 Oak St, Cityville, XYZ', '111-222-3333', 4, 'Individual'),
(NULL, '0987654321', '1985-05-20', '101 Pine St, Cityville, XYZ', '444-555-6666', 5, 'Organization');
-- Query Sep

-- Insert data into SavingsPlan table
INSERT INTO SavingsPlan (SavingsPlanType, InterestRate, MinimumBalance) VALUES 
('Children', 0.12, 0),
('Teen', 0.11, 500),
('Adult', 0.10, 1000),
('Senior', 0.13, 1000);
-- Query Sep

-- Insert data into Account table
INSERT INTO Account (AccountNo, CustomerID, BranchID, Balance, SavingsPlanType, ParentID) VALUES 
('A000001', 1,  1, 1500, 'Adult', NULL),
('A000002', 2,  1, 2500, 'Children', 1),
('A000003', 1,  2, 2000, NULL, NULL);
-- Query Sep


-- Insert data into Transaction table
INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, TrnType, Amount) VALUES 
(NULL, 'A000001', 'A000002', 'Online', 200),
(NULL, 'A000002', null, 'ATM', 50);
-- Query Sep


-- Insert data into FixedDeposit table
INSERT INTO FixedDeposit (FixedId, SavingsAccNo, StartingAmount, Duration, StartDate, LastDeptDate, InterestRate) VALUES 
('F000001', 'A000001', 1000, 6, '2023-01-01', '2023-07-01', 5.00),
('F000002', 'A000001', 2000, 12, '2023-01-01', '2024-01-01', 5.50);

-- Query Sep

-- Insert data into LoanApplication table
INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, CreatedBy, Amount, Status, CheckedBy) VALUES 
(NULL, TRUE, 'F000001', 1, 1, 12, 'Business', NULL, 5000, 'Approved', NULL),
(NULL, FALSE, NULL, 2, 2, 24, 'Personal', 2, 3000, 'Approved', 1),
(NULL, FALSE, NULL, 2, 1, 36, 'Personal', 1, 6000, 'Pending', NULL);

-- Query Sep

-- Insert data into Loan table
INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, StartDate, EndDate, Installment, Balance, IsOnline, FixedId) VALUES 
(NULL, 1, 1, 5000, '2023-01-01', '2023-12-01', 500, 2000, TRUE, 'F000001'),
(NULL, 1, 2, 3000, '2023-01-01', '2025-01-01', 150, 2000, FALSE, NULL);

-- Query Sep

-- Insert data into LoanInterestRate table
INSERT INTO LoanInterestRate (Duration, Type, InterestRate) VALUES 
(12, 'Business', 0.08),
(24, 'Business', 0.10),
(12, 'Personal', 0.16),
(36, 'Personal', 0.17);

-- Query Sep

-- Insert data into LoanInstallment table
INSERT INTO LoanInstallment (LoanID, PaymentDate, DueDate, Status) VALUES 
(1, '2023-02-01', '2023-02-01', 'Paid'),
(2, '2023-02-01', '2023-02-01', 'Pending');

-- Query Sep

-- Insert data into FixedDepositInterestRate table
INSERT INTO FixedDepositInterestRate (Duration, InterestRate) VALUES 
(6, 0.13),
(12, 0.14),
(36, 0.15);

-- Query Sep