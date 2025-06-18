const dotenv = require('dotenv');
dotenv.config(); // Load environment variables from .env file
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors()); // Enable CORS for all routes

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

module.exports = app;
