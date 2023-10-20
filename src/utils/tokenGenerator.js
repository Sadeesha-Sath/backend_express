const jwt = require("jsonwebtoken");

const generateToken = async (user) =>
  await jwt.sign({ user: user }, process.env.API_SECRET, {
    expiresIn: 3600, // 1 hour
  });

module.exports = generateToken;
