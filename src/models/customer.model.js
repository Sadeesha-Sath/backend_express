const { query, escapedQuery } = require("../services/db.service.js");
const {
  generateRandomPass,
  generateHash,
} = require("../utils/password_helper.js");

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT
    c.CustomerID,
    u.Name,
    c.CustomerType,
    c.NIC_BR,
    c.DOB,
    u.Email,
    c.Address,
    c.Phone,
    u.UserID,
    u.Username
    from Customer c left join User u
    on c.UserID=u.UserID where c.CustomerID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    "SELECT c.CustomerID, u.Name, c.CustomerType, c.NIC_BR, c.DOB, u.Email, c.Address, c.Phone, u.UserID, u.Username from Customer c left join User u on c.UserID=u.UserID order by c.CustomerID"
  );
  console.log(result);
  return result;
};

const addCustomer = async (data) => {
  const password = data.password ? data.password : generateRandomPass();
  const hashedPass = await generateHash(password);
  const result = await escapedQuery({
    sql: `SELECT * FROM add_customer(?, ?, ?, ?, ?, ?, ?, ?)`,
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
    `SELECT UserID from Customer where CustomerID=${customerID}`
  );
  console.log(result[0]);
  return result[0];
};

module.exports = { findOne, findAll, addCustomer, findUserIDfromCustomerID };
