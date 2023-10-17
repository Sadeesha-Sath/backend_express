const db = require("../src/services/db.service.js");
const { generateHash } = require("../src/utils/password_helper.js");
const fs = requre("fs");



const initDB = async () => {
  const dataSql = fs.readFileSync("./setup_db.sql").toString();
  const dataArr = dataSql.toString().split(");");
  
  const result = await db.escapedQuery({
    sql: "INSERT INTO User (Name, Username, Password, Role) VALUES (?, ?, ?, ?, ?)",
    values: ["admin", "2000-01-01", username, hashedPass, "admin"],
  });
  console.log(result);
  return result;
};

db.connect().then(() => {
  initDB()
    .then(() => {
      console.log("Setup complete.");
      console.log("Exiting...");
      process.exit();
    })
    .catch((err) => {
      console.log(err);
      process.exit();
    });
});
