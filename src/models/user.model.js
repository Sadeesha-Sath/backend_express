const { query, escapedQuery } = require("../services/db.service.js");
const { generateHash } = require("../utils/password_helper.js");

const findOne = async (id) => {
  const result = await query(
    `SELECT userID, name, username, email, role from User where userID=${id}`
  );
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    `SELECT userID, name, username, email, role from User`
  );
  console.log(result);
  return result;
};

const findByUsername = async () => {
  const result = await query(
    `SELECT userID, name, username, email, password, role from User where username=${username}`
  );
  console.log(result[0]);
  return result[0];
};

const updateOne = async (id, data) => {
  const result = await escapedQuery({
    sql: "UPDATE User set name=?, username=?, email=?, where userID=?",
    values: [data.name, data.username, data.email, data.id],
  });
  console.log(result);
  return result;
};

const changeAccess = async (id, data) => {
  const result = await escapedQuery({
    sql: "UPDATE User set role=? where userID=?",
    values: [data.role, data.id],
  });
  console.log(result);
  return result;
};

const getPassword = async (id) => {
  const result = await query(`SELECT password from User where userID=${id}`);
  console.log(result[0]);
  return result[0];
};

const changePassword = async (data) => {
  const hashedPass = await generateHash(data.password);
  const result = await escapedQuery({
    sql: "UPDATE User set password=? where userID=?",
    values: [hashedPass, data.id],
  });
  console.log(result);
  return result;
};

const addUser = async (username, password) => {
  const hashedPass = await generateHash(password);
  const result = await escapedQuery({
    sql: `INSERT INTO User (userID, name, email, username, password) VALUES (NULL, ?, ?, ?, ?, ?);`,
    values: [data.name, data.email, data.username, hashedPass],
  });
  console.log(result);
  return result;
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
};
