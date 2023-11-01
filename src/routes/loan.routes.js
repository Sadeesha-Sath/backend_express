const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const {
  findAll,
  findActiveLoans,
  findOne,
  findOwn,
  findOwnActiveLoans,
  findInterests
} = require("@models/loan.model");

const router = express.Router();

router.get("/", async (req, res) => {
  if (permissionCheck("ALL_LOANS", req.user)) {
    const result = await findAll(req.query);
    res.status(200).send(result);
  } else if (permissionCheck("MY_LOANS", req.user)) {
    const result = await findOwn(req.user.UserID);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/active", async (req, res) => {
  if (permissionCheck("ALL_LOANS", req.user)) {
    const result = await findActiveLoans(req.query);
    res.status(200).send(result);
  } else if (permissionCheck("MY_LOANS", req.user)) {
    const result = await findOwnActiveLoans(req.user.UserID);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/interests", async (req, res) => {
  if (permissionCheck("ALL_INTERESTS", req.user)) {
    const result = await findInterests();
    res.status(200).send(result);
  }  else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/:id", (req, res) => {
  if (permissionCheck("ALL_LOANS", req.user) || isOwnFD(id, req.user.UserID)) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such loan" });
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
    const result = await findOwn(req.params.id);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
