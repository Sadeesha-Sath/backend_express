const jwt = require("jsonwebtoken");

const tokenVerification = (token) => {
  return jwt.verify(token, process.env.API_SECRET, function (err, decode) {
    if (err) {
      console.log(err);
      console.log("Token verification failed");
      return false;
    }
    return decode.user;
  });
};

module.exports = tokenVerification;
