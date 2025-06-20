const express = require('express');
const router = express.Router();
const rideController = require('../controllers/ride.controller');
const { body, query } = require('express-validator');
const authMiddleware = require('../middlewares/auth.middleware');

router.post('/create', 
    authMiddleware.authUser, // Ensure the user is authenticated
    body('pickup').isString().isLength({min: 3}).withMessage('Invalid pickup location'),
    body('destination').isString().isLength({min: 3}).withMessage('Invalid destination location'),
    body('vehicleType').isIn(['auto', 'car', 'motorcycle']).withMessage('Invalid vehicle type'),
    rideController.createRide
);

router.get('/fare', 
    authMiddleware.authUser, // Ensure the user is authenticated
    query('pickup').isString().isLength({min: 3}).withMessage('Invalid pickup location'),
    query('destination').isString().isLength({min: 3}).withMessage('Invalid destination location'),
    rideController.getFare
);

router.get('/confirm',
    authMiddleware.authCaptain, // Ensure the user is authenticated
    query('rideId').isMongoId().withMessage('Invalid ride ID'),
    rideController.confirmRide
);

router.get('/start-ride',
    authMiddleware.authCaptain, // Ensure the user is authenticated
    query('rideId').isMongoId().withMessage('Invalid ride ID'),
    query('otp').isString().isLength({min: 6, max: 6}).withMessage('Invalid OTP'),
    rideController.startRide
);

router.get('/end-ride',
    authMiddleware.authCaptain, // Ensure the user is authenticated
    query('rideId').isMongoId().withMessage('Invalid ride ID'),
    rideController.endRide
);

module.exports = router;