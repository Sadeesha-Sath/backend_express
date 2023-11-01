const { findBranchIDfromEmployeeID } = require("@models/employee.model.js");
const {
  findUserIDfromEmployeeID,
  findUserIDfromCustomerID,
  findUserIDfromTransactionID,
  findUserIDfromAccountID,
  findUserIDfromFD,
  findUserIDfromLoan,
} = require("@models/user.model.js");

const isOwnUser = async (id, userID) => {
  return id === userID;
};

const isOwnCustomer = async (customerID, userID) => {
  const userIDfromCustomerID = await findUserIDfromCustomerID(customerID);
  return userIDfromCustomerID.userID === userID;
};

const isOwnEmployee = async (employeeID, userID) => {
  const userIDfromEmployeeID = await findUserIDfromEmployeeID(employeeID);
  return userIDfromEmployeeID.userID === userID;
};

const isOwnTransaction = async (tranID, userID) => {
  const userIDfromTrnID = await findUserIDfromTransactionID(tranID);
  return userIDfromTrnID.userID === userID;
};

const isOwnAccount = async (accID, userID) => {
  const userIDfromAccID = await findUserIDfromAccountID(accID);
  return userIDfromAccID.userID === userID;
};

const getBranchfromEmployeeID = async (employeeID) => {
  return await findBranchIDfromEmployeeID(employeeID);
};

const isOwnFD = async (fixedID, userID) => {
  const userIDfromFD = await findUserIDfromFD(fixedID);
  return userIDfromFD === userID;
};

const isOwnLoan = async (loanID, userID) => {
  const userIDfromLoan = await findUserIDfromLoanID(loanID);
  return userIDfromLoan === userID;
};

module.exports = {
  isOwnCustomer,
  isOwnTransaction,
  isOwnEmployee,
  isOwnUser,
  isOwnAccount,
  getBranchfromEmployeeID,
  isOwnFD,
};
