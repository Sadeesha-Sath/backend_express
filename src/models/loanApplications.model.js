const { query, escapedQuery } = require("../services/db.service.js");

const findAll = async (BranchID) => {
  let result;
  if (BranchID) {
    result = await escapedQuery({
      sql: `SELECT * from LoanApplication where BranchID=?`,
      values: [BranchID],
    });
  }
  result = await query("SELECT * from LoanApplication");
  console.log(result);
  return result;
};

const findOne = async (id) => {
  const result = await query(
    `SELECT * from LoanApplication where LoanApplicationID=${id}`
  );
  console.log(result[0]);
  return result[0];
};

const approveLoanApplication = async (id, userID) => {
  const result = await escapedQuery({
    sql: "SELECT * from approve_loan(?, ?)",
    values: [id, userID],
  });
  console.log(result);
  return result;
};

const rejectLoanApplication = async (id, userID) => {
  const result = await escapedQuery({
    sql: "SELECT * from reject_loan(?, ?)",
    values: [id, userID],
  });
  console.log(result);
  return result;
};

const getBranchIDfromLoanApplication = async (loanApplicationID) => {
  const result = await query(
    `SELECT BranchID from LoanApplication where LoanApplicationID=${loanApplicationID}`
  );
  console.log(result[0]);
  return result[0];
};

const addOnlineLoanApplication = async (data, userID) => {
  const result = await escapedQuery({
    sql: "SELECT * from submit_online_loan(?, ?, ?, ?, ?, ?)",
    values: [
      data.fixedId,
      data.branchID,
      data.duration,
      data.type,
      data.amount,
      userID,
    ],
  });
  console.log(result);
  return result;
};

const addOfflineLoanApplication = async (data, userID) => {
  const result = await escapedQuery({
    sql: "SELECT * from submit_offline_loan(?, ?, ?, ?, ?, ?)",
    values: [
      data.customerID,
      data.branchID,
      data.duration,
      data.type,
      data.amount,
      userID,
    ],
  });
  console.log(result);
  return result;
};

module.exports = {
  findAll,
  findOne,
  getBranchIDfromLoanApplication,
  approveLoanApplication,
  rejectLoanApplication,
  addOnlineLoanApplication,
  addOfflineLoanApplication,
};
