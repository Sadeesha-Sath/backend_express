const express = require("express");
const { findByUsername } = require("@models/user.model");
const { comparePasswords } = require("@utils/password_helper");
const { addCustomer, findCustomerByNIC } = require("@models/customer.model");
const generateToken = require("../utils/tokenGenerator");
const tokenVerification = require("../utils/tokenVerification");
const { generateHash } = require("../utils/password_helper");
const router = express.Router();

router.post("/login", async (req, res) => {
  if (req.body.username && req.body.password) {
    try {
      const user = await findByUsername(req.body.username);
      if (
        (Array.isArray(user) && user.length) ||
        (!Array.isArray(user) && user)
      ) {
        if (await comparePasswords(req.body.password, user.Password)) {
          const { Password, ...userRest } = user;
          const token = generateToken(userRest);
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

router.post("/checkUsername", async (req, res) => {
  if (req.body.username) {
    try {
      const user = await findByUsername(req.body.username);
      const isAvailable = Boolean(
        (Array.isArray(user) && user.length !== 0) ||
          (!Array.isArray(user) && !user)
      );
      res.status(200).send({
        available: isAvailable,
        message: isAvailable ? "Username Available" : "Username not available",
      });
      return;
    } catch (err) {
      console.log(err);
      res.status(500).send({ message: err });
    }
  }
});

router.post("/checkNic", async (req, res) => {
  if (req.body.nic) {
    try {
      const user = await findCustomerByNIC(req.body.nic);
      //console.log(user);
      const customerExists = Boolean(
        !(
          (Array.isArray(user) && user.length !== 0) ||
          (!Array.isArray(user) && !user)
        )
      );
      res.status(200).send({
        exists: customerExists,
        message: customerExists ? "Customer Exists" : "Customer does not exist",
      });
      console.log(res.message);
      return;
    } catch (err) {
      console.log(err);
      res.status(500).send({ message: err });
    }
  }
});

router.post("/signup", async (req, res) => {
  if (req.body.username && req.body.email && req.body.password) {
    try {
      const user = await findByUsername(req.body.username);
      if (
        (Array.isArray(user) && user.length === 0) ||
        (!Array.isArray(user) && !user)
      ) {
        const result = await addCustomer(req.body);
        if (result) {
          res
            .status(200)
            .send({ message: "Customer User created", result: result });
        } else {
          res.status(500).send({ message: "Error" });
        }
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

router.post("/verify", async (req, res) => {
  if (req.body.token) {
    const user = tokenVerification(req.body.token);
    if (user) {
      console.log("Token is valid");
      res.status(200).send({ message: "Token is valid", user: user });
      return;
    }
  }
  console.log("Token is invalid");
  res.status(401).send({ message: "Token is invalid" });
});

module.exports = router;
