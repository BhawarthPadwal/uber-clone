const http = require('http');
const app = require('./app'); // Import the Express app
const mongoose = require('mongoose');

const port = process.env.PORT || 3000; // Use PORT from environment variables or default to 3000

mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/uberdb')
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.error('Error connecting to MongoDB:', err));

const server = http.createServer(app); // Create an HTTP server using the Express app

server.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});