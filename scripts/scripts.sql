CREATE DATABASE BANKING;
USE BANKING;
create table User (
    userID varchar(30) NOT NULL,
    name varchar(100),
    role varchar(30) CHECK (role in ('admin', 'b_manager', 'employee', 'customer')) NOT NULL,
    username varchar(50) NOT NULL,
    email varchar(100),
    password varchar(400) NOT NULL,
    PRIMARY KEY (userID)
);


create table Branch (
    branchID varchar(30) NOT NULL,
    branchName varchar(100),
    address varchar(255),
    phone varchar(15),
    email varchar(100),
    PRIMARY KEY (branchID)

);

create table Employee (
    employeeID varchar(30) NOT NULL,
    branchID varchar(30),
    userID varchar(30),
    position varchar(30) check (position in ('Branch_Manager', 'Other')),
    isManager tinyint,
    PRIMARY KEY (employeeID),
    FOREIGN KEY (branchID) references Branch(branchID) on delete cascade,
    FOREIGN KEY (userID) references user(userID) on delete cascade
);



create table Customer (
    customerID varchar(30) NOT NULL,
    nic_br varchar(30),
    address varchar(255),
    phone varchar(15),
    userID varchar(30),
    dob date,
    customerType varchar(30) check (customerType in ('Individual', 'Organization')),
    PRIMARY KEY (customerID),
    FOREIGN KEY (userID) references User(userID) on delete cascade
);

create table Account (
    accountNo varchar(20) NOT NULL,
    customerID varchar(30),
    accType varchar(10) check (accType in ('Savings', 'Checking')),
    branchID varchar(30),
    balance decimal(15,2),
    PRIMARY KEY (accountNo),
    FOREIGN KEY (customerID) references Customer(customerID) on delete cascade,
	FOREIGN KEY (branchID) references Branch(branchID)
--  TODO Complete this after reviewing the ER diagram
);

CREATE TABLE SavingsPlan (
  SavingsTypeId varchar(10),
  PlanType varchar(15) check (PlanType in ('Children', 'Teen', 'Adult', 'Senior')),
  InterestRate decimal(5, 2),
  MinimumBalance decimal(15,2),
  PRIMARY KEY (SavingsTypeId)
);

CREATE TABLE SavingsAccount (
  AccountNO varchar(20),
  SavingsTypeId varchar(10),
  PRIMARY KEY (AccountNO),
  FOREIGN KEY (AccountNO) references ACCOUNT(AccountNo), 
  FOREIGN KEY (SavingsTypeId) references SavingsPlan(SavingsTypeId)
);

CREATE TABLE CurrentAccount (
  AccountNO varchar(20),
  Plan varchar(20),
  MinimumBalance decimal(15,2),
  FOREIGN KEY (AccountNO) references ACCOUNT(AccountNO)
);

CREATE TABLE ChildrensAccount (
  AccountNO varchar(20),
  ParentID varchar(10),
  FOREIGN KEY (AccountNO) REFERENCES ACCOUNT(AccountNo),
  FOREIGN KEY (ParentID) REFERENCES CUSTOMER(customerID)		
);


-- TODO Use Triggers to take timestamps on Transactions and other things (And maybe on integrity constraints like manager user employee etc)

create table Transaction (
    transactionID varchar(30) NOT NULL,
    fromAccNo varchar(20) NOT NULL,
    toAccNo varchar(20) NOT NULL,
    description varchar(100) DEFAULT 'CEFT',
    trnType varchar(20) check (trnType in ('Online', 'ATM')),
    amount decimal(15, 2) NOT NULL,
    timeStamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (transactionID),
    FOREIGN KEY (toAccNo) references Account(accountNo),
    FOREIGN KEY (fromAccNo) references Account(accountNo)
);

CREATE TABLE FixedDeposit (
  FixedId varchar(10),
  AccountNo varchar(10),
  Duration decimal(2) check (Duration in (6, 12, 18)),
  StartDate date,
  LastDeptDate date,
  InterestRate decimal(5,2),
  customerID varchar(30),
  PRIMARY KEY (FixedId),
  FOREIGN KEY (AccountNo) REFERENCES Account(AccountNO), 
  FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE LoanApplication (
  LoanApplicationID varchar(10),
  CustomerID varchar(10),
  BranchID varchar(10),
  Type varchar(15) check (Type in ('Business', 'Personal')),
  ApplicationDate date,
  Status varchar(10),
  PRIMARY KEY (LoanApplicationID), 
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)

);


CREATE TABLE Loan (
  LoanID varchar(10) NOT NULL,
  customerID varchar(30),
  LoanApplicationID varchar(10),
  Amount decimal(15,2),
  StartDate date,
  EndDate date,
  Installment decimal(15,2),
  PRIMARY KEY (LoanID), 
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (LoanApplicationID) REFERENCES LoanApplication(LoanApplicationID)
);

CREATE TABLE OnlineLoan (
  OnlineLoanID varchar(15) NOT NULL,
  LoanID varchar(10),
  FixedId varchar(10),
  PRIMARY KEY (OnlineLoanID),
  FOREIGN KEY (LoanID) REFERENCES Loan(LoanID), 
  FOREIGN KEY (FixedId) REFERENCES FixedDeposit(FixedId)
);




