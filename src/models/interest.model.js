const { escapedQuery } = require("../services/db.service");

const findAllSavingInterestRates = async () => {
  const result = await escapedQuery({
    sql: "SELECT SavingsPlanType, InterestRate from SavingsPlan",
  });
  console.log(result);
  return result[0];
};

const findAllLoanInterestRates = async () => {
  const result = {};
  const business = await query(
    'SELECT * from loaninterestrate where Type="Business"'
  );
  const personal = await query(
    'SELECT * from loaninterestrate where Type="Personal"'
  );
  result["business"] = business[0];
  result["personal"] = personal[0];
  return result;
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
