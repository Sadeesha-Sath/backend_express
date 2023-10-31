const { query, escapedQuery } = require("@services/db.service.js");
const { generateHash } = require("@utils/password_helper.js");

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT UserID, Name, Username, Email, Role from User where UserID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0][0];
};

const findAll = async () => {
  const result = await query(
    `SELECT UserID, Name, Username, Email, Role from User`
  );
  console.log(result[0]);
  return result[0];
};

const findByUsername = async (username) => {
  const result = await escapedQuery({
    sql: `SELECT UserID, Name, Username, Email, Password, Role from User where Username=? LIMIT 1`,
    values: [username],
  });
  console.log(result);
  return result[0][0];
};

const updateOne = async (id, data) => {
  const result = await escapedQuery({
    sql: "UPDATE User set Name=?, Username=?, Email=?, where UserID=?",
    values: [data.name, data.username, data.email, data.id],
  });
  console.log(result);
  return result[0];
};

const changeAccess = async (id, data) => {
  const result = await escapedQuery({
    sql: "UPDATE User set Role=? where UserID=?",
    values: [data.role, data.id],
  });
  console.log(result);
  return result[0];
};

const getPassword = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT Password from User where UserID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0][0];
};

const changePassword = async (data) => {
  const hashedPass = await generateHash(data.password);
  const result = await escapedQuery({
    sql: "UPDATE User set Password=? where UserID=?",
    values: [hashedPass, data.id],
  });
  console.log(result);
  return result[0];
};

const addUser = async (data) => {
  const hashedPass = await generateHash(data.password);
  const result = await escapedQuery({
    sql: `INSERT INTO User (UserID, Name, Email, Username, Role, Password) VALUES (NULL, ?, ?, ?, ?, ?, ?);`,
    values: [data.name, data.email, data.username, data.role, hashedPass],
  });
  console.log(result);
  return result[0];
};

const findUserIDfromAccount = async (accID) => {
  const result = await escapedQuery({
    sql: `SELECT * FROM AccountView WHERE AccountID=? LIMIT 1`,
    values: [accID],
  });
  console.log(result[0]);
  return result[0][0];
};

const findUserIDfromEmployeeID = async (employeeID) => {
  const result = await escapedQuery({
    sql: `SELECT UserID from Employee where EmployeeID=?`,
    values: [employeeID],
  });
  console.log(result[0]);
  return result[0][0];
};

const findUserIDfromCustomerID = async (customerID) => {
  const result = await escapedQuery({
    sql: `SELECT UserID from CustomerView where CustomerID=?`,
    values: [customerID],
  });
  console.log(result[0]);
  return result[0];
};

const findUserIDfromTransactionID = async (transactionID) => {
  const result = await escapedQuery({
    sql: `SELECT c.UserID from Transaction t inner join Customer c where t.TransactionID=?`,
    values: [transactionID],
  });
  console.log(result[0]);
  return result[0][0];
};

const findUserIDfromAccountID = async (accountID) => {
  const result = await escapedQuery({
    sql: "SELECT UserID from AccountView WHERE AccountID=?",
    values: [accountID],
  });
  console.log(result[0][0]);
  return result[0][0];
};

const findUserIDfromFD = async (FixedID) => {
  const result = await escapedQuery({
    sql: "SELECT a.UserID from AccountView a JOIN FixedDeposit f ON f.SavingsAccNo=a.AccountNo WHERE f.FixedId=?",
    values: [FixedID],
  });
  console.log(result[0][0]);
  return result[0][0];
};

module.exports = {
  findAll,
  findOne,
  updateOne,
  changeAccess,
  getPassword,
  changePassword,
  findByUsername,
  addUser,
  findUserIDfromAccount,
  findUserIDfromEmployeeID,
  findUserIDfromCustomerID,
  findUserIDfromTransactionID,
  findUserIDfromAccountID,
  findUserIDfromFD,
};
