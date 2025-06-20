let ioInstance = null;
const { Server } = require('socket.io');
const userModel = require('./models/user.model'); // Adjust the path as necessary
const captainModel = require('./models/captain.model'); // Adjust the path as necessary


function initializeSocket(server) {
    ioInstance = new Server(server, {
        cors: {
            origin: "*",
            methods: ["GET", "POST"]
        }
    });

    ioInstance.on('connection', (socket) => {
        console.log(`Socket connected: ${socket.id}`);

        socket.on('join', async (data) => {
            const { userId, userType } = data;

            console.log(`User joined: ${userId}, Type: ${userType}`);
            
            if (userType === 'user') {
                await userModel.findByIdAndUpdate(userId, { socketId: socket.id });
            } else if (userType === 'captain') {
                await captainModel.findByIdAndUpdate(userId, { socketId: socket.id });
            }
        });

        socket.on('update-location-captain', async (data) => {
            const {userId, location} = data;
            if (!location || !location.ltd || !location.lng) {
                console.log('Invalid location data received');
                return;
            }
            await captainModel.findByIdAndUpdate(userId, { location: { ltd: location.ltd, lng: location.lng } });
        });

        socket.on('disconnect', () => {
            console.log(`Socket disconnected: ${socket.id}`, messageObject);
        });

        // You can add more event listeners here as needed
    });
}

function sendMessageToSocketId(socketId, messageObject) {
    if (ioInstance && ioInstance.sockets.sockets.get(socketId)) {
        ioInstance.to(socketId).emit(messageObject.event, messageObject.data);
    } else {
        console.log(`Socket with id ${socketId} not found or io not initialized.`);
    }
}

module.exports = {
    initializeSocket,
    sendMessageToSocketId
}
