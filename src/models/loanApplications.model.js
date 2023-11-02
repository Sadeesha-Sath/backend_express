const { query, escapedQuery } = require("@services/db.service.js");

const findAll = async (BranchID) => {
  if (BranchID) {
    const result = await escapedQuery({
      sql: `SELECT * from LoanApplication where BranchID=?`,
      values: [BranchID],
    });
    console.log(result);
    return result[0];
  } else {
    result = await query("SELECT * from LoanApplication");
    console.log(result);
    return result[0];
  }
};

const findAllPending = async (branchID) => {
  if (branchID) {
    const result = await escapedQuery({
      sql: "SELECT * FROM pendingloanapplicationsview where BranchID=?",
      values: [branchID],
    });
    console.log(result);
    return result[0];
  } else {
    result = await query("SELECT * from pendingloanapplicationsview");
    console.log(result);
    return result[0];
  }
};

const findOne = async (id) => {
  const result = await query({
    sql: `SELECT * from LoanApplication where LoanApplicationID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0][0];
};

const approveLoanApplication = async (id, userID) => {
  const result = await escapedQuery({
    sql: "SELECT * from approve_loan(?, ?)",
    values: [id, userID],
  });
  console.log(result);
  return result[0];
};

const rejectLoanApplication = async (id, userID) => {
  const result = await escapedQuery({
    sql: "SELECT * from reject_loan(?, ?)",
    values: [id, userID],
  });
  console.log(result);
  return result[0];
};

const getBranchIDfromLoanApplication = async (loanApplicationID) => {
  const result = await escapedQuery({
    sql: `SELECT BranchID from LoanApplication where LoanApplicationID=?`,
    values: [loanApplicationID],
  });
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
  return result[0];
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
  return result[0];
};

module.exports = {
  findAll,
  findOne,
  getBranchIDfromLoanApplication,
  approveLoanApplication,
  rejectLoanApplication,
  addOnlineLoanApplication,
  addOfflineLoanApplication,
  findAllPending,
};
