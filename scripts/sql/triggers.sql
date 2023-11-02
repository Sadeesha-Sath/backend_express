DELIMITER $$
DROP TRIGGER IF EXISTS Change_Balance_Trigger$$
CREATE TRIGGER Change_Balance_Trigger BEFORE INSERT ON Transaction 
FOR EACH ROW
BEGIN
    IF NEW.FromAccNo is not null THEN
		UPDATE Account SET Balance = Balance - NEW.Amount WHERE accountNo = NEW.FromAccNo;
	END IF;
    IF NEW.ToAccNo is not null THEN
		UPDATE Account SET Balance = Balance + NEW.Amount WHERE accountNo = NEW.ToAccNo;
	END IF;
END$$

DELIMITER ;
