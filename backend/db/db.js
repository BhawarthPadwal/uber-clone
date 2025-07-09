const mongoose = require('mongoose');

// function connectToDatabase() {
//     mongoose.connect(process.env.MONGODB_URI, {
//         useNewUrlParser: true,
//         useUnifiedTopology: true}).then(
//         () => {
//             console.log('Connected to MongoDB successfully');
//         }
//         ).catch(err => {
//         console.error('Error connecting to MongoDB:', err);});
// }
function connectToDatabase() {
    mongoose.connect(process.env.MONGODB_URI).then(
        () => {
            console.log('Connected to MongoDB successfully');
        }
        ).catch(err => {
        console.error('Error connecting to MongoDB:', err);});
}

module.exports = connectToDatabase;