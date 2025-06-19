const userModel = require('../models/user.model');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const captainModel = require('../models/captain.model');

module.exports.authUser = async (req, res, next) => {
    //console.log('Authenticating user...');
    const token = req.cookies.token || req.headers.authorization?.split(' ')[1];
    if (!token) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    const isBlacklisted = await userModel.findOne({ token });
    if (isBlacklisted) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await userModel.findById(decoded._id);
        if (!user) {
            return res.status(401).json({ message: 'Unauthorized' });
        }
        req.user = user; // Attach user to request object
        return next(); // Proceed to the next middleware or route handler
    } catch (error) {
        console.error('Authentication error:', error);
        return res.status(401).json({ message: 'Invalid token' });
    }
}

module.exports.authCaptain = async (req, res, next) => {
    //console.log('Authenticating captain...');
    const token = req.cookies.token || req.headers.authorization?.split(' ')[1];
    if (!token) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    const isBlacklisted = await captainModel.findOne({ token });
    if (isBlacklisted) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const captain = await captainModel.findById(decoded._id);
        if (!captain) {
            return res.status(401).json({ message: 'Unauthorized' });
        }
        req.captain = captain; // Attach captain to request object
        return next(); // Proceed to the next middleware or route handler
    } catch (error) {
        console.error('Authentication error:', error);
        return res.status(401).json({ message: 'Invalid token' });
    }
}