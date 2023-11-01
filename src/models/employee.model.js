const { query, escapedQuery } = require("@services/db.service.js");

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * FROM EmployeeView WHERE EmployeeID=?`,
    values: [id],
  });
  console.log(result[0][0]);
  return result[0][0];
};

const findAll = async () => {
  const result = await query("SELECT * FROM EmployeeView ORDER BY EmployeeID");
  console.log(result);
  return result[0];
};

const findBranchIDfromEmployeeID = async (employeeID) => {
  const result = await escapedQuery({
    sql: `SELECT BranchID from Employee where EmployeeID=?`,
    values: [employeeID],
  });
  console.log(result[0]);
  return result[0][0];
};

const findEmployeeIDfromUserID = async (userID) => {
  const result = await escapedQuery({
    sql: `SELECT EmployeeID from Employee where UserID=?`,
    values: [userID],
  });
  console.log(result[0][0]);
  return result[0][0];
};

module.exports = {
  findOne,
  findAll,
  findBranchIDfromEmployeeID,
  findEmployeeIDfromUserID,
};
