const jwt = require("jsonwebtoken");

const generateToken = (user) => {
  const curr_env = process.env.NODE_ENV;
  console.log(curr_env);
  return jwt.sign({ user: user }, process.env.API_SECRET, {
    expiresIn: "10d",
  });
};

module.exports = generateToken;
