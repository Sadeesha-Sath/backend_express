const { query, escapedQuery } = require("../services/db.service.js");

const findAll = async () => {
  const result = await query("SELECT * from Branch");
  console.log(result);
  return result;
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from Branch where BranchID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

const findManager = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from Employee where e.BranchID=${id} and e.IsManager=1`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

// const addBranch = async (data) => {
//   const result = await escapedQuery({
//     sql: "INSERT INTO Branch (branchID, name, address, phone) VALUES (NULL, ?, ?, ?);",
//     values: [data.name, data.address, data.phone],
//   });
//   console.log(result);
//   return result;
// };

module.exports = { findAll, findOne, findManager };
