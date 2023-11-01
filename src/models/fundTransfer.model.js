const { query, escapedQuery } = require("@services/db.service.js");  //need to fix the path

const getAllAccounts = async () => {
    const accounts = await query('SELECT AccountNo from account');
    return accounts[0];
  };


module.exports = { getAllAccounts};