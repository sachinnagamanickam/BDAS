Biometric Device Authentication System
Project Overview:
The Biometric Device Authentication System is a secure application that manages trusted devices for users. It allows users to:
Add a trusted device (with a specific expiration token).
Validate a device (to check if the token is valid and the device is trusted).
Perform biometric authentication before allowing any operation (add or validate).
The system is divided into three components:
Frontend: User interface for interacting with the system.
Backend: Handles device management logic and integrates with the database.
Biometric Server: Handles biometric authentication using the user's device.

System Architecture:
Workflow
Frontend:
User interacts with forms to add or validate a device.
Biometric authentication is performed before any operation.
Biometric Server:
Prompts the user for biometric authentication using Face ID, Touch ID, or other supported methods.
Returns the result of the authentication (success or failure) to the frontend.
Backend:
Validates requests to add or validate devices.
Stores and retrieves trusted device data from the SQLite database.
Enforces expiration logic for device tokens.


Directory Structure:


email-submission-project/
├── frontend/                # Frontend application
│   └── index.html           # Main HTML file
│
├── backend/                 # Backend Node.js application
│   ├── server.js            # Main backend server code
│   ├── package.json         # Node.js dependencies
│   └── auth_data.db         # SQLite database for storing trusted 
│
├── biometric-server/        # Biometric authentication server
│   ├── Sources/             # Vapor application source code
│   │   └── BiometricAuth/   # Main Vapor app module
│   │       └── main.swift   # Entry point for Vapor server
│   └── Package.swift        # Swift package manager file
│
└── README.md                # Documentation for the project


Frontend:
Technologies
HTML: For the user interface.
JavaScript: For managing user interactions and making API requests.
Features
Add Trusted Device:
Users enter their userId, deviceId, and token expiration timestamp (expires).
Biometric authentication is required before sending the data to the backend.
Validate Device:
Users validate if a device is trusted and if its token is still valid.
Biometric authentication is required before making the validation request.
Error Handling:
Handles failed biometric authentication or invalid inputs with clear error messages.


Biometric Server:
Technologies
Vapor Framework: Swift-based web framework.
Local Authentication (LAContext): Provides biometric authentication using Touch ID, Face ID, or similar.
Endpoints
GET /authenticate:
Prompts the user for biometric authentication.
Returns:
"success": If authentication is successful.
"failure": If authentication fails.
Setup
Install Dependencies:
Ensure you have Swift and Vapor installed.


swift build

Start the Server:

swift run
Access:
The server runs on http://127.0.0.1:8080.

Backend Technologies
Node.js: For backend logic.
SQLite: Lightweight database for storing device data.
CORS & Body-Parser Middleware: To handle cross-origin requests and JSON payloads.
Endpoints
POST /add-device:
Adds or updates a trusted device for a user.
Request Body:
{
  "userId": "user123",
  "deviceId": "device456",
  "expires": 1739404050000
}
Response:

{
  "message": "Device added or updated successfully"
}

POST /validate:
Validates whether the deviceId is trusted and if the token is still valid.
Request Body:
{
  "userId": "user123",
  "deviceId": "device456",
  "expires": 1739404050000
}

Response:
If valid:
{
  "message": "Access granted"
}

If the device is not trusted:
{
  "message": "Access denied: device not trusted"
}

If the token is expired:
{
  "message": "Access denied: token expired"
}


Database
Schema

CREATE TABLE trusted_devices (
  userId TEXT NOT NULL,
  deviceId TEXT NOT NULL,
  expires INTEGER NOT NULL,
  PRIMARY KEY (userId, deviceId)
);

Database Operations
Add or Update Device:
Adds or updates the trusted device with the provided expiration timestamp.
Validate Device:
Checks if the deviceId exists for the userId and validates the token expiration.


Example Workflow
Add a Trusted Device:
User fills out the form in the frontend.
Users are prompted for biometric authentication.
If successful, the backend adds the device to the database.
Validate a Device:
User enters the details of the device to validate.
Users are prompted for biometric authentication.
If successful, the backend checks if the device is trusted and the token is valid.

Setup Instructions
1. Clone the Repository
git clone <repository-url>
cd BDAS/email_submission_project/
2. Run the Biometric Server
cd biometric-auth:/
swift build
swift run

3. Run the Backend
cd ../backend/
npm install
node server.js

4. Open the Frontend
Open frontend/index.html in your browser.


