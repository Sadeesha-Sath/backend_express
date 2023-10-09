const express = require("express");
const permissionCheck = require("../utils/permissionCheck");
const router = express.Router();

router.get("/", (req, res) => {
  if (permissionCheck("ALL_EMPLOYEES", req.user.id)) {
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
  if (
    permissionCheck("ALL_EMPLOYEES", req.user) ||
    isOwnEmployee(id, req.user.id)
  ) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such employee" });
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
//     res.status(403).send({ message: "You don't have necessary permissions" });
//   }
// });

module.exports = router;
