const { query, escapedQuery } = require("../services/db.service.js");

const findAll = async (BranchID) => {
  let result;
  if (BranchID) {
    result = await escapedQuery({
      sql: `SELECT * from Account where BranchID=?`,
      values: [BranchID],
    });
  }
  result = await query("SELECT * from Account");
  console.log(result);
  return result;
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from Account where AccountID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

const findOwn = async (userID) => {
  const result = await query({
      sql: `SELECT * FROM get_own_account(?)`,
      values: [userID],
  });
  console.log(result[0]);
  return result[0];
};


