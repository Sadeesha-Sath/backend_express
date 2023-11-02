const jwt = require("jsonwebtoken");

const generateToken = (user) => {
  const curr_env = process.env.NODE_ENV;
  console.log(curr_env);
  return jwt.sign({ user: user }, process.env.API_SECRET, {
    expiresIn: "10d",
    // curr_env === undefined ? 3600:
    // curr_env === "PROD"
    //   ? process.env.PROD_TOKEN_EXPIRY // 1 hour
    //   : curr_env === "DEV"
    //   ? process.env.DEV_TOKEN_EXPIRY // 10 days
    //   : process.env.DEFAULT_TOKEN_EXPIRY, // 1 day
  });
};

module.exports = generateToken;
