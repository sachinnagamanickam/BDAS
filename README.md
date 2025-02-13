# Biometric Device Authentication System

## Project Overview
The Biometric Device Authentication System is a secure application that manages trusted devices for users. It allows users to:
- **Add a trusted device** (with a specific expiration token).
- **Validate a device** (to check if the token is valid and the device is trusted).
- **Perform biometric authentication** before allowing any operation (add or validate).

### System Components
The system is divided into three components:
1. **Frontend**: User interface for interacting with the system.
2. **Backend**: Handles device management logic and integrates with the database.
3. **Biometric Server**: Handles biometric authentication using the user's device.

---

## System Architecture

### Workflow
1. **Frontend**:
   - User interacts with forms to add or validate a device.
   - Biometric authentication is performed before any operation.

2. **Biometric Server**:
   - Prompts the user for biometric authentication using Face ID, Touch ID, or other supported methods.
   - Returns the result of the authentication (success or failure) to the frontend.

3. **Backend**:
   - Validates requests to add or validate devices.
   - Stores and retrieves trusted device data from the SQLite database.
   - Enforces expiration logic for device tokens.

---

## Directory Structure
```plaintext
email-submission-project/
├── frontend/                # Frontend application
│   └── index.html           # Main HTML file
│
├── backend/                 # Backend Node.js application
│   ├── server.js            # Main backend server code
│   ├── package.json         # Node.js dependencies
│   └── auth_data.db         # SQLite database for storing trusted devices
│
├── biometric-server/        # Biometric authentication server
│   ├── Sources/             # Vapor application source code
│   │   └── BiometricAuth/   # Main Vapor app module
│   │       └── main.swift   # Entry point for Vapor server
│   └── Package.swift        # Swift package manager file
│
└── README.md                # Documentation for the project
```

---

## Frontend
### Technologies
- **HTML**: For the user interface.
- **JavaScript**: For managing user interactions and making API requests.

### Features
1. **Add Trusted Device**:
   - Users enter their `userId`, `deviceId`, and token expiration timestamp (`expires`).
   - Biometric authentication is required before sending the data to the backend.

2. **Validate Device**:
   - Users validate if a device is trusted and if its token is still valid.
   - Biometric authentication is required before making the validation request.

3. **Error Handling**:
   - Handles failed biometric authentication or invalid inputs with clear error messages.

---

## Biometric Server
### Technologies
- **Vapor Framework**: Swift-based web framework.
- **Local Authentication (LAContext)**: Provides biometric authentication using Touch ID, Face ID, or similar.

### Endpoints
- **GET /authenticate**:
  - Prompts the user for biometric authentication.
  - Returns:
    - `"success"`: If authentication is successful.
    - `"failure"`: If authentication fails.

### Setup
1. **Install Dependencies**:
   Ensure you have Swift and Vapor installed.
   ```bash
   swift build
   ```

2. **Start the Server**:
   ```bash
   swift run
   ```

3. **Access**:
   The server runs on [http://127.0.0.1:8080](http://127.0.0.1:8080).

---

## Backend
### Technologies
- **Node.js**: For backend logic.
- **SQLite**: Lightweight database for storing device data.
- **CORS & Body-Parser Middleware**: To handle cross-origin requests and JSON payloads.

### Endpoints
1. **POST /add-device**:
   - Adds or updates a trusted device for a user.
   - **Request Body**:
     ```json
     {
       "userId": "user123",
       "deviceId": "device456",
       "expires": 1739404050000
     }
     ```
   - **Response**:
     ```json
     {
       "message": "Device added or updated successfully"
     }
     ```

2. **POST /validate**:
   - Validates whether the `deviceId` is trusted and if the token is still valid.
   - **Request Body**:
     ```json
     {
       "userId": "user123",
       "deviceId": "device456"
     }
     ```
   - **Response**:
     - If valid:
       ```json
       {
         "message": "Access granted"
       }
       ```
     - If the device is not trusted:
       ```json
       {
         "message": "Access denied: device not trusted"
       }
       ```
     - If the token is expired:
       ```json
       {
         "message": "Access denied: token expired"
       }
       ```

---

## Database
### Schema
```sql
CREATE TABLE trusted_devices (
  userId TEXT NOT NULL,
  deviceId TEXT NOT NULL,
  expires INTEGER NOT NULL,
  PRIMARY KEY (userId, deviceId)
);
```

### Database Operations
1. **Add or Update Device**:
   - Adds or updates the trusted device with the provided expiration timestamp.
2. **Validate Device**:
   - Checks if the `deviceId` exists for the `userId` and validates the token expiration.

---

## Example Workflow
1. **Add a Trusted Device**:
   - User fills out the form in the frontend.
   - Users are prompted for biometric authentication.
   - If successful, the backend adds the device to the database.

2. **Validate a Device**:
   - User enters the details of the device to validate.
   - Users are prompted for biometric authentication.
   - If successful, the backend checks if the device is trusted and the token is valid.

---

## Setup Instructions
1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd BDAS/email_submission_project/
   ```

2. **Run the Biometric Server**
   ```bash
   cd biometric-auth/
   swift build
   swift run
   ```

3. **Run the Backend**
   ```bash
   cd ../backend/
   npm install
   node server.js
   ```

4. **Open the Frontend**
   - Open `frontend/index.html` in your browser.

---

## License
This project is licensed under the MIT License.
