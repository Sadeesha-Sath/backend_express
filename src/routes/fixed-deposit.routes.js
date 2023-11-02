const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const {
  findAll,
  findOne,
  findFromUser,
} = require("@models/fixed-deposit.model");
const { isOwnFD } = require("@models/isOwnData");
const { addOne } = require("../models/fixed-deposit.model");

const router = express.Router();

router.get("/", async (req, res) => {
  if (permissionCheck("ALL_FD", req.user)) {
    const result = await findAll(req.query);
    res.status(200).send(result);
  } else if ((permissionCheck("MY_FD"), req.user)) {
    const result = await findFromUser(req.user.UserID, req.query);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/my", async (req, res) => {
  if (req.user.Role == "customer") {
    const result = await findFromUser(req.user.UserID, req.query);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "Only Customers can get there accounts" });
  }
});

router.post("/new", async (req, res) => {
  if (permissionCheck("ADD_FD", req.user)) {
    try {
      const result = await addOne(req.body);
      res.status(200).send(result);
    } catch (err) {
      console.error(err);
      res.status(500).send({ message: err });
    }
  } else {
    res.status(403).send({ message: "You don't have permission to do this" });
  }
});

router.get("/:id", (req, res) => {
  if (
    permissionCheck("ALL_FD", req.user) ||
    isOwnFD(req.params.id, req.user.UserID)
  ) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such customer" });
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

router.get("/ofUser/:id", async (req, res) => {
  if (permissionCheck("ALL_FD", req.user)) {
    const result = await findFromUser(req.params.id);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
