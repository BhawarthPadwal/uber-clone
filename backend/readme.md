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

### Notes

- The password is not returned in the response for security reasons.
- The `token` can be used for authenticated requests to other endpoints.

