const moongoose = require('mongoose');
const becrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const captainSchema = new moongoose.Schema({
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
        lowercase: true, // Ensure email is stored in lowercase
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
    status: {
        type: String,
        enum: ['active', 'inactive'], // Example statuses
        default: 'inactive',
    },
    vehicle: {
        color: {
            type: String,
            required: true,
            minlength: [3, 'Color must be at least 3 characters long'],
        },
        plate: {
            type: String,
            required: true,
            minlength: [3, 'Plate must be at least 3 characters long'],
        },
        capacity: {
            type: Number,
            required: true,
            min: [1, 'Capacity must be at least 1'],
        },
        vehicleType: {
            type: String,
            required: true,
            enum: ['car', 'motorcycle', 'auto'], // Example vehicle types
        }
    },
    location: {
        lat: {
            type: Number,
        },
        lng: {
            type: Number,
        },
    },
});

captainSchema.methods.generateAuthToken = function () {
    const token = jwt.sign(
        { _id: this._id },
        process.env.JWT_SECRET, 
        { expiresIn: '24h' }); // Token expires in 1 day 
    return token;
}

captainSchema.methods.comparePassword = async function (candidatePassword) {
    return await becrypt.compare(candidatePassword, this.password);
}

captainSchema.statics.hashPassword = async function (password) {
    return await becrypt.hash(password, 10);
}

const captainModel = moongoose.model('captain', captainSchema);

module.exports = captainModel;