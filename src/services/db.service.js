const mysql = require("mysql2/promise");
const { dbConfig } = require("@configs/db.config");

let pool = mysql.createPool(dbConfig);

const query = async (sql) => {
  try {
    const result = await pool.query(sql);
    return result;
  } catch (err) {
    console.error(err.message);
    throw err;
  }
};

const escapedQuery = async ({ sql, values }, timeout = 40000) => {
  try {
    const result = await pool.query({
      sql: sql,
      timeout: timeout,
      values: values,
    });
    return result;
  } catch (err) {
    console.error(err.message);
    throw err;
  }
};

module.exports = { query, escapedQuery };
