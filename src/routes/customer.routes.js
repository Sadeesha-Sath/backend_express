const express = require("express");
const { query, escapedQuery } = require("../services/db.service");
const permissionCheck = require("../utils/permissionCheck");
const { findAll, findOne, addCustomer } = require("../models/customer.model");
const router = express.Router();

router.get("/customers", (req, res) => {
  if (permissionCheck("ALL_CUSTOMERS")) {
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

router.get("/customers/:id", (req, res) => {
  if (permissionCheck("ALL_CUSTOMERS") || isOwnCustomer(id, req.user)) {
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

router.post("/customers/new", (req, res) => {
  if (permissionCheck("ADD_CUSTOMER")) {
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
