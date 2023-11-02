const express = require("express");
const { getView } = require("../models/reports.model.js");
const permissionCheck = require("../utils/permissionCheck.js");
const router = express.Router();

//need to be fixed
router.get("/view", async (req, res) => {
  if (permissionCheck("REPORTS_VIEW", req.user)) {
    try {
      const branchId = req.query?.branchId;
      const reportType = req.query?.reportType;
      const views = await getView(branchId, reportType);
      res.json(views);
    } catch (err) {
      res.status(500).send("Unable to fetch data");
    }
  } else {
    res
      .status(403)
      .send({ message: "You don't have permission to view this resource" });
  }
});

module.exports = router;
