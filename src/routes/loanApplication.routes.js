const express = require("express");
const router = express.Router();
const {
  findAll,
  findOne,
  getBranchIDfromLoanApplication,
  approveLoanApplication,
  rejectLoanApplication,
  addOnlineLoanApplication,
  addOfflineLoanApplication,
} = require("@models/loanApplications.model.js");

// GET all loan applications
router.get("/", (req, res) => {
  if (req.query.branchID) {
    getBranchfromUserID(req.user.userID).then((result) => {
      if (result === null) {
        res.status(403).send({
          message: "You need to be an employee to view the applications",
        });
        return;
      }
      if (
        permissionCheck("BRANCH_LOAN_APPLICATIONS", req.user) &&
        result.branchID === req.query.branchID
      ) {
        findAll(req.query.branchID)
          .then((result) => {
            res.status(200).send(result);
          })
          .catch((err) => {
            console.error(err);
            res.status(500).send(err);
          });
      } else {
        res.status(403).send({
          message:
            "You don't have necessary permissions to view all applications. Please consider selecting your branch",
        });
      }
    });
  } else {
    if (permissionCheck("ALL_LOAN_APPLICATIONS", req.user)) {
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
  }
});

// GET one loan application
router.get("/:id", (req, res) => {
  if (permissionCheck("ALL_LOAN_APPLICATION", req.user)) {
    findOne(req.params.id)
      .then((result) => {
        res.status(200).send(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else {
    getBranchIDfromLoanApplication(req.params.id).then((result) => {
      if (!result) {
        res.status(404).send({ message: "No such loan application" });
        return;
      }
      getBranchfromUserID(req.user.userID).then((userRes) => {
        if (
          permissionCheck("BRANCH_LOAN_APPLICATION", req.user) &&
          result.branchID == userRes.branchID
        ) {
          findOne(req.params.id)
            .then((result) => {
              res.status(200).send(result);
            })
            .catch((err) => {
              console.error(err);
              res.status(500).send(err);
            });
        } else {
          res
            .status(403)
            .send({ message: "You don't have necessary permissions" });
        }
      });
    });
  }
});

// POST approve a loan application
router.post("/:id/approve", (req, res) => {
  if (permissionCheck("APPROVE_LOAN_APPLICATION", req.user)) {
    getBranchIDfromLoanApplication(req.params.id).then((result) => {
      if (!result) {
        res.status(404).send({ message: "No such loan application" });
        return;
      }
      getBranchfromUserID(req.user.userID).then((userRes) => {
        if (result.branchID != userRes.branchID) {
          approveLoanApplication(req.params.id, req.user.userID)
            .then((result) => {
              res.status(200).send(result);
            })
            .catch((err) => {
              console.error(err);
              res.status(500).send(err);
            });
        }
      });
    });
  }
});

// POST reject a loan application
router.post("/:id/reject", (req, res) => {
  if (permissionCheck("REJECT_LOAN_APPLICATION", req.user)) {
    getBranchIDfromLoanApplication(req.params.id).then((result) => {
      if (!result) {
        res.status(404).send({ message: "No such loan application" });
        return;
      }
      getBranchfromUserID(req.user.userID).then((userRes) => {
        if (result.branchID != userRes.branchID) {
          rejectLoanApplication(req.params.id, req.user.userID)
            .then((result) => {
              res.status(200).send(result);
            })
            .catch((err) => {
              console.error(err);
              res.status(500).send(err);
            });
        }
      });
    });
  }
});

// POST create a new loan application
router.post("/new", (req, res) => {
  if (req.body.isOnline === true) {
    if (permissionCheck("ADD_ONLINE_LOAN_APPLICATION", req.user)) {
      addOnlineLoanApplication(req.body, req.user.userID)
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
  }
  if (permissionCheck("ADD_OFFLINE_LOAN_APPLICATION", req.user)) {
    addOfflineLoanApplication(req.body, req.user.userID)
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
