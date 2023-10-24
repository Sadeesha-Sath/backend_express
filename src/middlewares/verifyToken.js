const jwt = require("jsonwebtoken");

const verifyToken = (req, res, next) => {
  if (
    req.headers &&
    req.headers.authorization &&
    req.headers.authorization.split(" ")[0] === "JWT"
  ) {
    console.log("At Verification");
    jwt.verify(
      req.headers.authorization.split(" ")[1],
      process.env.API_SECRET,
      function (err, decode) {
        if (err) {
          req.user = undefined;
          res.status(403).send({ message: err });
        }
        req.user = decode.user;
        console.log(req.user);
        next();
        console.log("After first next");
        return;
      }
    );
  } else {
    req.user = undefined;
    console.log("At last Verification");
    next();
  }
};

module.exports = verifyToken;
