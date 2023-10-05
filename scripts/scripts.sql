DROP DATABASE IF EXISTS BANKING_SYSTEM;
CREATE DATABASE BANKING_SYSTEM;
USE BANKING_SYSTEM;
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



