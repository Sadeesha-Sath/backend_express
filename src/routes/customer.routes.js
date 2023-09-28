const express = require("express");
const permissionCheck = require("../utils/permissionCheck");
const { findAll, findOne, addCustomer } = require("../models/customer.model");
const router = express.Router();

router.get("/", (req, res) => {
  if (permissionCheck("ALL_CUSTOMERS", req.user)) {
    findAll()
      .then((result) => {
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(301).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/:id", (req, res) => {
  if (permissionCheck("ALL_CUSTOMERS", req.user) || isOwnCustomer(id, req.user.userID)) {
    findOne(req.params.id)
      .then((result) => {
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(301).send({ message: "You don't have necessary permissions" });
  }
});

router.post("/new", (req, res) => {
  if (permissionCheck("ADD_CUSTOMER", req.user)) {
    addCustomer(req.body)
      .then((result) => {
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(301).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
