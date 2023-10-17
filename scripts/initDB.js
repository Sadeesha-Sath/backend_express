const db = require("../src/services/db.service.js");
const fs = require("fs");



const initDB = async () => {
  const dbSQL = fs.readFileSync("./setup_db.sql").toString();
  const dbArray = dbSQL.toString().split(");");
  
  for (let query of dbArray) {
    const result = await db.escapedQuery({
      sql: query
    });
    console.log(result);
  }
  const dataSQL = fs.readFileSync("./insert_dummy_data.sql").toString();
  const dataArray = dataSQL.toString().split(");");
  for (let query of dataArray) {
    const result = await db.escapedQuery({
      sql: query
    });
    console.log(result);
  }
  const viewSQL = fs.readFileSync("./views.sql").toString();
  const viewArray = viewSQL.toString().split(");");
  for (let query of viewArray) {
    const result = await db.escapedQuery({
      sql: query
    });
    console.log(result);
  }
  console.log("Database setup complete.");
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
