const { query, escapedQuery } = require("@services/db.service.js");
const {
  generateRandomPass,
  generateHash,
} = require("@utils/password_helper.js");

const findOne = async (id) => {
  const result = await escapedQuery({
    sql: `SELECT * FROM CustomerView WHERE CustomerID=?`,
    values: [id],
  });
  console.log(result[0]);
  return result[0];
};

const findAll = async () => {
  const result = await query(
    "SELECT * from CustomerView ORDER BY CustomerID ASC"
  );
  console.log(result[0]);
  return result[0];
};

const addCustomer = async (data) => {
  const password = data.password ?? generateRandomPass();
  const hashedPass = await generateHash(password);
  console.log(data);
  const result = await escapedQuery({
    sql: `CALL add_customer(?,?, ?, ?, ?, ?, ?, ?, ?)`,
    values: [
      data.name,
      data.email,
      data.username,
      hashedPass,
      data.nic_br,
      data.address,
      data.phone,
      data.customerType,
      data.dob,
    ],
  });
  if (result) {
    if (!data.password) {
      result.password = password;
    }
    console.log(result);
  }
  return result;
};

const findUserIDfromCustomerID = async (customerID) => {
  const result = await escapedQuery({
    sql: `SELECT UserID from CustomerView where CustomerID=?`,
    values: [customerID],
  });
  console.log(result[0]);
  return result[0];
};


const findCustomerByNIC = async (nic) => {
  const result = await escapedQuery({
    sql: `SELECT * FROM CustomerView WHERE NIC_BR=?`,
    values: [nic],
  });
  return result[0];
};
module.exports = { findOne, findAll, addCustomer, findUserIDfromCustomerID, findCustomerByNIC };
