const express = require("express");
const { getAllBranches, getView} = require("../models/reports.model.js");
const router = express.Router();


//need to be fixed
router.get("/branches", async (req, res) =>{
    try{
      const branches = await getAllBranches();
      res.send(branches);
    } catch(err){
      res.status(500).send("Unable to fetch data");
    }
  })
  
  //need to be fixed
router.post("/view", async(req, res)=>{
  try{
    const branchId = req.body.brId;
    const reportType = req.body.reportType;
    const views = await getView(branchId, reportType);
    res.json(views);
  } catch(err){
    res.status(500).send("Unable to fetch data");
  }
    
    
})

module.exports = router;