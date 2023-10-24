const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const { findAll, findOne, addCustomer } = require("@models/customer.model");
const router = express.Router();

router.get("/", (req, res) => {
  console.log("At Customer Get");
  if (permissionCheck("ALL_CUSTOMERS", req.user)) {
    console.log("In Customer Get");
    findAll()
      .then((result) => {
        res.status(200).send(result);
        return;
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
        return;
      });
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
    return;
  }
});

router.get("/:id", (req, res) => {
  if (
    permissionCheck("ALL_CUSTOMERS", req.user) ||
    isOwnCustomer(id, req.user.userID)
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

router.post("/new", (req, res) => {
  if (permissionCheck("ADD_CUSTOMER", req.user)) {
    addCustomer(req.body)
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

module.exports = router;
