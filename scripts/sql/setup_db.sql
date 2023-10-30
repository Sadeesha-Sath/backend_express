DROP DATABASE IF EXISTS BANKING_SYSTEM;
CREATE DATABASE BANKING_SYSTEM;
USE BANKING_SYSTEM;


create table Branch (
    BranchID int NOT NULL auto_increment,
    BranchName varchar(100),
    Address varchar(255),
    Phone varchar(15),
    Email varchar(100),
    PRIMARY KEY (BranchID)
);

create table User (
    UserID int NOT NULL auto_increment,
    Name varchar(100),
    Role varchar(30) CHECK (Role in ('admin', 'b_manager', 'employee', 'customer')) NOT NULL,
    Username varchar(50) NOT NULL UNIQUE,
    Email varchar(100) NOT NULL UNIQUE,
    password varchar(1000) NOT NULL,
    PRIMARY KEY (UserID)
);

create table Employee (
    EmployeeID int NOT NULL auto_increment,
    BranchID int NOT NULL,
    UserID int NOT NULL,
    Position varchar(30) check (Position in ('Branch_Manager', 'Other')),
    IsManager BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (BranchID) references Branch(BranchID),
    FOREIGN KEY (UserID) references User(UserID) on delete cascade
);

create table Customer (
    CustomerID int NOT NULL auto_increment,
    NIC_BR varchar(30),
    DOB date,
    Address varchar(255),
    Phone varchar(15),
    UserID int NOT NULL,
    CustomerType varchar(30) check (CustomerType in ('Individual', 'Organization')),
    PRIMARY KEY (CustomerID),
    FOREIGN KEY (UserID) references User(UserID) on delete cascade
);

CREATE TABLE SavingsPlan (
  SavingsPlanType varchar(15) check (SavingsPlanType in ('Children', 'Teen', 'Adult', 'Senior')),
  InterestRate decimal(5, 2),
  MinimumBalance decimal(15,2),
  PRIMARY KEY (SavingsPlanType)
);

CREATE TABLE Account (
    AccountNo varchar(20) NOT NULL,
    CustomerID int NOT NULL,
    BranchID int NOT NULL,
    Balance decimal(15,2),
    SavingsPlanType varchar(20) check (SavingsPlanType in ('Children', 'Teen', 'Adult', 'Senior')),
    ParentID int ,
    MonthlyTransactionCount int default 0,
    PRIMARY KEY (AccountNo),
    FOREIGN KEY (ParentID) references Customer(CustomerID) on delete cascade,
    FOREIGN KEY (CustomerID) references Customer(CustomerID) on delete cascade,
    FOREIGN KEY (SavingsPlanType) references SavingsPlan(SavingsPlanType),
	FOREIGN KEY (BranchID) references Branch(BranchID),
	CHECK ((ParentID is not null and SavingsPlanType = 'Children') or (SavingsPlanType != 'Children' and ParentID is null)),
    CHECK ((Balance >= -100000 and SavingsPlanType is null) or (Balance >= 0 and SavingsPlanType = 'Children') 
    or (Balance >= 500 and SavingsPlanType = 'Teen') or (Balance >= 1000 and SavingsPlanType = 'Adult') 
    or (Balance >= 1000 and SavingsPlanType = 'Senior'))
);

create table Transaction (
    TransactionID int NOT NULL auto_increment,
    FromAccNo varchar(20),
    ToAccNo varchar(20),
    Description varchar(100) DEFAULT 'CEFT',
    TrnType varchar(20) check (TrnType in ('Online', 'ATM', 'Loan', 'TrnFee')),
    Amount decimal(15, 2) NOT NULL,
    TimeStamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (TransactionID),
    FOREIGN KEY (ToAccNo) references Account(AccountNo),
    FOREIGN KEY (FromAccNo) references Account(AccountNo),
    CHECK (Amount > 0),
    CHECK (FromAccNo != ToAccNo),
    CHECK (TrnType = 'ATM' and ToAccNo is null or TrnType != 'ATM' and ToAccNo is not null),
    CHECK (TrnType = 'Loan' and FromAccNo is null or TrnType != 'Loan' and FromAccNo is not null)
);


CREATE TABLE FixedDeposit (
  FixedId varchar(20) NOT NULL,
  SavingsAccNo varchar(20) NOT NULL,
  StartingAmount decimal(15,2),
  Duration decimal(2) check (Duration in (6, 12, 18)),
  StartDate date,
  LastDeptDate date,
  InterestRate decimal(5,2),
  PRIMARY KEY (FixedId),
  FOREIGN KEY (SavingsAccNo) REFERENCES Account(accountNo)
);


CREATE TABLE LoanApplication (
  LoanApplicationID int NOT NULL AUTO_INCREMENT,
  IsOnline BOOLEAN DEFAULT FALSE,
  FixedId varchar(20),
  CustomerID int NOT NULL,
  BranchID int NOT NULL,
  Duration decimal(2) check (Duration in (6, 12, 18, 24, 36, 48, 60, 72, 84, 96, 108, 120)),
  Type varchar(15) check (Type in ('Business', 'Personal')),
  CreatedTimeStamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CreatedBy int,
  CheckedDate date,
  CheckedBy int,
  Amount decimal(15,2),
  Status varchar(10) check (Status in ('Pending', 'Approved', 'Rejected')),
  PRIMARY KEY (LoanApplicationID), 
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
  FOREIGN KEY (CheckedBy) REFERENCES Employee(EmployeeID),
  FOREIGN KEY (FixedId) REFERENCES FixedDeposit(FixedId),
  FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID),
  CHECK ((ISOnline = 1 and CreatedBy is NULL and CheckedBy is NULL )OR (IsOnline = 0 and CreatedBy is not null)),
  CHECK ((Status = 'Pending' and CheckedBy is null) or Status != 'Pending' ),
  check ((IsOnline = 1 and FixedId is not null) or (IsOnline = 0 and FixedId is null)),
  CHECK ((isOnline = 1 and Status != 'Pending') or (isOnline =0))
);


CREATE TABLE Loan (
  LoanID int NOT NULL AUTO_INCREMENT,
  CustomerID int NOT NULL,
  LoanApplicationID int NOT NULL,
  Amount decimal(15,2),
  StartDate date,
  EndDate date,
  Installment decimal(15,2),
  Balance decimal(15,2),
  IsOnline BOOLEAN DEFAULT FALSE,
  FixedId varchar(20),
  PRIMARY KEY (LoanID), 
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (LoanApplicationID) REFERENCES LoanApplication(LoanApplicationID),
  FOREIGN KEY (FixedId) REFERENCES FixedDeposit(FixedId),
  check (IsOnline = 1 and FixedId is not null or IsOnline = 0 and FixedId is null)
);

CREATE TABLE LoanInterestRate (
  Duration decimal(2) check (Duration in (6, 12, 18, 24, 36, 48, 60, 72, 84, 96, 108, 120)),
  Type varchar(15) check (Type in ('Business', 'Personal')),
  InterestRate decimal(5,2),
  PRIMARY KEY (Duration, Type)
);

CREATE TABLE LoanInstallment (
  LoanID int NOT NULL,
  PaymentDate date,
  DueDate date NOT NULL,
  Status varchar(10) check (Status in ('Pending', 'Paid', 'Overdue')) DEFAULT 'Pending',
  PRIMARY KEY (LoanID, DueDate),
  FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);

CREATE TABLE FixedDepositInterestRate (
  Duration decimal(2) NOT NULL check (Duration in (6, 12, 36)),
  InterestRate decimal(5,2),
  PRIMARY KEY (Duration)
);