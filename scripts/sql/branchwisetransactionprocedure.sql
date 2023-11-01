DROP PROCEDURE IF EXISTS GetTransactionData;
DELIMITER //
CREATE PROCEDURE GetTransactionData(IN BrID varchar(20))
BEGIN
    SELECT TransactionID, 
    FromAccNo AS DebitedAcc, 
    ToAccNo AS CreditedAcc, 
    TrnType, Amount,
    a.BranchID AS DebitedBr,
    b.BranchID AS CreditedBr
    FROM transaction t
    LEFT JOIN account a ON t.FromAccNo = a.AccountNo
    LEFT JOIN account b ON t.ToAccNo = b.AccountNo
    WHERE a.BranchID = BrID OR b.BranchID = BrID;    
END//
DELIMITER ;