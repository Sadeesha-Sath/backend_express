
create procedure add_trn(in fromAccNo varchar(20), in toAccNo varchar(20), in amount decimal(15,2), in trnType varchar(20, in description varchar(100), out message varchar(100))
BEGIN ATOMIC
    SELECT balance FROM Account WHERE accountNo = fromAccNo FOR UPDATE;
    IF balance < amount THEN
        INSERT INTO Transaction (transactionID, fromAccNo, toAccNo, amount, trnType,  description) VALUES (NULL, fromAccNo, toAccNo, amount, trnType, description);
        UPDATE Account SET balance = balance - amount WHERE accountNo = fromAccNo;
        UPDATE Account SET balance = balance + amount WHERE accountNo = toAccNo;
    END IF;
END;
)