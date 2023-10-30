const { query, escapedQuery } = require("@services/db.service.js");

const findAll = async () => {
  const result = await query("SELECT * from Loan");
  console.log(result[0]);
  return result[0];
};

const findActiveLoans = async () => {
  const result = await query("SELECT * from ActiveLoans");
  console.log(result[0]);
  return result[0];
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from Loan where LoanID=?`,
    values: [id],
  });
  console.log(result);
  return result[0][0];
};

const findFromUser = async (userID) => {
  const result = await escapedQuery({
    sql: `SELECT l.* FROM Loan l LEFT JOIN Customer c on l.CustomerID=c.CustomerID WHERE c.UserID=?`,
    values: [userID],
  });
  console.log(result);
  return result[0];
};

module.exports = { findAll, findOne, findFromUser, findActiveLoans };
