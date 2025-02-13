const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());
app.use(cors()); // Enable CORS for all routes

// Initialize SQLite Database
const db = new sqlite3.Database('auth_data.db');

// Create a table for trusted devices if it doesn't exist
db.serialize(() => {
  db.run(
    `
    CREATE TABLE IF NOT EXISTS trusted_devices (
      userId TEXT,
      deviceId TEXT,
      expires INTEGER,
      PRIMARY KEY (userId, deviceId)
    )
  `,
    (err) => {
      if (err) {
        console.error('Error creating table:', err);
      } else {
        console.log('Trusted devices table initialized.');
      }
    }
  );
});

// Endpoint to validate a device
app.post('/validate', (req, res) => {
  const { userId, deviceId } = req.body; // Removed "expires"

  if (!userId || !deviceId) {
    console.warn('Missing parameters in the request.');
    return res.status(400).json({ message: 'userId and deviceId are required' });
  }

  console.log(`Validating device for userId: ${userId}, deviceId: ${deviceId}`);

  db.get(
    'SELECT expires FROM trusted_devices WHERE userId = ? AND deviceId = ?',
    [userId, deviceId],
    (err, row) => {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ message: 'Internal server error' });
      }

      if (!row) {
        console.warn('Device is not trusted.');
        return res.status(403).json({ message: 'Access denied: device not trusted' });
      }

      console.log('Access granted.');
      return res.json({ message: 'Access granted' });
    }
  );
});

// Endpoint to add or update a trusted device
app.post('/add-device', (req, res) => {
  const { userId, deviceId, expires } = req.body;

  if (!userId || !deviceId || !expires) {
    console.warn('Missing parameters in the request.');
    return res.status(400).json({ message: 'userId, deviceId, and expires are required' });
  }

  console.log(`Adding or updating device for userId: ${userId}, deviceId: ${deviceId}`);

  db.run(
    'INSERT OR REPLACE INTO trusted_devices (userId, deviceId, expires) VALUES (?, ?, ?)',
    [userId, deviceId, expires],
    (err) => {
      if (err) {
        console.error('Error inserting into database:', err);
        return res.status(500).json({ message: 'Internal server error' });
      }
      console.log('Device successfully added or updated.');
      return res.json({ message: 'Device added or updated successfully' });
    }
  );
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
