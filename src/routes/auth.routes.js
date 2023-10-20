const express = require("express");
const { findByUsername, addUser } = require("@models/user.model");
const { comparePasswords } = require("@utils/password_helper");
const { addCustomer } = require("@models/customer.model");
const { generateHash } = require("@utils/password_helper");
const generateToken = require("../utils/tokenGenerator");
const router = express.Router();

router.post("/login", async (req, res) => {
  if (req.body.username && req.body.password) {
    try {
      const user = await findByUsername(req.body.username);
      if (
        (Array.isArray(user) && user.length) ||
        (!Array.isArray(user) && user)
      ) {
        if (comparePasswords(req.body.password, user.Password)) {
          console.log("here");
          const { Password, ...userRest } = user;
          console.log(process.env.API_SECRET);
          const token = await generateToken(userRest);
          res.status(200).send({
            message: "Login successful",
            user: userRest,
            token: token,
          });
        } else {
          res
            .status(401)
            .send({ message: "Wrong password", accessToken: null });
        }
      } else {
        res.status(404).send({ message: "User not found", accessToken: null });
      }
    } catch (err) {
      console.log(err);
      res.status(500).send({ message: err, accessToken: null });
    }
  } else {
    res.status(400).send({ message: "Username and Password are required" });
  }
});

router.post("/signup", async (req, res) => {
  if (req.body.username && req.body.password) {
    try {
      const user = await findByUsername(req.body.username);
      if (
        (Array.isArray(user) && user.length === 0) ||
        (!Array.isArray(user) && !user)
      ) {
        const result = await addCustomer(req.body);
        res
          .status(200)
          .send({ message: "Customer User created", result: result });
      } else {
        res.status(400).send({
          message:
            "There is an already active user with this username. Please enter another username or use login",
        });
      }
    } catch (err) {
      res.status(500).send({ message: err });
    }
  } else {
    res.status(400).send({ message: "Username and Password are required" });
  }
});

module.exports = router;
