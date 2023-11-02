const { query, escapedQuery } = require("@services/db.service.js");

const findAll = async (branchID) => {
  if (branchID) {
    const result = await escapedQuery({
      sql: "SELECT * from LoanInstallmentView BranchID=?",
      values: [branchID],
    });
    console.log(result[0]);
    return result[0];
  }
  const result = await query("SELECT * from LoanInstallmentView");
  console.log(result[0]);
  return result[0];
};

const findPendingInstallments = async (branchID) => {
  if (branchID) {
    const result = await escapedQuery({
      sql: "SELECT * from PayableLoanInstallmentsView i BranchID=?",
      values: [branchID],
    });
    console.log(result[0]);
    return result[0];
  }
  const result = await query("SELECT * from PayableLoanInstallmentsView");
  console.log(result[0]);
  return result[0];
};

const findOwnPendingInstallments = async (userID, branchID) => {
  if (branchID) {
    const result = await escapedQuery({
      sql: "SELECT * from PayableLoanInstallmentsView WHERE BranchID=? AND UserID=?",
      values: [branchID, userID],
    });
    console.log(result[0]);
    return result[0];
  }
  const result = await query("SELECT * from PayableLoanInstallmentsView");
  console.log(result[0]);
  return result[0];
};

const findOverdueInstallments = async (branchID) => {
  if (branchID) {
    const result = await escapedQuery({
      sql: "SELECT * from LoanInstallmentView WHERE BranchID=? AND Status='Overdue'",
      values: [branchID],
    });
    console.log(result[0]);
    return result[0];
  }
  const result = await escapedQuery({
    sql: "SELECT * from LoanInstallmentView WHERE Status='Overdue'",
  });
  console.log(result[0]);
  return result[0];
};

// TODO Make this a View
const findOwnOverdueInstallments = async (userID, branchID) => {
  if (branchID) {
    const result = await escapedQuery({
      sql: "SELECT * from LoanInstallmentView WHERE BranchID=? AND Status='Overdue' AND UserID=?",
      values: [branchID, userID],
    });
    console.log(result[0]);
    return result[0];
  }
  const result = await escapedQuery({
    sql: "SELECT * from LoanInstallmentView WHERE Status='Overdue' AND UserID=?",
    values: [userID],
  });
  console.log(result[0]);
  return result[0];
};

const findOne = async (loanID, dueData) => {
  const result = await escapedQuery({
    sql: `SELECT * from LoanInstallmentView where LoanID=? and DueDate=? LIMIT 1`,
    values: [loanID, dueData],
  });
  console.log(result);
  return result[0][0];
};

const findOwn = async (userID) => {
  const result = await escapedQuery({
    sql: `SELECT * FROM LoanInstallmentView WHERE UserID=?`,
    values: [userID],
  });
  console.log(result);
  return result[0];
};

module.exports = {
  findAll,
  findOne,
  findOwn,
  findPendingInstallments,
  findOverdueInstallments,
  findOwnPendingInstallments,
  findOwnOverdueInstallments,
};
