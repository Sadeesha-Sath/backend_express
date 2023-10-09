const { query, escapedQuery } = require("../services/db.service.js");
const { generateHash } = require("../utils/password_helper.js");

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT UserID, Name, Username, Email, Role from User where UserID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    `SELECT UserID, Name, Username, Email, Role from User`
  );
  console.log(result);
  return result;
};

const findByUsername = async (username) => {
  const result = await escapedQuery({
    sql: `SELECT UserID, Name, Username, Email, Password, Role from User where Username=?`,
    values: [username],
  });
  console.log(result[0]);
  return result[0];
};

const updateOne = async (id, data) => {
  const result = await escapedQuery({
    sql: "UPDATE User set Name=?, Username=?, Email=?, where UserID=?",
    values: [data.name, data.username, data.email, data.id],
  });
  console.log(result);
  return result;
};

const changeAccess = async (id, data) => {
  const result = await escapedQuery({
    sql: "UPDATE User set Role=? where UserID=?",
    values: [data.role, data.id],
  });
  console.log(result);
  return result;
};

const getPassword = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT Password from User where UserID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

const changePassword = async (data) => {
  const hashedPass = await generateHash(data.password);
  const result = await escapedQuery({
    sql: "UPDATE User set Password=? where UserID=?",
    values: [hashedPass, data.id],
  });
  console.log(result);
  return result;
};

const addUser = async (username, password) => {
  const hashedPass = await generateHash(password);
  const result = await escapedQuery({
    sql: `INSERT INTO User (UserID, Name, Email, Username, Password) VALUES (NULL, ?, ?, ?, ?, ?);`,
    values: [data.name, data.email, data.username, hashedPass],
  });
  console.log(result);
  return result;
};

const findEmployeeIDfromUserID = async (userID) => {
  const result = await escapedQuery({
    sql: `SELECT EmployeeID from Employee where UserID=?`,
    values: [userID],
  });
  console.log(result[0]);
  return result[0];
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
  findEmployeeIDfromUserID,
};
