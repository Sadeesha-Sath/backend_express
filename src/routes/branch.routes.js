const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const { findAll, findOne, findManager } = require("@models/branch.model");
const router = express.Router();

router.get("/", (req, res) => {
  if (permissionCheck("ALL_BRANCHES", req.user)) {
    findAll()
      .then((result) => {
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

router.get("/:id", (req, res) => {
  if (permissionCheck("ALL_BRANCHES", req.user)) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such Branch" });
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
