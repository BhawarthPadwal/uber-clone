const rideService = require('../services/ride.service');
const { validationResult } = require('express-validator');
const mapService = require('../services/maps.service');
const { sendMessageToSocketId } = require('../socket');
const rideModel = require('../models/ride.model');

module.exports.createRide = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { pickup, destination, vehicleType } = req.body;

    try {
        console.log("📦 Request Body:", { pickup, destination, vehicleType });

        const ride = await rideService.createRide({ user: req.user._id, pickup, destination, vehicleType });
        
        console.log("✅ Ride Created:", ride._id);

        res.status(201).json(ride);

        const pickupCoordinates = await mapService.getAddressCoordinates(pickup);

        console.log("📍 Pickup Coordinates:", pickupCoordinates);

        const captainsInRadius = await mapService.getCaptainsInTheRadius(pickupCoordinates.ltd, pickupCoordinates.lng, 10);

        console.log("Captain: ", captainsInRadius);

        console.log("🔍 Captains Found:", captainsInRadius.length);

        // ride.otp = "";

        const rideWithUser = await rideModel.findById(ride._id).populate('user');

        console.log(rideWithUser);

        captainsInRadius.map(captain => {

            console.log(captain, ride);
            
            sendMessageToSocketId(captain.socketId, {
                event: 'new-ride',
                data: rideWithUser
            });
        });

        // captainsInRadius.map((captain) => {
        //     if (!captain.socketId) {
        //         console.log(`⚠️ Captain ${captain.name} has no socketId`);
        //     } else {
        //         console.log(`📤 Emitting 'new-ride' to: ${captain.socketId}`);
        //         sendMessageToSocketId(captain.socketId, {
        //             event: "new-ride",
        //             data: rideWithUser,
        //         });
        //     }
        // });

    } catch (error) {
        console.error('Error creating ride:', error);
        return res.status(500).json({ message: 'Failed to create ride' });
    }
}

module.exports.cancelRide = async (req, res) => {
    const err = validationResult(req);
    if (!err.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { rideId } = req.query;
    const userId = req.user._id;

    try {
        const cancelledRide = await rideService.cancelRide(rideId, userId);
        
        res.status(200).json({
            message: 'Ride cancelled successfully',
            data: cancelledRide,
        });

    } catch (error) {
        console.error('Error cancelling ride:', error.message);
        res.status(400).json({ error: error.message });
    }
}

module.exports.getFare = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    const { pickup, destination } = req.query;

    try {
        const fare = await rideService.getFare(pickup, destination);
        return res.status(200).json(fare);
    } catch (error) {
        console.error('Error fetching fare:', error);
        return res.status(500).json({ message: 'Failed to fetch fare' });
    }
}

module.exports.confirmRide = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { rideId } = req.query;
    try {
        const ride = await rideService.confirmRide(rideId, req.captain);

        sendMessageToSocketId(ride.user.socketId, {
            event: 'ride-confirmed',
            data: ride
        });

        return res.status(200).json(ride);
    } catch (error) {
        console.error('Error confirming ride:', error);
        return res.status(500).json({ message: 'Failed to confirm ride' });
    }
}

module.exports.startRide = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { rideId, otp } = req.query;

    try {
        const ride = await rideService.startRide(rideId, otp, req.captain);

        sendMessageToSocketId(ride.user.socketId, {
            event: 'ride-started',
            data: ride
        });

        return res.status(200).json(ride);
    } catch (error) {
        console.error('Error starting ride:', error);
        return res.status(500).json({ message: 'Failed to start ride' });
    }
}

module.exports.endRide = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { rideId } = req.query;

    try {
        const ride = await rideService.endRide(rideId, req.captain);

        sendMessageToSocketId(ride.user.socketId, {
            event: 'ride-ended',
            data: ride
        });

        return res.status(200).json(ride);
    } catch (error) {
        console.error('Error ending ride:', error);
        return res.status(500).json({ message: 'Failed to end ride' });
    }
}

module.exports.makePayment = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    const { rideId } = req.query;

    try {
        const ride = await rideService.makePayment(rideId, req.user);
        sendMessageToSocketId(ride.captain.socketId, {
            event: 'payment-confirmed',
            data: {
                rideId: ride._id,
                user: req.user,
                amount: ride.fare,
                status: 'paid',
            }
        });

        console.log("📤 Sending to captain socket:", ride.captain.socketId, {
            event: 'payment-confirmed',
            data: {
                rideId: ride._id,
                user: req.user,
                amount: ride.fare,
                status: 'paid',
            }
        });

        return res.status(200).json(ride);
    } catch (error) {
        console.error('Error ending ride:', error);
        return res.status(500).json({ message: 'Failed to end ride' });
    }

}

