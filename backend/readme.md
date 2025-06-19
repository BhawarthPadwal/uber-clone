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

