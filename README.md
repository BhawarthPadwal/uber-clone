# Uber Clone

A full-stack ride-hailing application built with Flutter and Node.js that replicates core Uber functionalities.

## 🚀 Features

### User App
- Real-time location tracking
- Ride booking and fare estimation
- Multiple vehicle type options (Auto, Car, Motorcycle)
- OTP verification for ride start
- Real-time ride status updates
- Secure payment integration
- Ride history

### Captain (Driver) App
- Live ride requests
- Accept/Reject ride requests
- Real-time navigation
- OTP verification system
- Ride completion and payment status
- Earnings tracking

## 🛠️ Tech Stack

### Mobile App (Flutter)
- Flutter for cross-platform development
- BLoC pattern for state management
- Google Maps integration
- Socket.io for real-time communication
- Secure local storage
- REST API integration

### Backend (Node.js)
- Express.js framework
- MongoDB for database
- Socket.io for real-time updates
- JWT authentication
- RESTful API architecture
- Geospatial queries for nearby drivers
- Secure payment gateway integration

## 📱 Screenshots

[Add your app screenshots here]

## 🏗️ Project Structure

```
uber_clone/
├── backend/              # Node.js backend
│   ├── controllers/      # Request handlers
│   ├── models/          # Database models
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   └── middlewares/     # Custom middlewares
│
└── flutter_uber_clone_app/  # Flutter application
    ├── lib/
    │   ├── features/    # Feature-based modules
    │   ├── services/    # API and third-party services
    │   ├── utils/       # Utility functions
    │   └── config/      # App configuration
    ├── assets/          # Images and other assets
    └── test/            # Test files
```

## 🚦 Getting Started

### Prerequisites
- Flutter SDK
- Node.js
- MongoDB
- Google Maps API key
- Socket.io

### Installation

1. Clone the repository
```bash
git clone https://github.com/BhawarthPadwal/uber-clone.git
cd uber-clone
```

2. Backend Setup
```bash
cd backend
npm install
# Create .env file with required environment variables
npm start
```

3. Flutter App Setup
```bash
cd flutter_uber_clone_app
flutter pub get
# Add your Google Maps API key in AndroidManifest.xml and AppDelegate.swift
flutter run
```

### Environment Variables

Backend (.env)
```
PORT=3000
MONGODB_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
GOOGLE_MAPS_API_KEY=your_api_key
```

Flutter App (.env)
```
BASE_URL=your_backend_url
GOOGLE_MAPS_API_KEY=your_api_key
```

## 🔒 Security Features

- JWT based authentication
- Secure password hashing
- API request validation
- Socket connection authentication
- Secure local storage
- Rate limiting

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Bhawarthsingh Padwal**
- GitHub: [@BhawarthPadwal](https://github.com/BhawarthPadwal)
- LinkedIn: [Bhawarth Padwal](https://www.linkedin.com/in/bhawarth-padwal?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app)

## 🙏 Acknowledgments

- Uber for inspiration
- Google Maps Platform
- Flutter and Node.js communities
- Socket.io team

---
⭐ Star this repository if you find it helpful!
