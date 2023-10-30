const { query, escapedQuery } = require("@services/db.service.js");

const findOwn = async (acc) => {
  const result = await escapedQuery({
    sql: `(SELECT * from Transaction where FromAccNo=?) UNION (SELECT * FROM Transaction where ToAccNo=?)`,
    values: [acc, acc],
  });
  console.log(result);
  return result[0];
};

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * from Transaction where TransactionID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0][0];
};

const findAll = async (id) => {
  const result = await query("SELECT * from Transaction");
  console.log(result);
  return result[0];
};

const addTransaction = async (data) => {
  const result = await escapedQuery({
    sql: `
        CALL add_trn(?, ?, ?, ?, ?);
        `,
    values: [
      data.fromAccNo,
      data.toAccNo,
      data.amount,
      data.type,
      data.description,
    ],
  });
  console.log(result);
  return result[0];
};

module.exports = {
  findAll,
  findOwn,
  findOne,
  addTransaction,
};
