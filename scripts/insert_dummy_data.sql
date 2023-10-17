-- Insert data into Branch table
INSERT INTO Branch (BranchID, BranchName, Address, Phone, Email) VALUES 
('B001', 'Main Branch', '123 Main St, Cityville, XYZ', '123-456-7890', 'mainbranch@example.com'),
('B002', 'Downtown Branch', '456 Elm St, Cityville, XYZ', '987-654-3210', 'downtownbranch@example.com');

-- Insert data into User table
INSERT INTO User (UserID, Name, Role, Username, Email, Password) VALUES 
('U001', 'Admin User', 'admin', 'admin', 'admin@example.com', 'admin_password'),
('U002', 'Branch Manager', 'b_manager', 'manager_user', 'manager@example.com', 'manager_password'),
('U003', 'Employee User', 'employee', 'employee_user', 'employee@example.com', 'employee_password'),
('U004', 'Customer User 1', 'customer', 'customer_user_1', 'customer1@example.com', 'customer1_password'),
('U005', 'Customer User 2', 'customer', 'customer_user_2', 'customer2@example.com', 'customer2_password');

-- Insert data into Employee table
INSERT INTO Employee (EmployeeID, BranchID, UserID, Position, IsManager) VALUES 
('E001', 'B001', 'U002', 'Branch_Manager', TRUE),
('E002', 'B002', 'U003', 'Other', FALSE);

-- Insert data into Customer table
INSERT INTO Customer (CustomerID, NIC_BR, DOB, Address, Phone, UserID, CustomerType) VALUES 
('C001', '1234567890', '1990-01-15', '789 Oak St, Cityville, XYZ', '111-222-3333', 'U004', 'Individual'),
('C002', '0987654321', '1985-05-20', '101 Pine St, Cityville, XYZ', '444-555-6666', 'U005', 'Organization');

-- Insert data into SavingsPlan table
INSERT INTO SavingsPlan (SavingsPlanType, InterestRate, MinimumBalance) VALUES 
('Children', 0.12, 0),
('Teen', 0.11, 500),
('Adult', 0.10, 1000),
('Senior', 0.13, 1000);

-- Insert data into Account table
INSERT INTO Account (AccountNo, CustomerID, AccType, BranchID, Balance, SavingsPlanType, ParentID) VALUES 
('A001', 'C001', 'Savings', 'B001', 500, 'Adult', NULL),
('A002', 'C002', 'Savings', 'B001', 500, 'Children', 'C001'),
('A003', 'C001', 'Checking', 'B002', 1000, NULL, NULL);



-- Insert data into Transaction table
INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, TrnType, Amount) VALUES 
('T001', 'A001', 'A002', 'Online', 200),
('T002', 'A002', null, 'ATM', 50);

-- Insert data into FixedDeposit table
INSERT INTO FixedDeposit (FixedId, SavingsAccNo, StartingAmount, Duration, StartDate, LastDeptDate, InterestRate) VALUES 
('F001', 'A001', 1000, 6, '2023-01-01', '2023-07-01', 5.00),
('F002', 'A001', 2000, 12, '2023-01-01', '2024-01-01', 5.50);

-- Insert data into LoanApplication table
INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, CreatedBy, Amount, Status) VALUES 
('L001', TRUE, 'F001', 'C001', 'B001', 12, 'Business', 'E001', 5000, 'Approved'),
('L002', FALSE, NULL, 'C002', 'B002', 24, 'Personal', 'E002', 3000, 'Pending');

-- Insert data into Loan table
INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, StartDate, EndDate, Installment, Balance, IsOnline, FixedId) VALUES 
('L001', 'C001', 'L001', 5000, '2023-01-01', '2023-12-01', 500, 2000, TRUE, 'F001'),
('L002', 'C002', 'L002', 3000, '2023-01-01', '2025-01-01', 150, 2000, FALSE, NULL);

-- Insert data into LoanInterestRate table
INSERT INTO LoanInterestRate (Duration, Type, InterestRate) VALUES 
(12, 'Business', 0.08),
(24, 'Business', 0.10),
(12, 'Personal', 0.16),
(36, 'Personal', 0.17);

-- Insert data into LoanInstallment table
INSERT INTO LoanInstallment (LoanID, PaymentDate, DueDate, Status) VALUES 
('L001', '2023-02-01', '2023-02-01', 'Paid'),
('L002', '2023-02-01', '2023-02-01', 'Pending');

-- Insert data into FixedDepositInterestRate table
INSERT INTO FixedDepositInterestRate (Duration, InterestRate) VALUES 
(6, 0.13),
(12, 0.14),
(36, 0.15);
