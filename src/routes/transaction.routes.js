const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const { findOwn, findAll, findOne } = require("@models/transaction.model");
const { isOwnAccount } = require("@models/isOwnData");
const router = express.Router();

// TODO Compelete this module
router.get("/", async (req, res) => {
  let result;
  try {
    if (req.query.acc && isOwnAccount(req.query.acc, req.user.UserID)) {
      result = await findOwn(req.query.acc);
    } else if (permissionCheck("ALL_TRANSACTIONS", req.user)) {
      result = await findAll();
    } else {
      res.status(403).send({ message: "Permissions not found" });
    }
  } catch (error) {
    console.error(err);
    res.status(500).send(err);
  }
  res.status(200).send(result);
});

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
