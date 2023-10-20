const { query, escapedQuery } = require("../services/db.service.js");  //need to fix the path

const getAllBranches = async () => {
    const branches = await query('Select BranchID, BranchName from branch');
    return branches;
  };

const getView = async(branchId)=>{
    const views = await escapedQuery({
        sql: 'CALL GetTransactionData(?)',
        values: [branchId]
    });
    return views;
}


module.exports = { getAllBranches, getView};