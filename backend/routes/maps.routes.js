const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/auth.middleware');
const mapsController = require('../controllers/maps.controller');
const { query } = require('express-validator');


router.get('/get-coordinates',
    query('address').isString().isLength({min: 3}),
    authMiddleware.authUser, mapsController.getCoordinates);

router.get('/get-distance-time',
    query('origin').isString().isLength({min: 3}),
    query('destination').isString().isLength({min: 3}),
    authMiddleware.authUser, mapsController.getDistanceAndTime);

router.get('/get-suggestions',
    query('input').isString().isLength({min: 3}),
    authMiddleware.authUser, mapsController.getSuggestions);

router.get('/get-routes',
    query('origin').isString().isLength({min: 3}),
    query('destination').isString().isLength({min: 3}),
    mapsController.getRoutes);

module.exports = router;