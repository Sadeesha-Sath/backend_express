const express = require("express");
const cors = require("cors");
require("module-alias/register");

const app = express();
app.use(cors()); // include before other routes
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

require("dotenv").config();



const db = require("./src/services/db.service");
const sql_q = 'Select BranchID, BranchName from branch';
const sql_view = 'SELECT * FROM monthlytransactioncountview';


// Routes

const verifyToken = require("./src/middlewares/verifyToken");
app.use("/", require("./src/routes/auth.routes"));
app.use("/customers", verifyToken, require("./src/routes/customer.routes"));
app.use("/employees", verifyToken, require("./src/routes/employee.routes"));
app.use(
  "/transactions",
  verifyToken,
  require("./src/routes/transaction.routes")
);
app.use("/users", verifyToken, require("./src/routes/user.routes"));

app.get("/", (req, res) => {
  res.send("Hello World");
});


//need to be fixed
app.get("/branches", async (req, res) =>{
  const branches = await db.query(sql_q);
  res.send(branches);
})

//need to be fixed
app.get("/view", async(req, res)=>{
  const views = await db.query(sql_view);
  res.send(views);
})



// 404 Not found
app.use("*", (req, res, next) => {
  console.error("404");
  res.status(404).send({ message: "Not found" });
});

// Start server
const port = process.env.PORT || 8080;

app
  .listen(port, () => {
    console.log(`App is listnening on port ${port}`);
  });
