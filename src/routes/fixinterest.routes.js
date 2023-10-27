const express = require("express");
const {getInterests} = require("../models/fixinterest.model.js");
const router = express.Router();



  //need to be fixed
router.get("/", async(req, res)=>{
  try{
    const period = req.body.period;
    const interest = await getInterests();
    
    res.json(interest[0]);
  } catch(err){
    res.status(500).send("Unable to fetch data");
  }
    
    
})

module.exports = router;