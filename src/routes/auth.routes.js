const express = require("express");
const { findByUsername, addUser } = require("@models/user.model");
const { comparePasswords } = require("@utils/password_helper");
const { addCustomer } = require("@models/customer.model");
const { findAll } = require("../models/user.model");
const router = express.Router();

router.post("/login", async (req, res) => {
  if (req.body.username && req.body.password) {
    const username = req.body.username;
    const password = req.body.password;
    try {
      const user = await findByUsername(username);
      console.log("USER IS" + user + " end");
      if (
        (Array.isArray(user) && user.length) ||
        (!Array.isArray(user) && user)
      ) {
        console.log("Error Goes Here");
        if (comparePasswords(password, user.password)) {
          const { password, ...userToken } = user;
          const token = jwt.sign({ user: userToken }, process.env.API_SECRET, {
            expiresIn: 86400, // 1 day
          });
          res.status(200).send({
            message: "Login successful",
            user: userToken,
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
      res.status(500).send({ message: err, accessToken: null });
    }
  } else {
    res.status(400).send({ message: "Username and password are required" });
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
    res.status(400).send({ message: "Username and password are required" });
  }
});

module.exports = router;
