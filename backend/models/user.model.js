const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const jsonwebtoken = require('jsonwebtoken');

const userSchema = new mongoose.Schema({
    fullname: {
        firstname: {
            type: String,
            required: true,
            minlength: [3, 'First name must be at least 3 characters long'],
        },
        lastname: {
            type: String,
            minlength: [3, 'Last name must be at least 3 characters long'],
        }
    },
    email: {
        type: String,
        required: true,
        unique: true,
        minlength: [5, 'Email must be at least 5 characters long'],
    },
    password: {
        type: String,
        required: true,
        select: false, // Exclude password from queries by default
        minlength: [6, 'Password must be at least 6 characters long'],
    },
    socketId: {
        type: String,
    },
});

userSchema.methods.generateAuthToken = function () {
    const token = jsonwebtoken.sign(
        { _id: this._id },
        process.env.JWT_SECRET, 
        { expiresIn: '24h' }); // Token expires in 1 day 
    return token;
}

userSchema.methods.comparePassword = async function (candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password);
}

userSchema.statics.hashPassword = async function (password) {
    return await bcrypt.hash(password, 10);
} 

const userModel = mongoose.model('user', userSchema);

module.exports = userModel;