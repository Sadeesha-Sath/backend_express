const { escapedQuery, query } = require("../services/db.service");

const findAllSavingInterestRates = async () => {
  const result = await escapedQuery({
    sql: "SELECT SavingsPlanType, InterestRate from SavingsPlan",
  });
  console.log(result);
  return result[0];
};

const findAllLoanInterestRates = async () => {
  const result = await query("SELECT * from loaninterestrate");
  return result[0];
  //   const result = await escapedQuery({
  //     sql: "SELECT * FROM LoanInterestRate",
  //   });
  //   console.log(result);
  //   return result[0];
};

const findAllFDInterestRates = async () => {
  const result = await escapedQuery({
    sql: "SELECT * FROM FixedDepositInterestRate",
  });
  console.log(result);
  return result[0];
};

module.exports = {
  findAllSavingInterestRates,
  findAllLoanInterestRates,
  findAllFDInterestRates,
};
