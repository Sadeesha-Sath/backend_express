require("module-alias/register");

const db = require("@services/db.service");
const fs = require("fs");
const path = require("path");

const initDB = async () => {
  const dbSQL = fs
    .readFileSync(path.resolve(__dirname, "./scripts/setup_db.sql"))
    .toString();
  const dbArray = dbSQL.toString().trimStart().split(";");

  for (let query of dbArray) {
    console.log(query + ";");
    try {
      const result = await db.escapedQuery({
        sql: query + ";",
      });
      console.log(result);
    } catch (err) {
      console.log(err);
    }
  }
  const dataSQL = fs
    .readFileSync(path.resolve(__dirname, "./scripts/insert_dummy_data.sql"))
    .toString();
  const dataArray = dataSQL.toString().trimStart().split(";");
  for (let query of dataArray) {
    console.log(query);
    const result = await db.escapedQuery({
      sql: query + ";",
    });
    console.log(result);
  }
  const viewSQL = fs
    .readFileSync(path.resolve(__dirname, "./scripts/views.sql"))
    .toString();
  const viewArray = viewSQL.toString().trimStart().split(";");

  for (let query of viewArray) {
    console.log(query);
    if (query === "") continue;
    const result = await db.escapedQuery({
      sql: query + ";",
    });
    console.log(result);
  }
  console.log("Database setup complete.");
};

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
