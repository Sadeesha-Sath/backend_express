const express = require("express");
const { query, escapedQuery } = require("../services/db.service");
const permissionCheck = require("../utils/permissionCheck");
const router = express.Router();

router.get("/employees", (req, res) => {
  if (permissionCheck("ALL_EMPLOYEES")) {
    findAll()
      .then((result) => {
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(301).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/employees/:id", (req, res) => {
  if (permissionCheck("ALL_EMPLOYEES") || isOwnEmployee(id, req.user)) {
    findOne(req.params.id)
      .then((result) => {
        res.status(200).json(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    res.status(301).send({ message: "You don't have necessary permissions" });
  }
});

// router.post("/employees/new", (req, res) => {
//   if (permissionCheck("ADD_EMPLOYEE")) {
//     addEmploye(req.body)
//       .then((result) => {
//         res.status(200).json(result);
//       })
//       .catch((err) => {
//         console.error(err);
//         res.status(500).send(err);
//       });
//   } else {
//     res.status(301).send({ message: "You don't have necessary permissions" });
//   }
// });

module.exports = router;
