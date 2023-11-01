const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const {
  findAll,
  findOne,
  findFromUser,
  findAllMinimal,
} = require("@models/account.model");
const { isOwnAccount } = require("@models/isOwnData");

const router = express.Router();

router.get("/", async (req, res) => {
  if (permissionCheck("ALL_ACCOUNTS", req.user)) {
    try {
      const result = await findAll(req.query);
      res.status(200).send(result);
    } catch (err) {
      console.error(err);
      res.status(500).send(err);
    }
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/basic", async (req, res) => {
  try {
    const result = await findAllMinimal();
    res.status(200).send(result);
  } catch (err) {
    console.error(err);
    res.status(500).send(err);
  }
});

router.get("/my", async (req, res) => {
  if (req.user.Role === "customer") {
    console.log("here at my");
    const result = await findFromUser(req.user.UserID, req.query);
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

router.get("/:id", (req, res) => {
  console.log("here at id");
  if (
    permissionCheck("ALL_ACCOUNTS", req.user) ||
    isOwnAccount(req.params.id, req.user.UserID)
  ) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such Account" });
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
