# User Registration Endpoint Documentation

## POST `/users/register`

### Description
Registers a new user in the system. On successful registration, returns a JWT authentication token and the created user object.

---

### Request Body

Send a JSON object with the following structure:

```json
{
  "fullname": {
    "firstname": "John",
    "lastname": "Doe"
  },
  "email": "john.doe@example.com",
  "password": "yourpassword"
}
```

#### Field Requirements

- `fullname.firstname`: **string**, required, minimum 3 characters
- `fullname.lastname`: **string**, optional
- `email`: **string**, required, must be a valid email format
- `password`: **string**, required, minimum 6 characters

---

### Status Codes

- **201 Created**: User registered successfully
- **400 Bad Request**: Validation failed (returns details in `errors` array)
- **500 Internal Server Error**: Server error

---

### Example Successful Response

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "60f7c2b5e1d3c2a5b8e4d123",
    "fullname": {
      "firstname": "John",
      "lastname": "Doe"
    },
    "email": "john.doe@example.com",
    "socketId": null
  }
}
```

---

### Example Error Response (Validation Error)

```json
{
  "errors": [
    {
      "msg": "Invalid email format",
      "param": "email",
      "location": "body"
    }
  ]
}
```

---

# User Login Endpoint Documentation

## POST `/users/login`

### Description
Authenticates a user with email and password. Returns a JWT authentication token and the user object (without password) if credentials are valid.

---

### Request Body

Send a JSON object with the following structure:

```json
{
  "email": "john.doe@example.com",
  "password": "yourpassword"
}
```

#### Field Requirements

- `email`: **string**, required, must be a valid email format
- `password`: **string**, required, minimum 6 characters

---

### Status Codes

- **200 OK**: Login successful
- **400 Bad Request**: Validation failed (returns details in `errors` array)
- **401 Unauthorized**: Invalid email or password

---

### Example Successful Response

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "60f7c2b5e1d3c2a5b8e4d123",
    "fullname": {
      "firstname": "John",
      "lastname": "Doe"
    },
    "email": "john.doe@example.com",
    "socketId": null
  }
}
```

---

### Example Error Response (Invalid Credentials)

```json
{
  "message": "Invalid email or password"
}
```

---

### Example Error Response (Validation Error)

```json
{
  "errors": [
    {
      "msg": "Invalid email format",
      "param": "email",
      "location": "body"
    }
  ]
}
```

---

# User Profile Endpoint Documentation

## GET `/users/profile`

### Description
Returns the authenticated user's profile information. Requires a valid JWT token to be sent in the `Authorization` header as a Bearer token or as a `token` cookie.

---

### Request Headers

- `Authorization: Bearer <JWT_TOKEN>`  
  or  
- Cookie: `token=<JWT_TOKEN>`

---

### Status Codes

- **200 OK**: Returns the user profile
- **401 Unauthorized**: Token missing or invalid
- **400 Bad Request**: User not found in request

---

### Example Successful Response

```json
{
  "_id": "60f7c2b5e1d3c2a5b8e4d123",
  "fullname": {
    "firstname": "John",
    "lastname": "Doe"
  },
  "email": "john.doe@example.com",
  "socketId": null
}
```

---

### Example Error Response (Unauthorized)

```json
{
  "message": "No token, authorization denied"
}
```

---

### Example Error Response (User Not Found)

```json
{
  "message": "User not found in request"
}
```

---

# User Logout Endpoint Documentation

## GET `/users/logout`

### Description
Logs out the authenticated user by clearing the authentication token cookie and blacklisting the token. Requires a valid JWT token to be sent in the `Authorization` header as a Bearer token or as a `token` cookie.

---

### Request Headers

- `Authorization: Bearer <JWT_TOKEN>`  
  or  
- Cookie: `token=<JWT_TOKEN>`

---

### Status Codes

- **200 OK**: Logout successful
- **401 Unauthorized**: Token missing or invalid

---

### Example Successful Response

```json
{
  "message": "Logged out successfully"
}
```

---

### Example Error Response (Unauthorized)

```json
{
  "message": "No token, authorization denied"
}
```

---

# Captain Registration Endpoint Documentation

## POST `/captains/register`

### Description
Registers a new captain (driver) in the system with vehicle details. On successful registration, returns the created captain object.

---

### Request Body

Send a JSON object with the following structure:

```json
{
  "fullname": {
    "firstname": "Jane",
    "lastname": "Smith"
  },
  "email": "jane.smith@example.com",
  "password": "yourpassword",
  "vehicle": {
    "color": "Red",
    "plate": "ABC123",
    "capacity": 4,
    "vehicleType": "car"
  }
}
```

#### Field Requirements

- `fullname.firstname`: **string**, required, minimum 3 characters
- `fullname.lastname`: **string**, optional
- `email`: **string**, required, must be a valid email format
- `password`: **string**, required, minimum 6 characters
- `vehicle.color`: **string**, required, minimum 3 characters
- `vehicle.plate`: **string**, required, minimum 3 characters
- `vehicle.capacity`: **integer**, required, minimum 1
- `vehicle.vehicleType`: **string**, required, one of `"car"`, `"motorcycle"`, `"auto"`

---

### Status Codes

- **201 Created**: Captain registered successfully
- **400 Bad Request**: Validation failed (returns details in `errors` array)
- **500 Internal Server Error**: Server error

---

### Example Successful Response

```json
{
  "_id": "60f7c2b5e1d3c2a5b8e4d456",
  "fullname": {
    "firstname": "Jane",
    "lastname": "Smith"
  },
  "email": "jane.smith@example.com",
  "socketId": null,
  "status": "inactive",
  "vehicle": {
    "color": "Red",
    "plate": "ABC123",
    "capacity": 4,
    "vehicleType": "car"
  },
  "location": {
    "lat": null,
    "lng": null
  }
}
```

---

### Example Error Response (Validation Error)

```json
{
  "errors": [
    {
      "msg": "Color must be at least 3 characters long",
      "param": "vehicle.color",
      "location": "body"
    }
  ]
}
```

---

# Captain Login Endpoint Documentation

## POST `/captains/login`

### Description
Authenticates a captain with email and password. Returns a JWT authentication token and the captain object (without password) if credentials are valid.

---

### Request Body

Send a JSON object with the following structure:

```json
{
  "email": "jane.smith@example.com",
  "password": "yourpassword"
}
```

#### Field Requirements

- `email`: **string**, required, must be a valid email format
- `password`: **string**, required, minimum 6 characters

---

### Status Codes

- **200 OK**: Login successful
- **400 Bad Request**: Validation failed (returns details in `errors` array)
- **401 Unauthorized**: Invalid email or password

---

### Example Successful Response

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "captain": {
    "_id": "60f7c2b5e1d3c2a5b8e4d456",
    "fullname": {
      "firstname": "Jane",
      "lastname": "Smith"
    },
    "email": "jane.smith@example.com",
    "socketId": null,
    "status": "inactive",
    "vehicle": {
      "color": "Red",
      "plate": "ABC123",
      "capacity": 4,
      "vehicleType": "car"
    },
    "location": {
      "lat": null,
      "lng": null
    }
  }
}
```

---

### Example Error Response (Invalid Credentials)

```json
{
  "message": "Invalid email or password"
}
```

---

### Example Error Response (Validation Error)

```json
{
  "errors": [
    {
      "msg": "Invalid email format",
      "param": "email",
      "location": "body"
    }
  ]
}
```

---

# Captain Profile Endpoint Documentation

## GET `/captains/profile`

### Description
Returns the authenticated captain's profile information. Requires a valid JWT token to be sent in the `Authorization` header as a Bearer token or as a `token` cookie.

---

### Request Headers

- `Authorization: Bearer <JWT_TOKEN>`  
  or  
- Cookie: `token=<JWT_TOKEN>`

---

### Status Codes

- **200 OK**: Returns the captain profile
- **401 Unauthorized**: Token missing or invalid
- **400 Bad Request**: Captain not found in request

---

### Example Successful Response

```json
{
  "_id": "60f7c2b5e1d3c2a5b8e4d456",
  "fullname": {
    "firstname": "Jane",
    "lastname": "Smith"
  },
  "email": "jane.smith@example.com",
  "socketId": null,
  "status": "inactive",
  "vehicle": {
    "color": "Red",
    "plate": "ABC123",
    "capacity": 4,
    "vehicleType": "car"
  },
  "location": {
    "lat": null,
    "lng": null
  }
}
```

---

### Example Error Response (Unauthorized)

```json
{
  "message": "Unauthorized"
}
```

---

### Example Error Response (Captain Not Found)

```json
{
  "message": "Captain not found in request"
}
```

---

# Captain Logout Endpoint Documentation

## GET `/captains/logout`

### Description
Logs out the authenticated captain by clearing the authentication token cookie and blacklisting the token. Requires a valid JWT token to be sent in the `Authorization` header as a Bearer token or as a `token` cookie.

---

### Request Headers

- `Authorization: Bearer <JWT_TOKEN>`  
  or  
- Cookie: `token=<JWT_TOKEN>`

---

### Status Codes

- **200 OK**: Logout successful
- **401 Unauthorized**: Token missing or invalid

---

### Example Successful Response

```json
{
  "message": "Logged out successfully"
}
```

---

### Example Error Response (Unauthorized)

```json
{
  "message": "Unauthorized"
}
```

