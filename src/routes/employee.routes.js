const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const router = express.Router();
const { findAll, findOne, addEmployee } = require("@models/employee.model");

router.get("/", (req, res) => {
  if (permissionCheck("ALL_EMPLOYEES", req.user)) {
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
  if (
    permissionCheck("ALL_EMPLOYEES", req.user) ||
    isOwnEmployee(req.params.id, req.user.UserID)
  ) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such employee" });
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
  if (permissionCheck("ADD_EMPLOYEE", req.user)) {
    addEmployee(req.body)
      .then((result) => {
        res.status(200).send(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send({ message: err });
      });
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
