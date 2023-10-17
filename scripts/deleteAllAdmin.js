require("module-alias/register");

const db = require("@services/db.service.js");

const deleteAllAdmin = async () => {
  const result = await db.escapedQuery({
    sql: "DELETE FROM User WHERE Role='admin'",
  });
  console.log(result);
  return result;
};

db.connect().then(() => {
  deleteAllAdmin()
    .then(() => {
      console.log(
        "All admins deleted. Please consider running create admin script to add admin users."
      );
      console.log("Exiting...");
      process.exit();
    })
    .catch((err) => {
      console.log(err);
      process.exit();
    });
});
