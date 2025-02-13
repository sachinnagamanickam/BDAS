#!/bin/bash

# Define paths
BUILD_DIR=".build/debug"
EXECUTABLE="BiometricAuthServer"
DESTINATION="../backend/biometricAuth"

# Check if the executable exists
if [ -f "$BUILD_DIR/$EXECUTABLE" ]; then
    echo "Copying $EXECUTABLE to $DESTINATION"
    cp "$BUILD_DIR/$EXECUTABLE" "$DESTINATION"
    chmod +x "$DESTINATION" # Ensure the file is executable
    echo "Copy complete!"
else
    echo "Executable not found: $BUILD_DIR/$EXECUTABLE"
    exit 1
fi

