const { query, escapedQuery } = require("../services/db.service.js");

const findOne = async (id) => {
  const result = await query(
    `SELECT e.EmployeeID, u.Name, e.BranchID, e.Position, u.Email, u.UserID, u.Username from Employee e left join User u on e.UserID=u.UserID where e.EmployeeID=${id}`
  );
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    "SELECT e.EmployeeID, u.Name, e.BranchID, e.Position, u.Email, u.UserID, u.Username from Employee e left join User u on e.UserID=u.UserID ORDER BY e.EmployeeID"
  );
  console.log(result);
  return result;
};

const findUserIDfromEmployeeID = async (employeeID) => {
  const result = await query(
    `SELECT UserID from Employee where EmployeeID=${employeeID}`
  );
  console.log(result[0]);
  return result[0];
};

const findBranchIDfromEmployeeID = async (employeeID) => {
  const result = await query(
    `SELECT BranchID from Employee where EmployeeID=${employeeID}`
  );
  console.log(result[0]);
  return result[0];
};


module.exports = {
  findOne,
  findAll,
  findUserIDfromEmployeeID,
  findBranchIDfromEmployeeID,
};
