const express = require("express");
const {
  findAllSavingInterestRates,
  findAllLoanInterestRates,
  findAllFDInterestRates,
} = require("@models/interest.model");

const router = express.Router();

router.get("/savings", (req, res) => {
  findAllSavingInterestRates()
    .then((result) => {
      res.status(200).send(result);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send(err);
    });
});

router.get("/loan", (req, res) => {
  findAllLoanInterestRates()
    .then((result) => {
      res.status(200).send(result);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send(err);
    });
});

router.get("/fd", (req, res) => {
  findAllFDInterestRates()
    .then((result) => {
      res.status(200).send(result);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).send(err);
    });
});

module.exports = router;
