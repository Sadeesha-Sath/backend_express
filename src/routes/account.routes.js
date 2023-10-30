const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const { findAll, findOne, findFromUser } = require("@models/account.model");

const router = express.Router();

router.get("/", async (req, res) => {
  if (permissionCheck("ALL_ACCOUNTS", req.user)) {
    const result = await findAll(req.query);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/my", async (req, res) => {
  if (req.user.role == "customer") {
    const result = await findFromUser(req.user.id, req.query);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "Only Customers can get there accounts" });
  }
});

router.get("/ofUser/:id", async (req, res) => {
  if (permissionCheck("ALL_ACCOUNTS", req.user)) {
    const result = await findFromUser(req.params.id);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
