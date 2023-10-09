const { query, escapedQuery } = require("../services/db.service.js");

const findOne = async (id) => {
  const result = await query(
    `SELECT e.employeeID, u.name, e.branchID, e.position, u.email, u.userID, u.username from Employee e left join User u on e.userID=u.userID where e.employeeID=${id}`
  );
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    "SELECT e.employeeID, u.name, e.branchID, e.position, u.email, u.userID, u.username from Employee e left join User u on e.userID=u.userID order by e.employeeID"
  );
  console.log(result);
  return result;
};

const findUserIDfromEmployeeID = async (employeeID) => {
  const result = await query(
    `SELECT userID from Employee where employeeID=${employeeID}`
  );
  console.log(result[0]);
  return result[0];
};

module.exports = { findOne, findAll, findUserIDfromEmployeeID };
