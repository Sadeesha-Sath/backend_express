const express = require("express");
const cors = require("cors");
require("module-alias/register");

const app = express();
app.use(cors()); // include before other routes
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

require("dotenv").config();

const db = require("./src/services/db.service");

// Routes

const verifyToken = require("@middlewares/verifyToken");
app.use("/auth", require("@routes/auth.routes"));
app.use("/customers", verifyToken, require("@routes/customer.routes"));
app.use("/employees", verifyToken, require("@routes/employee.routes"));
app.use("/transactions", verifyToken, require("@routes/transaction.routes"));
app.use("/users", verifyToken, require("@routes/user.routes"));
app.use("/accounts", verifyToken, require("@routes/account.routes"));
app.use("/branches", verifyToken, require("@routes/branch.routes.js"));

app.get("/", (req, res) => {
  res.send("Hello World");
});

// 404 Not found
app.use("*", (req, res) => {
  console.error("404");
  // console.log(req);
  res.status(404).send({ message: "Not found" });
});

// Start server
const port = process.env.PORT || 8080;

app.listen(port, () => {
  console.log(`App is listnening on port ${port}`);
});
