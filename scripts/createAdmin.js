require("module-alias/register");

const db = require("@services/db.service.js");
const { generateHash } = require("@utils/password_helper.js");

const addAdmin = async () => {
  const username = "admin";
  const password = "admin";
  const hashedPass = await generateHash(password);
  const result = await db.escapedQuery({
    sql: "INSERT INTO User (Name, Username, Password, Role) VALUES (?, ?, ?, ?, ?)",
    values: ["admin", "2000-01-01", username, hashedPass, "admin"],
  });
  console.log(result);
  return result;
};

addAdmin()
  .then(() => {
    console.log("Admin Added.");
    console.log("Exiting...");
    process.exit();
  })
  .catch((err) => {
    console.log(err);
    process.exit();
  });
