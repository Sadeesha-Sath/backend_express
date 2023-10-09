const mysql = require("mysql");
const dbConfig = require("../configs/db.config");

const pool = mysql.createPool(dbConfig);

const connect = (callback) => {
  return new Promise((resolve, reject) => {
    pool.on("connection", function (connection) {
      connection.on("error", function (err) {
        console.error("MySQL error event", err);
      });
      connection.on("close", function (err) {
        console.warn("MySQL close event", err);
      });
    });
    resolve();
  });
};

const query = async (sql) => {
  pool.query(sql, (error, results, fields) => {
    if (error) {
      throw error;
    }
    return results;
  });
  // pool.getConnection((err, connection) => {
  //   if (err) throw err; // not connected!

  //   // Use the connection
  //   connection.query(sql, (error, results, fields) => {
  //     // When done with the connection, release it.
  //     connection.release();

  //     // Handle error after the release.
  //     if (error) throw error;

  //     return results;

  //     // Don't use the connection here, it has been returned to the pool.
  //   });
  // });
};

const escapedQuery = async ({ sql, values }, timeout = 40000) => {
  pool.query(
    {
      sql: sql,
      timeout: timeout,
      values: values,
    },
    (error, results, fields) => {
      if (error) {
        throw error;
      }
      return results;
    }
  );
  // pool.getConnection((err, connection) => {
  //   if (err) throw err; // not connected!

  //   // Use the connection
  //   connection.query(
  //     {
  //       sql: sql,
  //       timeout: timeout,
  //       values: values,
  //     },
  //     (error, results, fields) => {
  //       // When done with the connection, release it.
  //       connection.release();

  //       // Handle error after the release.
  //       if (error) throw error;

  //       return results;

  //       // Don't use the connection here, it has been returned to the pool.
  //     }
  //   );
  // });
};

module.exports = { query, escapedQuery, connect };
