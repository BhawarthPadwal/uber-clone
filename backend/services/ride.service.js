const { send } = require('process');
const rideModel = require('../models/ride.model');
const mapService = require('../services/maps.service'); // Assuming you have a map service for fare calculation
const crypto = require('crypto');

function getOtp(num) {
    function generateOtp(num) {
        const otp = crypto.randomInt(Math.pow(10, num-1), Math.pow(10,num)).toString();
        return otp;
    }
    return generateOtp(num);
}

async function getFare(pickup, destination) {

    if (!pickup || !destination) {
        throw new Error('Pickup and destination are required');
    }

    const distanceTime = await mapService.getDistanceAndTime(pickup, destination);

    const baseFare = {
        auto: 30,
        car: 50,
        moto: 20
    };

    const perKmRate = {
        auto: 10,
        car: 15,
        moto: 8
    };

    const perMinuteRate = {
        auto: 2,
        car: 3,
        moto: 1.5
    };



    const fare = {
        auto: Math.round(baseFare.auto + ((distanceTime.distance.value / 1000) * perKmRate.auto) + ((distanceTime.duration.value / 60) * perMinuteRate.auto)),
        car: Math.round(baseFare.car + ((distanceTime.distance.value / 1000) * perKmRate.car) + ((distanceTime.duration.value / 60) * perMinuteRate.car)),
        moto: Math.round(baseFare.moto + ((distanceTime.distance.value / 1000) * perKmRate.moto) + ((distanceTime.duration.value / 60) * perMinuteRate.moto))
    };

    return fare;
}

module.exports.getFare = getFare;

module.exports.createRide = async ({user, pickup, destination, vehicleType }) => {
    // Validate inputs
    if (!pickup || !destination || !vehicleType) {
        throw new Error('User ID, pickup, destination, and vehicle type are required');
    }

    // Calculate fare
    const fare = await getFare(pickup, destination);

    // Create a new ride document
    const ride = new rideModel({
        user,
        pickup,
        destination,
        otp: getOtp(6), // Generate a 6-digit OTP
        fare: fare[vehicleType], // Use the fare for the specified vehicle type
    });

    // Save the ride to the database
    await ride.save();

    return ride;
} 

module.exports.confirmRide = async (rideId, captain) => {

    if (!rideId) {
        throw new Error('Ride ID is required');
    }

    await rideModel.findByIdAndUpdate(rideId, { status: 'accepted', captain: captain._id });

    const ride = await rideModel.findOne({ _id: ride }).populate('user').populate('captain').select('+otp');

    if (!ride) {
        throw new Error('Ride not found');
    }

    ride.status = 'accepted';

    return ride.save();
}

module.exports.startRide = async (rideId, otp, captain) => {

    if (!rideId || !otp) {
        throw new Error('Ride ID and OTP are required');
    }


    if (!ride) {
        throw new Error('Ride not found');
    }

    if (ride.otp !== otp) {
        throw new Error('Invalid OTP');
    }

    await rideModel.findByIdAndUpdate(rideId, { status: 'in-progress', otp: '' });

    sendMessageToSocketId(ride.user.socketId, {
        event: 'ride-started',
        data: ride
    });

    return ride.save();
}

module.exports.endRide = async (rideId, captain) => {

    if (!rideId) {
        throw new Error('Ride ID is required');
    }

    const ride = await rideModel.findById(rideId).populate('user').populate('captain').select('+otp') ;

    if (!ride) {
        throw new Error('Ride not found');
    }

    if (ride.status !== 'in-progress') {
        throw new Error('Ride is not in progress');
    }

    await rideModel.findByIdAndUpdate(rideId, { status: 'completed' });

    // Optionally, you can calculate the final fare based on actual distance and time
    // For now, we will just return the ride as is

    sendMessageToSocketId(ride.user.socketId, {
        event: 'ride-completed',
        data: ride
    });

    return ride.save();

}