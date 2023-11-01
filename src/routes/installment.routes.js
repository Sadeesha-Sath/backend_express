const express = require("express");
const permissionCheck = require("@utils/permissionCheck");
const {
  findAll,
  findOwn,
  findPendingInstallments,
  findOwnPendingInstallments,
  findOverdueInstallments,
  findOwnOverdueInstallments,
} = require("@models/installment.model");

const router = express.Router();

router.get("/", async (req, res) => {
  if (permissionCheck("ALL_INSTALLMENTS", req.user)) {
    const result = await findAll(req.query.branchID);
    res.status(200).send(result);
  } else if (permissionCheck("MY_INSTALLMENTS", req.user)) {
    const result = await findOwn(req.user.UserID);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/pending", async (req, res) => {
  if (permissionCheck("ALL_INSTALLMENTS", req.user)) {
    const result = await findPendingInstallments(req.query.branchID);
    res.status(200).send(result);
  } else if (permissionCheck("MY_INSTALLMENTS", req.user)) {
    const result = await findOwnPendingInstallments(
      req.user.UserID,
      req.query.branchID
    );
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/overdue", async (req, res) => {
  if (permissionCheck("ALL_INSTALLMENTS", req.user)) {
    const result = await findOverdueInstallments(req.query.branchID);
    res.status(200).send(result);
  } else if (permissionCheck("MY_INSTALLMENTS", req.user)) {
    const result = await findOwnOverdueInstallments(req.user.UserID);
    res.status(200).send(result);
  } else {
    res.status(403).send({ message: "You don't have necessary permissions" });
  }
});

router.get("/:loanID/:dueDate", (req, res) => {
  if (
    permissionCheck("ALL_INSTALLMENTS", req.user) ||
    isOwnLoan(req.params.loanID, req.user.UserID)
  ) {
    findOne(req.params.id)
      .then((result) => {
        if (!result) {
          res.status(404).send({ message: "No such installment" });
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
