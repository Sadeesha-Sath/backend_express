const express = require("express");
const router = express.Router();
const permissionCheck = require("../utils/permissionCheck");
const {
  findOne,
  findAll,
  updateOne,
  getPassword,
  changePassword,
} = require("../models/user.model");
const { isOwnUser } = require("../models/isOwnData");
const { comparePasswords } = require("../utils/password_helper");

router.get("/", async (req, res) => {
  if (permissionCheck("ALL_USERS", req.user)) {
    findAll()
      .then((result) => {
        res.status(200).json(result);
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
  if (permissionCheck("ALL_USERS", req.user) || isOwnUser(id, req.user.id)) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such user" });
          return;
        }
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.put("/:id", (req, res) => {
  if (permissionCheck("UPDATE_USERS", req.user) || isOwnUser(id, req.user.id)) {
    updateOne(id, req.body)
      .then((result) => {
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.put("/:id/change_password", async (req, res) => {
  if (
    permissionCheck("UPDATE_USERS_PASSWORD", req.user) ||
    isOwnUser(id, req.user.id)
  ) {
    const curr_pass = req.body.current_password;
    const new_pass = req.body.new_password;
    try {
      if (comparePasswords(curr_pass, await getPassword(req.params.id))) {
        const result = await changePassword(req.params.id, new_pass);
        res.status(200).json(result);
      } else {
        res.status(401).send({ message: "Current password is incorrect" });
      }
    } catch (err) {
      console.error(err);
      res.status(500).send(err);
    }
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

module.exports = router;
