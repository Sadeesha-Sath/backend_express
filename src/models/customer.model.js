const { query, escapedQuery } = require("../services/db.service.js");
const {
  generateRandomPass,
  generateHash,
} = require("../utils/password_helper.js");

const findOne = async (id) => {
  const result = await query(
    `SELECT c.customerID, u.name, c.customerType, c.nic_br, c.dob, u.email,  c.address, c.phone, u.userID, u.username from Customer c left join User u on c.userID=u.userID where c.customerID=${id}`
  );
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    "SELECT c.customerID, u.name, c.customerType, c.nic_br, c.dob, u.email, c.address, c.phone, u.userID, u.username from Customer c left join User u on c.userID=u.userID order by c.customerID"
  );
  console.log(result);
  return result;
};

const addCustomer = async (data) => {
  const password = data.password ? data.password : generateRandomPass();
  const hashedPass = await generateHash(password);
  const result = await escapedQuery({
    sql: `
        START TRANSACTION;
        INSERT INTO User (userID, name, email, username, password) VALUES (NULL, ?, ?, ?, ?);
        INSERT INTO Customer (customerID, nic_br, address, phone, userID, customerType, dob) VALUES (NULL, ?, ?, ?, LAST_INSERT_ID(), ?, ?);
        COMMIT;`,
    values: [
      data.name,
      data.username,
      hashedPass,
      data.nic,
      data.address,
      data.phone,
      data.customerType,
      data.dob,
    ],
  });
  result.password = password;
  console.log(result);
  return result;
};

const findUserIDfromCustomerID = async (customerID) => {
  const result = await query(
    `SELECT userID from Customer where customerID=${customerID}`
  );
  console.log(result[0]);
  return result[0];
};

module.exports = { findOne, findAll, addCustomer, findUserIDfromCustomerID };
