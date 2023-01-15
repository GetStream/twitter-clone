const express = require("express");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./routes/auth.js");

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.get("/", (req, res) => {
    res.send("Hello, World!");
});

app.use("/auth", authRoutes);
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
