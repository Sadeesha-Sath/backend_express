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
    isOwnCustomer(req.params.id, req.user.UserID)
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

router.post("/new", async (req, res) => {
  if (permissionCheck("ADD_CUSTOMER", req.user)) {
    if (req.body.username && req.body.email && req.body.password) {
      try {
        const user = await findByUsername(req.body.username);
        if (
          (Array.isArray(user) && user.length === 0) ||
          (!Array.isArray(user) && !user)
        ) {
          const result = await addCustomer(req.body);
          if (result) {
            res
              .status(200)
              .send({ message: "Customer User created", result: result });
          } else {
            res.status(500).send({ message: "Error" });
          }
        } else {
          res.status(400).send({
            message:
              "There is an already active user with this username. Please enter another username or use login",
          });
        }
      } catch (err) {
        res.status(500).send({ message: err });
      }
    } else {
      res.status(400).send({ message: "Username and Password are required" });
    }
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
