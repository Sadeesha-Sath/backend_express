const dbConfig = {
  host: "localhost",
  user: "root",
  database: "BANKING_SYSTEM",
  flags: "MULTI_STATEMENTS",
  password: "root123",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
};

module.exports = { dbConfig };
