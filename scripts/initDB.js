require("module-alias/register");

const db = require("@services/db.service");
const fs = require("fs");
const path = require("path");

const initDB = async () => {
  const dbSQL = fs
    .readFileSync(path.resolve(__dirname, "./sql/setup_db.sql"))
    .toString();
  const dbArray = dbSQL.toString().trimStart().split("-- Query Sep");

  for (let query of dbArray) {
    if (query === "" || query === " ") continue; // Skip empty queries
    console.log("Query\n\n");
    console.log(query);
    console.log("\n\n");
    try {
      const result = await db.escapedQuery({
        sql: query + ";",
      });
      console.log(result);
    } catch (err) {
      console.log(err);
    }
  }
  const viewSQL = fs
    .readFileSync(path.resolve(__dirname, "./sql/views.sql"))
    .toString();
  const viewArray = viewSQL.toString().trimStart().split("-- Query Sep");

  for (let query of viewArray) {
    if (query === "" || query === " ") continue; // Skip empty queries
    console.log("Query\n\n");
    console.log(query);
    console.log("\n\n");
    try {
      const result = await db.escapedQuery({
        sql: query + ";",
      });
      console.log(result);
    } catch (err) {
      console.log(err);
    }
  }

  const procSQL = fs
    .readFileSync(path.resolve(__dirname, "./sql/functionAndProcedures.sql"))
    .toString();
  const procArray = procSQL.toString().trimStart().split("-- Query Sep");

  for (let query of procArray) {
    if (query === "" || query === " ") continue; // Skip empty queries
    console.log("Query\n\n");
    console.log(query);
    console.log("\n\n");
    try {
      const result = await db.escapedQuery({
        sql: query + ";",
      });
      console.log(result);
    } catch (err) {
      console.log(err);
    }
  }

  const triggerSQL = fs
    .readFileSync(path.resolve(__dirname, "./sql/triggers.sql"))
    .toString();
  const triggerArray = triggerSQL.toString().trimStart().split("-- Query Sep");

  for (let query of triggerArray) {
    if (query === "" || query === " ") continue; // Skip empty queries
    console.log("Query\n\n");
    console.log(query);
    console.log("\n\n");
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
    .readFileSync(path.resolve(__dirname, "./sql/insert_dummy_data.sql"))
    .toString();

  const dataArray = dataSQL.toString().trimStart().split("-- Query Sep");

  for (let query of dataArray) {
    if (query === "" || query === " ") continue; // Skip empty queries
    console.log("Query\n\n");
    console.log(query);
    console.log("\n\n");
    try {
      const result = await db.escapedQuery({
        sql: query + ";",
      });
      console.log(result);
    } catch (err) {
      console.log(err);
    }
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
