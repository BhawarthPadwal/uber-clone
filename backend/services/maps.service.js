const captainModel = require('../models/captain.model');

module.exports.getAddressCoordinates = async (address) => {
    const axios = require('axios');
    const apiKey = process.env.GOOGLE_MAPS_API_KEY;
    const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${apiKey}`;
    try {
        const response = await axios.get(url);
        if (response.data.status === 'OK') {
            const location = response.data.results[0].geometry.location;
            return {
                ltd: location.lat,
                lng: location.lng
            };
        } else {
            throw new Error(`Geocoding error: ${response.data.status}`);
        }
    } catch (error) {
        console.error('Error fetching coordinates:', error);
        throw new Error('Failed to fetch address coordinates');
    }
}

module.exports.getDistanceAndTime = async (origin, destination) => {
    if (!origin || !destination) {
        throw new Error('Origin and destination are required');
    }
    const axios = require('axios');
    const apiKey = process.env.GOOGLE_MAPS_API_KEY;
    const url = `https://maps.googleapis.com/maps/api/distancematrix/json?origins=${encodeURIComponent(origin)}&destinations=${encodeURIComponent(destination)}&key=${apiKey}`;
    try {
        const response = await axios.get(url);
        if (response.data.status === 'OK') {
            if (response.data.rows[0].elements[0].status === 'ZERO_RESULTS') {
                throw new Error('No route found between the specified locations');
            }
            return response.data.rows[0].elements[0];
        }
    } catch (error) {
        console.error('Error fetching distance and time:', error);
        throw new Error('Failed to fetch distance and time');
    }

}

module.exports.getRoutes = async (origin, destination) => {
    if (!origin || !destination) {
        throw new Error('Origin and destination are required');
    }

    const axios = require('axios');
    const apiKey = process.env.GOOGLE_MAPS_API_KEY;
    const url = `https://maps.googleapis.com/maps/api/directions/json?origin=${encodeURIComponent(origin)}&destination=${encodeURIComponent(destination)}&key=${apiKey}`;

    try {
        const response = await axios.get(url);

        if (response.data.status === 'OK') {
            const route = response.data.routes[0];
            return {
                polyline: route.overview_polyline.points,
                bounds: route.bounds,
                legs: route.legs,
            };
        } else {
            throw new Error(`Directions API error: ${response.data.status}`);
        }
    } catch (error) {
        console.error('Error fetching polyline route:', error.message);
        throw new Error('Failed to fetch polyline route');
    }
};

module.exports.getSuggestions = async (input) => {
    if (!input) {
        throw new Error('Input is required');
    }

    const apiKey = process.env.GOOGLE_MAPS_API_KEY;
    const url = `https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${encodeURIComponent(input)}&key=${apiKey}`;
    try {
        const axios = require('axios');
        const response = await axios.get(url);
        if (response.data.status === 'OK') {
            return response.data.predictions;
        } else {
            throw new Error(`Autocomplete error: ${response.data.status}`);
        }
    } catch (error) {
        console.error('Error fetching suggestions:', error);
        throw new Error('Failed to fetch suggestions');
    }
}

module.exports.getCaptainsInTheRadius = async (ltd, lng, radius) => {
    const captains = await captainModel.find({
        location: {
            $geoWithin: {
                $centerSphere: [[ltd, lng], radius / 6378.1] // radius in kilometers
            }
        }
    }, 'name vehicleType location socketId'); // Only return necessary fields    
    return captains;
}