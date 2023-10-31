const { query, escapedQuery } = require("@services/db.service.js");

const findAll = async () => {
  const result = await query("SELECT * from BranchView");
  console.log(result);
  return result[0];
};

const findAllMinimal = async () => {
  const result = await query("SELECT BranchID, BranchName from Branch");
  console.log(result);
  return result[0];
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from BranchView where BranchID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0][0];
};

const findManager = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from Employee where e.BranchID=? and e.IsManager=1`,
    values: [id],
  });
  console.log(result[0]);
  return result[0][0];
};

// const addBranch = async (data) => {
//   const result = await escapedQuery({
//     sql: "INSERT INTO Branch (branchID, name, address, phone) VALUES (NULL, ?, ?, ?);",
//     values: [data.name, data.address, data.phone],
//   });
//   console.log(result);
//   return result;
// };

module.exports = { findAll, findOne, findManager, findAllMinimal };
