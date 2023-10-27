const express = require("express");
const { getAllAccounts, getView} = require("../models/fundTransfer.model.js");
const router = express.Router();


//need to be fixed
router.get("/accounts", async (req, res) =>{
    try{
      const accounts = await getAllAccounts();
      res.send(accounts);
    } catch(err){
      res.status(500).send("Unable to fetch data");
    }
  })
  


//need to be fixed
router.post("/proceed", async(req, res)=>{
  try{
    const branchId = req.body.brId;
    const views = await getView(branchId);
    res.json(views);
  } catch(err){
    res.status(500).send("Unable to fetch data");
  }
    
    
})

module.exports = router;