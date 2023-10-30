const { query, escapedQuery } = require("@services/db.service.js");
const { modifySQL } = require("@utils/helper.js");

const findAll = async (queryParams) => {
  console.log(queryParams);
  const baseQuery = "SELECT * from AccountView";
  const finalQuery = modifySQL(baseQuery, queryParams);
  console.log("Final Query: " + finalQuery);
  try {
    const result = await query(finalQuery);
    console.log(result);
    return result[0];
  } catch (err) {
    console.error(err);
    return null;
  }
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from AccountView where AccountID=?`,
    values: [id],
  });
  console.log(result);
  return result[0][0];
};

const findfromUser = async (userID, queryParams) => {
  console.log(queryParams);
  const result = await escapedQuery({
    sql: `SELECT * FROM AccountView a INNER JOIN Customer c ON c.CustomerID = a.CustomerID WHERE c.UserID=?`,
    values: [userID],
  });
  console.log(result);
  return result[0];
};

module.exports = { findAll, findOne, findfromUser };
