const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors);
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

require("dotenv").config()

// Routes

const authRoute = require("./src/routes/auth.routes");
const customerRoute = require("./src/routes/customer.routes");
const verifyToken = require("./src/middlewares/verifyToken");
app.use("/oauth", authRoute);
app.use("/customers", verifyToken, customerRoute);

const port = process.env.PORT || 8080;

app.listen(port, () => {
  console.log(`App is listnening on port ${port}`);
});
