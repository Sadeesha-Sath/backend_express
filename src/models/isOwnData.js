const { findUserIDfromCustomerID } = require("@models/customer.model.js");
const {
  findUserIDfromEmployeeID,
  findBranchIDfromEmployeeID,
} = require("./employee.model.js");
const { findUserIDfromTransactionID } = require("./transaction.model.js");

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

const isOwnAccount = async (accID, userID) => {
  const userIDfromTrnID = await findUserIDfromTransactionID(accID);
  return userIDfromTrnID.userID === userID;
};

const getBranchfromEmployeeID = async (employeeID) => {
  return await findBranchIDfromEmployeeID(employeeID);
};

const getBranchfromUserID = async (userID) => {
  const employeeID = await findEmployeeIDfromUserID(userID);
  if (!employeeID) {
    return null;
  }
  return await getBranchfromEmployeeID(employeeID);
};

module.exports = { isOwnCustomer, isOwnAccount, isOwnEmployee, isOwnUser };
