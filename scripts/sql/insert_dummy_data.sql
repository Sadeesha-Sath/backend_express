-- Insert data into Branch table
INSERT INTO Branch (BranchID, BranchName, Address, Phone, Email) VALUES 
(NULL, 'Main Branch', '123 Main St, Cityville, XYZ', '123-456-7890', 'mainbranch@example.com'),
(NULL, 'Downtown Branch', '456 Elm St, Cityville, XYZ', '987-654-3210', 'downtownbranch@example.com');

-- Insert data into User table
INSERT INTO User (UserID, Name, Role, Username, Email, Password) VALUES 
(NULL, 'Admin User', 'admin', 'admin', 'admin@example.com', '$2b$10$JYcMGTZfSfpz3oD0498wtOdfaGdGsy/Py3icvh5ZVfb4Hj4fDsBO.'),
(NULL, 'Branch Manager', 'b_manager', 'manager_user', 'manager@example.com', '$2b$10$0ACZyZps4n2ayvW7CeAqqufx9diEOqEya6gq/msR87Auwp.r/Q0s6'),
(NULL, 'Employee User', 'employee', 'employee_user', 'employee@example.com', '$2b$10$HgWOVugy3gF6/P5vd.jJxuBSTAftEotigQ.MkGMHovsIqWg9Y1Ocm'),
(NULL, 'Customer User 1', 'customer', 'customer_user_1', 'customer1@example.com', '$2b$10$vIIOFCWy2yU5n8locNEOiuQ7yv3xrvGeoMt5WlQEGH6ym90Tl5zM2'),
(NULL, 'Customer User 2', 'customer', 'customer_user_2', 'customer2@example.com', '$2b$10$yPjeOyUKqHYzfWlC4LcJS.2AUHOQHBQbLkUzlUX7vJQgJqhObz2KC');

-- Insert data into Employee table
INSERT INTO Employee (EmployeeID, BranchID, UserID, IsManager) VALUES 
(NULL, 1, 2, TRUE),
(NULL, 2, 3, FALSE);

-- Insert data into Customer table
INSERT INTO Customer (CustomerID, NIC_BR, DOB, Address, Phone, UserID, CustomerType) VALUES 
(NULL, '1234567890', '1990-01-15', '789 Oak St, Cityville, XYZ', '111-222-3333', 4, 'Individual'),
(NULL, '0987654321', NULL, '101 Pine St, Cityville, XYZ', '444-555-6666', 5, 'Organization');

-- Insert data into SavingsPlan table
INSERT INTO SavingsPlan (SavingsPlanType, InterestRate, MinimumBalance) VALUES 
('Children', 0.12, 0),
('Teen', 0.11, 500),
('Adult', 0.10, 1000),
('Senior', 0.13, 1000);

-- Insert data into Account table
INSERT INTO Account (AccountNo, CustomerID, BranchID, Balance, SavingsPlanType, ParentID) VALUES 
('A000001', 1,  1, 1500, 'Adult', NULL),
('A000002', 2,  1, 2500, 'Children', 1),
('A000003', 1,  2, 2000, NULL, NULL);



-- Insert data into Transaction table
INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, TrnType, Amount) VALUES 
(NULL, 'A000001', 'A000002', 'Online', 200),
(NULL, 'A000002', null, 'ATM', 50);

-- Insert data into FixedDepositInterestRate table
INSERT INTO FixedDepositInterestRate (Duration, InterestRate) VALUES 
(6, 0.13),
(12, 0.14),
(36, 0.15);


-- Insert data into FixedDeposit table
INSERT INTO FixedDeposit (FixedId, SavingsAccNo, StartingAmount, Duration, StartDate, LastDeptDate) VALUES 
('F000001', 'A000001', 1000, 6, '2023-01-01', '2023-07-01'),
('F000002', 'A000001', 2000, 12, '2023-01-01', '2024-01-01');

-- Insert data into LoanApplication table
INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, CreatedBy, Amount, Status, CheckedBy) VALUES 
(NULL, TRUE, 'F000001', 1, 1, 12, 'Business', NULL, 5000, 'Approved', NULL),
(NULL, FALSE, NULL, 2, 2, 24, 'Personal', 2, 3000, 'Approved', 1),
(NULL, FALSE, NULL, 2, 1, 36, 'Personal', 1, 6000, 'Pending', NULL);

-- Insert data into Loan table
INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, StartDate, EndDate, Installment, Balance, IsOnline, FixedId) VALUES 
(NULL, 1, 1, 5000, '2023-01-01', '2023-12-01', 500, 2000, TRUE, 'F000001'),
(NULL, 1, 2, 3000, '2023-01-01', '2025-01-01', 150, 2000, FALSE, NULL);

-- Insert data into LoanInterestRate table
INSERT INTO LoanInterestRate (Duration, Type, InterestRate) VALUES 
(12, 'Business', 0.08),
(24, 'Business', 0.10),
(12, 'Personal', 0.16),
(36, 'Personal', 0.17);

-- Insert data into LoanInstallment table
INSERT INTO LoanInstallment (LoanID, PaymentDate, DueDate, Status) VALUES 
(1, '2023-02-01', '2023-02-01', 'Paid'),
(2, '2023-02-01', '2023-02-01', 'Pending');


-- Insert  extra data into Branch table
INSERT INTO Branch (BranchID, BranchName, Address, Phone, Email) VALUES 
(NULL, 'Maincity Branch', '123 Maincity St, Cityville, XYZ', '123-456-7891', 'Maincity@example.com'),
(NULL, 'Downcity Branch', '456 down St, Cityville, XYZ', '987-654-3211', 'Downcity@example.com'),
(NULL, 'Upcity Branch', '789 upcity St, Cityville, XYZ', '123-456-7892', 'Upcity@example.com'),
(NULL, 'midcity Branch', '987 midcity St, Cityville, XYZ', '987-654-3212', 'midcity@example.com'),
(NULL, 'city Branch', '321 city St, Cityville, XYZ', '123-456-7893', 'city@example.com'),
(NULL, 'subcity Branch', '654 subcity St, Cityville, XYZ', '987-654-3213', 'subcity@example.com'),
(NULL, 'outcity Branch', '741 outcity St, Cityville, XYZ', '123-456-7894', 'outcity@example.com'),
(NULL, 'backcity Branch', '147 backcity St, Cityville, XYZ', '987-654-3214', 'backcity@example.com'),
(NULL, 'Maintown Branch', '123 Maintown St, townville, XYZ', '123-456-7895', 'Maintown@example.com'),
(NULL, 'Uptown Branch', '789 uptown St, townville, XYZ', '123-456-7896', 'Uptown@example.com'),
(NULL, 'midtown Branch', '987 midtown St, townville, XYZ', '987-654-3215', 'midtown@example.com'),
(NULL, 'town Branch', '321 town St, townville, XYZ', '123-456-7897', 'town@example.com'),
(NULL, 'subtown Branch', '654 subtown St, townville, XYZ', '987-654-3216', 'subtown@example.com'),
(NULL, 'outtown Branch', '741 outtown St, townville, XYZ', '123-456-7898', 'outtown@example.com'),
(NULL, 'backtown Branch', '147 backtown St, townville, XYZ', '987-654-3217', 'backtown@example.com');

-- Insert data into User table
-- INSERT INTO User (UserID, Name, Role, Username, Email, Password) VALUES 
--  (NULL, 'Johnson', 'admin', 'johnson123', 'johnsonh56@user.abc.com', '$2b$10$5Cctq7UmalPt3otqeFRnLOdYC4Z72WIXGvrKww5AD0Za1hA8zZCaO'),
--  (NULL, 'Kumara', 'admin', 'kumara222', 'kumarakm12@user.abc.com', '$2b$10$QBwnM5vd3C0PHDPoJoBr9uCpkfB9qtF6zfcuuFL6O9BCWJZwdPlze'),
--  (NULL, 'Albert', 'b_manger', 'albert121', 'alberts@user.abc.com', '$2b$10$RNGhaoT6u39eho.CHQBg5ehlmgaC3cuhp.POLi26uS3qI6CaRkIiC'),
--  (NULL, 'Roy', 'b_manager', 'roy555', 'roylmp@user.abc.com', '$2b$10$BormtLdDJPqcA1D.f.EAjO8UIW2PIuVvOqL.r91U7LEXLC.YVlKB2'),
--  (NULL, 'Silva', 'b_manger', 'silva123', 'silvasilva@user.abc.com', '$2b$10$uj8j6CX6J8T/jvJK8rlXvu0yEvS/TxuZYwIxKSp6X3h7GXr4ioZb.'),
--  (NULL, 'Ram', 'b_manger', 'ram969', 'ramraj9@user.abc.com', '$2b$10$N4kCtfjQcwUfwt.BGPetPuz/TIf6nXMLCK4OFoxDguuyvBykf8Huu'),
--  (NULL, 'Perera', 'b_manger', 'perera698', 'pererast@user.abc.com', '$2b$10$CuughPK2242qwfJGvT5ddegcGxn/V/z7HSzN11q.KBGpA4w7vcskK'),
--  (NULL, 'Silva', 'employee', 'silva222', 'silva404@user.abc.com', '$2b$10$tohRY6LmKULm5kz05yD7l.9IOYk46tOZIuzbpygeL9U35B3/tpPAu'),
--  (NULL, 'David', 'employee', 'david555', 'davidpil@user.abc.com', '$2b$10$WZlXfvXEbFMzLNTkp.G6R.iuyKbtUfTFPrhvryOeNZzDYyJqewP2C'),
--  (NULL, 'Charlie', 'employee', 'charlie969', 'charliest@user.abc.com', '$2b$10$ReCpWTYUv02.uclUBsfHf.bvBddXvOwzw2HWdExq1zktziarz.eoe'),
--  (NULL, 'Perera', 'employee', 'perera123', 'perera96@user.abc.com', '$2b$10$iXqt2BQybg130XUBTWc.vuNO7n3Wj7k2MrQnGNf5Wv3Pu3b.sKk2q'),
--  (NULL, 'Nimal', 'employee', 'nimal555', 'nimal69@user.abc.com', '$2b$10$kiZG/hDioVacTFdSkW0FeOtbP.yHwEGFiIMLD9fxKxRsJS/wtnVUm'),
--  (NULL, 'Supun', 'employee', 'supun886', 'supunmal@user.abc.com', '$2b$10$OoRS/eWzcQiGCjb7SPjXv.xhQMNuamntQTDr8N9X4Ey2i/CdkxVYG'),
--  (NULL, 'Harsha', 'employee', 'harsha455', 'harshaf@user.abc.com', '$2b$10$4lpZmy/Ylh9O0cJxkImn5.gK/mgDh.bXDkumZ9DduXlkwz5EmRgLy'),
--  (NULL, 'Robert', 'customer', 'robert555', 'robert2001@user.abc.com', '$2b$10$2mH9W8Xiu3QIElJCodl7xOQbJPfEVsVLVL5FYVkqGO2daUVfS8CYW'),
--  (NULL, 'Khan', 'customer', 'khan223', 'ikhan@user.abc.com', '$2b$10$/N98lodF5fxSEVqV9bDOyuqsldK1ceC66A5q9qlR6hEDxhvQnG5ya'),
--  (NULL, 'Sumudu', 'customer', 'sumudu336', 'sumuduhm@user.abc.com', '$2b$10$y.pBB2uUj3vMZlVWlFs1EuNx2ShUMTkeC1w5KV9bBFRSGlosGCZIK'),
--  (NULL, 'Raju stores', 'customer', 'raju889', 'yraju9@user.abc.com', '$2b$10$66o4L8FD5hZUbtj0HWJ38ea0k9W4eqscG5YaDPq3/9xerLhFlwQOS'),
--  (NULL, 'Poojah', 'customer', 'poojah123', 'poojah001@user.abc.com', '$2b$10$P9IunkYcwOcFROW5PvRgeONfIf0KTJXu1/fvDFLW4DsHZGUxg3tLS'),
--  (NULL, 'Nissanka', 'customer', 'nissanka555', 'nissankam@user.abc.com', '$2b$10$I86hJWbpE9NdzObrmfAZT.fZH3vq90cSrW9f831Q3OzkDp/73AZiW'),
--  (NULL, 'Mendis', 'customer', 'mendis222', 'mendiskk2@user.abc.com', '$2b$10$NPSHHb4t2A7stxGgAgux.O0pb.NKK.tYXKpIkxauGVN.lpz3y6bJ6'),
--  (NULL, 'Sam', 'customer', 'sam111', 'samr@user.abc.com', '$2b$10$AYFIGCzJoQzvg1WG8VJc3ebuQ5JzCjsYOXVMknyT60HyJIcrQ87t6'),
--  (NULL, 'David furtitures', 'customer', 'david425', 'david99@user.abc.com', '$2b$10$kKjRrx3xLVlTCvsR76hlseMFyx2wfm28b5ciwruTM.wyA2LhMW/2a'),
--  (NULL, 'Akila', 'customer', 'akila404', 'sakila@user.abc.com', '$2b$10$NCLKzUw93EqPNsmOiun9IOnWpNGIDNksjo8VHT.GJZonJ6EwXkTba');

-- Insert data into User table
INSERT INTO User (UserID, Name, Role, Username, Email, Password) VALUES 
 (NULL, 'Albert', 'b_manager', 'albert121', 'alberts@user.abc.com', '$2b$10$RNGhaoT6u39eho.CHQBg5ehlmgaC3cuhp.POLi26uS3qI6CaRkIiC'),
 (NULL, 'Roy', 'b_manager', 'roy555', 'roylmp@user.abc.com', '$2b$10$BormtLdDJPqcA1D.f.EAjO8UIW2PIuVvOqL.r91U7LEXLC.YVlKB2'),
 (NULL, 'Silva', 'b_manager', 'silva123', 'silvasilva@user.abc.com', '$2b$10$uj8j6CX6J8T/jvJK8rlXvu0yEvS/TxuZYwIxKSp6X3h7GXr4ioZb.'),
 (NULL, 'Ram', 'b_manager', 'ram969', 'ramraj9@user.abc.com', '$2b$10$N4kCtfjQcwUfwt.BGPetPuz/TIf6nXMLCK4OFoxDguuyvBykf8Huu'),
 (NULL, 'Perera', 'b_manager', 'perera698', 'pererast@user.abc.com', '$2b$10$CuughPK2242qwfJGvT5ddegcGxn/V/z7HSzN11q.KBGpA4w7vcskK'),
 (NULL, 'Silva', 'employee', 'silva222', 'silva404@user.abc.com', '$2b$10$tohRY6LmKULm5kz05yD7l.9IOYk46tOZIuzbpygeL9U35B3/tpPAu'),
 (NULL, 'David', 'employee', 'david555', 'davidpil@user.abc.com', '$2b$10$WZlXfvXEbFMzLNTkp.G6R.iuyKbtUfTFPrhvryOeNZzDYyJqewP2C'),
 (NULL, 'Charlie', 'employee', 'charlie969', 'charliest@user.abc.com', '$2b$10$ReCpWTYUv02.uclUBsfHf.bvBddXvOwzw2HWdExq1zktziarz.eoe'),
 (NULL, 'Perera', 'employee', 'perera123', 'perera96@user.abc.com', '$2b$10$iXqt2BQybg130XUBTWc.vuNO7n3Wj7k2MrQnGNf5Wv3Pu3b.sKk2q'),
 (NULL, 'Nimal', 'employee', 'nimal555', 'nimal69@user.abc.com', '$2b$10$kiZG/hDioVacTFdSkW0FeOtbP.yHwEGFiIMLD9fxKxRsJS/wtnVUm'),
 (NULL, 'Supun', 'employee', 'supun886', 'supunmal@user.abc.com', '$2b$10$OoRS/eWzcQiGCjb7SPjXv.xhQMNuamntQTDr8N9X4Ey2i/CdkxVYG'),
 (NULL, 'Harsha', 'customer', 'harsha455', 'harshaf@user.abc.com', '$2b$10$4lpZmy/Ylh9O0cJxkImn5.gK/mgDh.bXDkumZ9DduXlkwz5EmRgLy'),
 (NULL, 'Robert', 'customer', 'robert555', 'robert2001@user.abc.com', '$2b$10$2mH9W8Xiu3QIElJCodl7xOQbJPfEVsVLVL5FYVkqGO2daUVfS8CYW'),
 (NULL, 'Khan', 'customer', 'khan223', 'ikhan@user.abc.com', '$2b$10$/N98lodF5fxSEVqV9bDOyuqsldK1ceC66A5q9qlR6hEDxhvQnG5ya'),
 (NULL, 'Sumudu', 'customer', 'sumudu336', 'sumuduhm@user.abc.com', '$2b$10$y.pBB2uUj3vMZlVWlFs1EuNx2ShUMTkeC1w5KV9bBFRSGlosGCZIK'),
 (NULL, 'Raju stores', 'customer', 'raju889', 'yraju9@user.abc.com', '$2b$10$66o4L8FD5hZUbtj0HWJ38ea0k9W4eqscG5YaDPq3/9xerLhFlwQOS'),
 (NULL, 'Poojah', 'customer', 'poojah123', 'poojah001@user.abc.com', '$2b$10$P9IunkYcwOcFROW5PvRgeONfIf0KTJXu1/fvDFLW4DsHZGUxg3tLS'),
 (NULL, 'Nissanka', 'customer', 'nissanka555', 'nissankam@user.abc.com', '$2b$10$I86hJWbpE9NdzObrmfAZT.fZH3vq90cSrW9f831Q3OzkDp/73AZiW'),
 (NULL, 'Mendis', 'customer', 'mendis222', 'mendiskk2@user.abc.com', '$2b$10$NPSHHb4t2A7stxGgAgux.O0pb.NKK.tYXKpIkxauGVN.lpz3y6bJ6'),
 (NULL, 'Sam', 'customer', 'sam111', 'samr@user.abc.com', '$2b$10$AYFIGCzJoQzvg1WG8VJc3ebuQ5JzCjsYOXVMknyT60HyJIcrQ87t6'),
 (NULL, 'David furtitures', 'customer', 'david425', 'david99@user.abc.com', '$2b$10$kKjRrx3xLVlTCvsR76hlseMFyx2wfm28b5ciwruTM.wyA2LhMW/2a'),
 (NULL, 'Akila', 'customer', 'akila404', 'sakila@user.abc.com', '$2b$10$NCLKzUw93EqPNsmOiun9IOnWpNGIDNksjo8VHT.GJZonJ6EwXkTba');

-- Insert  extra data into Branch table
INSERT INTO Branch (BranchID, BranchName, Address, Phone, Email) VALUES 
(NULL, 'Maincity Branch', '123 Maincity St, Cityville, XYZ', '123-456-7891', 'Maincity@example.com'),
(NULL, 'Downcity Branch', '456 down St, Cityville, XYZ', '987-654-3211', 'Downcity@example.com'),
(NULL, 'Upcity Branch', '789 upcity St, Cityville, XYZ', '123-456-7892', 'Upcity@example.com'),
(NULL, 'midcity Branch', '987 midcity St, Cityville, XYZ', '987-654-3212', 'midcity@example.com'),
(NULL, 'city Branch', '321 city St, Cityville, XYZ', '123-456-7893', 'city@example.com'),
(NULL, 'subcity Branch', '654 subcity St, Cityville, XYZ', '987-654-3213', 'subcity@example.com'),
(NULL, 'outcity Branch', '741 outcity St, Cityville, XYZ', '123-456-7894', 'outcity@example.com'),
(NULL, 'backcity Branch', '147 backcity St, Cityville, XYZ', '987-654-3214', 'backcity@example.com'),
(NULL, 'Maintown Branch', '123 Maintown St, townville, XYZ', '123-456-7895', 'Maintown@example.com'),
(NULL, 'Uptown Branch', '789 uptown St, townville, XYZ', '123-456-7896', 'Uptown@example.com'),
(NULL, 'midtown Branch', '987 midtown St, townville, XYZ', '987-654-3215', 'midtown@example.com'),
(NULL, 'town Branch', '321 town St, townville, XYZ', '123-456-7897', 'town@example.com'),
(NULL, 'subtown Branch', '654 subtown St, townville, XYZ', '987-654-3216', 'subtown@example.com'),
(NULL, 'outtown Branch', '741 outtown St, townville, XYZ', '123-456-7898', 'outtown@example.com'),
(NULL, 'backtown Branch', '147 backtown St, townville, XYZ', '987-654-3217', 'backtown@example.com');

Insert INTO Customer (CustomerID, NIC_BR, DOB, Address, Phone, UserID, CustomerType) VALUES
	(NULL, 123456123456, '2001-01-02', "23, as", 2309933452, 17, "Individual"),
	(NULL, 123459023456, '2001-01-05', "23, asgdfga,a sdg", 2391793759819, 18, "Individual"),
	(NULL, 283470518301573, '2001-03-02', "22, agasga", 47519385091, 19, "Individual"),
	(NULL, 3127402384, '2004-01-02', "23, aasjif,afs ", 123701234, 20, "Organization"),
	(NULL, 9231025133215, '2011-01-02', "23, as23", 2309933452, 21, "Individual"),
	(NULL, 983215135910, '2001-04-02', "23, as", 9172305812930, 22, "Individual"),
	(NULL, 9831530195, '1999-01-02', "23, as", 21357923, 23, "Organization"),
    (NULL, 234512121231523, '2001-01-02', "23, as", 2309933452, 24, "Individual"),
	(NULL, 341312513541, '2001-01-05', "23, asgdf1ga,a sdg", 23917963759819, 25, "Individual"),
	(NULL, 28347231234120573, '2001-03-02', "22, agasga", 47519385091, 26, "Individual"),
	(NULL, 31274023123584, '2004-01-02', "23, aasjif,afs ", 123701234, 27, "Organization");
    
Insert INTO Employee (EmployeeID, BranchID, UserID, isManager) VALUES
	(NULL, 3, 6, 1),
    (NULL, 4, 7, 1),
    (NULL, 5, 8, 1),
    (NULL, 6, 9, 1),
    (NULL, 7, 10, 1),
    (NULL, 8, 6, 0),
    (NULL, 9, 7, 0),
    (NULL, 10, 8, 0),
    (NULL, 11, 9, 0),
    (NULL, 12, 10, 0),
    (NULL, 13, 11, 0),
    (NULL, 14, 12, 0),
    (NULL, 15, 12, 0),
    (NULL, 16, 11, 0);


-- Insert data into Account table
INSERT INTO Account (AccountNo, CustomerID, BranchID, Balance, SavingsPlanType, ParentID) VALUES 

('A000004', 2,  1, 1500, 'Children', 3),
('A000005', 3,  2, 2500, 'Children', 1),
('A000006', 3,  3, 2000, 'Children', 5),
('A000007', 5,  1, 1500, 'Adult', NULL),
('A000008', 5,  2, 2500, 'Adult', NULL),
('A000009', 6,  3, 2000, 'Adult', NULL),
('A000010', 7,  4, 1500, 'Adult', NULL),
('A000011', 8,  1, 2500, 'Teen', NULL),
('A000012', 9,  2, 2000, 'Teen', NULL),
('A000013', 9,  3, 1500, 'Teen', NULL),
('A000014', 11,  4, 2500, 'Teen', NULL),
('A000015', 12,  2, 2000, 'Senior', NULL),
('A000016', 10,  1, 1500, 'Senior', NULL),
('A000017', 11,  2, 2500, 'Senior', NULL),
('A000018', 12,  3, 2000, 'Senior', NULL),
('A000019', 10,  4, 1500, 'Senior', NULL),
('A000020', 4,  4, 2500, 'Children', 6);


-- Insert data into Transaction table
INSERT INTO Transaction (TransactionID, FromAccNo, ToAccNo, TrnType, Amount) VALUES 
(NULL, 'A000009', 'A000002', 'Online', 100),
(NULL, 'A000003', NULL, 'ATM', 10),
(NULL, 'A000005', 'A000002', 'Online', 200),
(NULL, 'A000011', null, 'ATM', 40),
(NULL, 'A000016', 'A000020', 'Online', 50),
(NULL, 'A000007', null, 'ATM', 30),
(NULL, 'A000006', 'A000001', 'Online', 50),
(NULL, 'A000002', NULL, 'ATM', 70),
(NULL, 'A000013', 'A000003', 'Online', 90),
(NULL, 'A000010', 'A000006', 'Online', 10);

-- Insert  extra data into FixedDeposit table

INSERT INTO FixedDeposit (FixedId, SavingsAccNo, StartingAmount, Duration, StartDate, LastDeptDate) VALUES 

('F000003', 'A000003', 1000, 6, '2023-01-01', '2023-07-01'),
('F000004', 'A000004', 2000, 12, '2023-01-02', '2024-01-05'),
('F000005', 'A000005', 1000, 6, '2023-03-01', '2023-08-01'),
('F000006', 'A000006', 2000, 12, '2023-04-01', '2024-09-01'),
('F000007', 'A000007', 1000, 6, '2023-01-01', '2023-07-11'),
('F000008', 'A000008', 2000, 12, '2022-12-12', '2024-01-01'),
('F000009', 'A000009', 1000, 6, '2023-01-01', '2023-09-22'),
('F000010', 'A000010', 2000, 12, '2023-06-01', '2024-08-01');


-- Insert  extra data into LoanApplication table
INSERT INTO LoanApplication (LoanApplicationID, IsOnline, FixedId, CustomerID, BranchID, Duration, Type, CreatedBy, Amount, Status, CheckedBy) VALUES 
(NULL, TRUE, 'F000003', 1, 2, 12, 'Business', NULL, 15000, 'Approved', NULL),
(NULL, FALSE, NULL, 2, 2, 24, 'Personal', 2, 3500, 'Approved', 1),
(NULL, FALSE, NULL, 2, 1, 36, 'Personal', 1, 6000, 'Pending', NULL),
(NULL, TRUE, 'F000004', 3, 3, 12, 'Business', NULL, 5000, 'Approved', NULL),
(NULL, FALSE, NULL, 3, 2, 24, 'Personal', 2, 4000, 'Approved', 1),
(NULL, TRUE, 'F000009', 2, 3, 36, 'Personal', 1, 9000, 'Rejected', NULL);


-- Insert  extra data into Loan table
INSERT INTO Loan (LoanID, CustomerID, LoanApplicationID, Amount, StartDate, EndDate, Installment, Balance, IsOnline, FixedId) VALUES 
(NULL, 7, 6, 5000, '2023-01-01', '2023-12-02', 500, 2000, TRUE, 'F000002'),
(NULL, 2, 5, 3000, '2023-02-01', '2025-03-01', 150, 3000, FALSE, NULL),
(NULL, 3, 4, 5000, '2023-03-01', '2023-12-05', 500, 4000, TRUE, 'F000003'),
(NULL, 4, 3, 3000, '2023-04-01', '2025-01-01', 150, 6000, FALSE, NULL),
(NULL, 5, 2, 5000, '2023-05-01', '2023-12-01', 500, 5000, TRUE, 'F000004'),
(NULL, 6, 1, 3000, '2023-06-01', '2024-01-01', 150, 3000, FALSE, NULL),
(NULL, 8, 4, 5000, '2023-06-01', '2023-07-02', 500, 2000, TRUE, 'F000005'),
(NULL, 9, 3, 3000, '2023-02-01', '2024-05-01', 150, 2000, FALSE, NULL);

-- Insert data into LoanInterestRate table
INSERT INTO LoanInterestRate (Duration, Type, InterestRate) VALUES 
(06, 'Business', 0.06),
(36, 'Business', 0.12),
(06, 'Personal', 0.11),
(24, 'Personal', 0.15);

-- Insert  extra data into LoanInstallment table
INSERT INTO LoanInstallment (LoanID, PaymentDate, DueDate, Status) VALUES 
(3, '2023-02-11', '2023-02-11', 'Paid'),
(4, '2023-03-01', '2023-03-01', 'Pending'),
(5, '2023-04-11', '2023-04-11', 'Paid'),
(6, '2023-05-01', '2023-05-01', 'Pending');




