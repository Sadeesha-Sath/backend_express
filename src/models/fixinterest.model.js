const { query, escapedQuery } = require("../services/db.service.js");  //need to fix the path


const getInterests = async()=>{
    const rates = await query('SELECT * from fixeddepositinterestrate;');
    return rates;

};



module.exports = {getInterests};