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
  findAllPending,
} = require("@models/loanApplications.model.js");
const permissionCheck = require("@utils/permissionCheck");
const { getBranchfromUserID } = require("@models/branch.model");
const { findOwn } = require("../models/loanApplications.model");

// GET all loan applications
router.get("/", (req, res) => {
  if (permissionCheck("MY_LOAN_APPLICATIONS", req.user)) {
    findOwn(req.user.UserID)
      .then((result) => {
        res.status(200).send(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else if (permissionCheck("ALL_LOAN_APPLICATIONS", req.user)) {
    findAll(req.query.branchID)
      .then((result) => {
        res.status(200).send(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else if (req.query.branchID) {
    getBranchfromUserID(req.user.UserID).then((result) => {
      console.log(result);
      if (!result) {
        res.status(403).send({
          message: "You need to be an employee to view the applications",
        });
        return;
      }
      if (
        permissionCheck("BRANCH_LOAN_APPLICATIONS", req.user) &&
        result.BranchID == req.query.branchID
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
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/pending", (req, res) => {
  if (permissionCheck("ALL_LOAN_APPLICATIONS", req.user)) {
    findAllPending(req.query.branchID)
      .then((result) => {
        res.status(200).send(result);
      })
      .catch((err) => {
        console.error(err);
        res.status(500).send(err);
      });
  } else if (req.query.branchID) {
    getBranchfromUserID(req.user.UserID).then((result) => {
      if (!result) {
        res.status(403).send({
          message: "You need to be an employee to view the applications",
        });
        return;
      }
      if (
        permissionCheck("BRANCH_LOAN_APPLICATIONS", req.user) &&
        result.BranchID == req.query.branchID
      ) {
        findAllPending(req.query.branchID)
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
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

// POST create a new loan application
router.post("/new", (req, res) => {
  console.log(req.body);
  if (req.body.isOnline === true) {
    if (permissionCheck("ADD_ONLINE_LOAN_APPLICATION", req.user)) {
      addOnlineLoanApplication(req.body, req.user.UserID)
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
  } else {
    if (permissionCheck("ADD_OFFLINE_LOAN_APPLICATION", req.user)) {
      addOfflineLoanApplication(req.body, req.user.UserID)
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
      getBranchfromUserID(req.user.UserID).then((userRes) => {
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
router.post("/approve", (req, res) => {
  if (permissionCheck("APPROVE_LOAN_APPLICATION", req.user)) {
    getBranchIDfromLoanApplication(req.body?.id).then((result) => {
      if (!result) {
        res.status(404).send({ message: "No such loan application" });
        return;
      }
      getBranchfromUserID(req.user.UserID).then((userRes) => {
        if (result.BranchID == userRes.BranchID) {
          console.log("Here");
          approveLoanApplication(req.body?.id, req.user.UserID)
            .then((result) => {
              res.status(200).send(result);
            })
            .catch((err) => {
              console.error(err);
              res.status(500).send(err);
            });
        } else {
          res.status(403).send({
            message: "You can approve only the applications of your branch",
          });
        }
      });
    });
  } else {
    res.status(403).send({ message: "You are not authorized to do this" });
  }
});

// POST reject a loan application
router.post("/reject", (req, res) => {
  if (permissionCheck("REJECT_LOAN_APPLICATION", req.user)) {
    getBranchIDfromLoanApplication(req.body?.id).then((result) => {
      if (!result) {
        res.status(404).send({ message: "No such loan application" });
        return;
      }
      getBranchfromUserID(req.user.UserID).then((userRes) => {
        if (result.BranchID == userRes.BranchID) {
          console.log("Here");
          rejectLoanApplication(req.body?.id, req.user.UserID)
            .then((result) => {
              res.status(200).send(result);
            })
            .catch((err) => {
              console.error(err);
              res.status(500).send(err);
            });
        } else {
          res.status(403).send({
            message: "You can reject only the applications of your branch",
          });
        }
      });
    });
  } else {
    res.status(403).send({ message: "You are not authorized to do this" });
  }
});

module.exports = router;
