const jwt = require("jsonwebtoken");

const generateToken = (user) => {
  console.log(process.env.NODE_ENV);

  return jwt.sign({ user: user }, process.env.API_SECRET, {
    expiresIn:
      process.env.NODE_ENV == "PROD"
        ? process.env.PROD_TOKEN_EXPIRY
        : process.env.NODE_ENV == "DEV"
        ? process.env.DEV_TOKEN_EXPIRY
        : process.env.DEFULT_TOKEN_EXPIRY, // 1 hour
  });
};

module.exports = generateToken;
