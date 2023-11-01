const { query, escapedQuery } = require("@services/db.service.js");


const findAll = async () => {
  const result = await query(
    "SELECT * from FixedDeposit"
  );
  console.log(result[0]);
  return result[0];
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from FixedDeposit where FixedId=?`,
    values: [id],
  });
  console.log(result);
  return result[0][0];
};

const findFromUser = async (userID) => {
  const result = await escapedQuery({
    sql: `SELECT f.* FROM FixedDeposit f LEFT JOIN Account a on f.SavingsAccNo=a.AccountNo JOIN Customer c on a.CustomerID=c.CustomerID WHERE c.UserID=?`,
    values: [userID],
  });
  console.log(result);
  return result[0];
};

module.exports = { findAll, findOne, findFromUser };