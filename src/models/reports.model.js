const { query, escapedQuery } = require("../services/db.service.js"); //need to fix the path

const getView = async (branchId, reportType) => {
  let response;
  if (reportType === "transaction") {
    response = await escapedQuery({
      sql: "CALL GetTransactionData(?)",
      values: [branchId],
    });
  } else if (reportType === "loan") {
    response = await escapedQuery({
      sql: "CALL GetLoanInstallmentData(?)",
      values: [branchId],
    });
  } else {
    console.log("Error");
  }

  return response[0];
};

module.exports = { getView };
