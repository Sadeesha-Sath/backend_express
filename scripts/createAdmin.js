const db = require("../src/services/db.service.js");
const { generateHash } = require("../src/utils/password_helper.js");

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

db.connect().then(() => {
  addAdmin()
    .then(() => {
      console.log("Admin created with username: admin and password: admin");
      console.log("Exiting...");
      process.exit();
    })
    .catch((err) => {
      console.log(err);
      process.exit();
    });
});
