const dbConfig = {
  host: "localhost",
  user: "dbms_user",
  database: "BANKING_SYSTEM",
  flags: "MULTI_STATEMENTS",
  password: "1234",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
};
module.exports = { dbConfig };
