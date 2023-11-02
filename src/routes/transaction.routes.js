const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const { findOwn, findAll, findOne } = require("@models/transaction.model");
const { isOwnAccount } = require("@models/isOwnData");
const { addTransaction } = require("../models/transaction.model");
const router = express.Router();

router.get("/", async (req, res) => {
  try {
    let result;
    if (permissionCheck("ALL_TRANSACTIONS", req.user)) {
      result = await findAll();
    } else if (permissionCheck("MY_TRANSACTIONS", req.user)) {
      result = await findOwn(req.user.UserID);
    } else {
      res.status(403).send({ message: "Permissions not found" });
      return;
    }
    res.status(200).send(result);
  } catch (error) {
    console.error(err);
    res.status(500).send(err);
    return;
  }
});

router.post("/add", (req, res) => {
  if (req.body) {
    if (permissionCheck("ADD_TRANSACTION", req.user)) {
      addTransaction(req.body)
        .then((result) => {
          if (result) {
            res.status(200).send(result);
          } else {
            res.status(501).send({ message: "Transaction Failed" });
          }
        })
        .catch((err) => {
          console.error(err);
          res.status(500).send({ message: err.message });
        });
    } else if (
      permissionCheck("ADD_OWN_TRANSACTION", req.user) &&
      isOwnAccount(req.body?.fromAccNo, req.user.UserID)
    ) {
      addTransaction(req.body)
        .then((result) => {
          if (result) {
            res.status(200).send(result);
          } else {
            res.status(501).send({ message: "Transaction Failed" });
          }
        })
        .catch((err) => {
          console.error(err);
          res.status(500).send({ message: err.message });
        });
    }
  } else {
    res.status(400).send({ message: "Data is required" });
  }
});

// TODO Fix this
router.get("/:id", (req, res) => {
  if (
    permissionCheck("ALL_TRANSACTIONS", req.user) ||
    isOwnAccount(req.query.acc, req.user.UserID)
  ) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such transaction" });
          return;
        }
        res.status(200).send(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
