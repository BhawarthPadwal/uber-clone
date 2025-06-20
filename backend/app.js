const dotenv = require('dotenv');
dotenv.config(); // Load environment variables from .env file
const express = require('express');
const cors = require('cors');
const app = express();
const connectToDb = require('./db/db'); // Import the database connection function
const userRoutes = require('./routes/user.routes'); // Import user routes
const captainRoutes = require('./routes/captain.routes'); // Import captain routes
const mapsRoutes = require('./routes/maps.routes'); // Import maps routes
const rideRoutes = require('./routes/ride.routes'); // Import ride routes
const cookieParser = require('cookie-parser'); // Import cookie parser middleware

connectToDb(); // Connect to the database

app.use(cors()); // Enable CORS for all routes
app.use(express.json()); // Parse JSON request bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded request bodies
app.use(cookieParser()); // Parse cookies from request headers

app.get('/', (req, res) => {
  res.send('Hello, World!');
});

app.use('/users', userRoutes); // Use user routes under /users
app.use('/captains', captainRoutes); // Use captain routes under /captains
app.use('/maps', mapsRoutes); // Use maps routes under /maps
app.use('/rides', rideRoutes); // Use ride routes under /rides


module.exports = app;
