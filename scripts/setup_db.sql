-- DROP DATABASE IF EXISTS BANKING_SYSTEM;
-- CREATE DATABASE BANKING_SYSTEM;
-- USE BANKING_SYSTEM;


create table Branch (
    branchID int NOT NULL AUTO_INCREMENT ,
    branchName varchar(100),
    address varchar(255),
    phone varchar(15),
    email varchar(100),
    CHECK (phone isNumeric())
    PRIMARY KEY (branchID),
);

create table Employee (
    employeeID int NOT NULL AUTO_INCREMENT,
    branchID int NOT NULL,
    userID int NOT NULL,
    position varchar(30) check (position in ('Branch_Manager', 'Other')),
    isManager BOOLEAN DEFAULT FALSE,
    CHECK (phone isNumeric())
    PRIMARY KEY (employeeID),
    FOREIGN KEY (branchID) references Branch(branchID) on delete cascade,
    FOREIGN KEY (userID) references User(userID) on delete cascade
);

create table User (
    userID int NOT NULL AUTO_INCREMENT,
    name varchar(100),
    role varchar(30) CHECK (role in ('admin', 'b_manager', 'employee', 'customer')) NOT NULL,
    username varchar(50) NOT NULL,
    email varchar(100),
    password varchar(400) NOT NULL,
    PRIMARY KEY (userID),
);

create table Customer (
    customerID int NOT NULL AUTO_INCREMENT,
    nic_br varchar(30),
    dob date,
    address varchar(255),
    phone varchar(15),
    userID varchar(30),
    customerType varchr(30) check (customerType in ('Individual', 'Organization')),
    CHECK (phone isNumeric()),
    PRIMARY KEY (customerID),
    FOREIGN KEY (userID) references User(userID) on delete cascade
);

create table Account (
    accountNo int NOT NULL,
    customerID int NOT NULL,
    accType varchar(10) check (accType in ('Savings', 'Checking')),
    branchID int NOT NULL,
    balance decimal(15,2),
    PRIMARY KEY (accountNo),
    FOREIGN KEY (customerID) references Customer(customerID) on delete cascade
    FOREIGN KEY (branchID) references Branch(branchID) on delete cascade
);

create table Transaction (
    transactionID int NOT NULL AUTO_INCREMENT,
    fromAccNo int,
    toAccNo int,
    description varchar(100) DEFAULT 'CEFT',
    trnType varchar(20) check (trnType in ('Online', 'ATM', 'Loan', 'TrnFee')),
    amount decimal(15, 2) NOT NULL,
    timeStamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transactionID),
    FOREIGN KEY (toAccNo) references Account(accountNo),
    FOREIGN KEY (fromAccNo) references Account(accountNo),
    CHECK (amount > 0),
    CHECK (fromAccNo != toAccNo),
    CHECK (trnType = 'ATM' and toAccNo is null or trnType != 'ATM' and toAccNo is not null),
    CHECK (trnType = 'Loan' and fromAccNo is null or trnType != 'Loan' and fromAccNo is not null)
)


CREATE TABLE FixedDeposit (
  FixedId int,
  SavingsAccNo int NOT NULL,
  StartingAmount decimal(15,2),
  Duration decimal(2) check (Duration in (6, 12, 18)),
  StartDate date,
  LastDeptDate date,
  InterestRate decimal(5,2),
  PRIMARY KEY (FixedId),
  FOREIGN KEY (SavingsAccNo) REFERENCES Account(AccountNO), 
);


CREATE TABLE LoanApplication (
  LoanApplicationID int NOT NULL AUTO_INCREMENT,
  isOnline BOOLEAN DEFAULT FALSE,
  FixedId int,
  CustomerID int NOT NULL,
  BranchID int NOT NULL,
  Duration decimal(2) check (Duration in (6, 12, 18, 24, 36, 48, 60, 72, 84, 96, 108, 120)),
  Type varchar(15) check (Type in ('Business', 'Personal')),
  ApplicationDate date,
  ApprovedDate date,
  Amount decimal(15,2),
  Status varchar(10) check (Status in ('Pending', 'Approved', 'Rejected')),
  PRIMARY KEY (LoanApplicationID), 
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
  check (isOnline = 1 and FixedId is not null or isOnline = 0 and FixedId is null)
);


CREATE TABLE Loan (
  LoanID int NOT NULL AUTO_INCREMENT,
  customerID int NOT NULL,
  LoanApplicationID int NOT NULL,
  Amount decimal(15,2),
  StartDate date,
  EndDate date,
  Installment decimal(15,2),
  Balance decimal(15,2),
  isOnline BOOLEAN DEFAULT FALSE,
  FixedId int,
  PRIMARY KEY (LoanID), 
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (LoanApplicationID) REFERENCES LoanApplication(LoanApplicationID),
  FOREIGN KEY (FixedId) REFERENCES FixedDeposit(FixedId)
  check (isOnline = 1 and FixedId is not null or isOnline = 0 and FixedId is null)
);

CREATE TABLE LoanInterestRate (
  Duration decimal(2) check (Duration in (6, 12, 18, 24, 36, 48, 60, 72, 84, 96, 108, 120)),
  Type varchar(15) check (Type in ('Business', 'Personal')),
  InterestRate decimal(5,2),
  PRIMARY KEY (Duration, Type)
)

CREATE TABLE LoanInstallment (
  LoanID int NOT NULL,
  PaymentDate date,
  DueDate date NOT NULL,
  Status varchar(10) check (Status in ('Pending', 'Paid', 'Overdue')),
  PRIMARY KEY (LoanID, DueDate),
  FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
)

CREATE TABLE FixedDepositInterestRate (
  Duration decimal(2) NOT NULL check (Duration in (6, 12, 36)),
  InterestRate decimal(5,2),
  PRIMARY KEY (Duration)
)