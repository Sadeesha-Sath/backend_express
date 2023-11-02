const { query, escapedQuery } = require("../services/db.service.js"); //need to fix the path

const getView = async (branchId, reportType) => {
  let response;
  if (reportType == "transaction") {
    console.log("transaction");
    response = await escapedQuery({
      sql: "SELECT * FROM TransactionView WHERE CreditedBranchID=? OR DebitedBranchID=?",
      values: [branchId, branchId],
    });
  } else if (reportType == "loan") {
    response = await escapedQuery({
      sql: `SELECT * From LoanInstallmentView WHERE BranchID=? AND Status='Overdue'`,
      values: [branchId],
    });
  } else {
    console.log("Error");
  }
  console.log(response);
  return response[0];
};

module.exports = { getView };
