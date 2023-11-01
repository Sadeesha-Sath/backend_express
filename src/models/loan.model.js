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

const findOwnActiveLoans = async (userID) => {
  const result = await escapedQuery({
    sql: "SELECT l.* from ActiveLoans l LEFT JOIN Customer c on l.CustomerID=c.CustomerID WHERE c.UserID=?",
    values: [userID],
  });
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

const findOwn = async (userID) => {
  const result = await escapedQuery({
    sql: `SELECT l.* FROM Loan l LEFT JOIN Customer c on l.CustomerID=c.CustomerID WHERE c.UserID=?`,
    values: [userID],
  });
  console.log(result);
  return result[0];
};

const findInterests = async() =>{
  const result = {}
  const business = await query('SELECT * from loaninterestrate where Type = "Business"');
  const personal = await query('SELECT * from loaninterestrate where Type = "Personal"');
  result['business'] = business[0];
  result['personal'] = personal[0];
  return result;
}

module.exports = {
  findAll,
  findOne,
  findOwn,
  findActiveLoans,
  findOwnActiveLoans,
  findInterests
};
