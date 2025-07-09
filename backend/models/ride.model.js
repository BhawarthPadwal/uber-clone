const mongoose = require('mongoose');

const rideSchema = new mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    },
    captain: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'captain',
    },
    pickup: {
        type: String,
        required: true,
    },
    destination: {
        type: String,
        required: true,
    },
    distance: {
        type: Number,
    }, // in meters
    duration: {
        type: Number,
    },// in seconds
    status: {
        type: String,
        enum: ['pending', 'accepted', 'ongoing','completed', 'paid', 'cancelled'],
        default: 'pending',
    },
    fare: {
        type: Number,
        required: true,
    },
    paymentId: {
        type: String,
    },
    orderId: {
        type: String,
    },
    signature: {
        type: String,
    },
    otp: {
        type: String,
        select: false, // Do not return OTP in queries
        required: true,
    },

});

module.exports = mongoose.model('Ride', rideSchema);