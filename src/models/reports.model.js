const { query, escapedQuery } = require("../services/db.service.js");  //need to fix the path

const getAllBranches = async () => {
    const branches = await query('Select BranchID, BranchName from branch');
    return branches;
  };

const getView = async(branchId, reportType)=>{
    let views;
    if (reportType == 'transaction'){
        views = await escapedQuery({
            sql: 'CALL GetTransactionData(?)',
            values: [branchId]
        });
    } else if (reportType == 'loan'){
        views = await escapedQuery({
            sql: 'CALL GetLoanInstallmentData(?)',
            values: [branchId]
        });
    } else{
        console.log('Error');
    }
        
    return views;
}


module.exports = { getAllBranches, getView};