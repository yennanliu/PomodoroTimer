#!/bin/bash

# Play Store Release Setup Script for Pomodoro Timer
# This script helps you set up everything needed for Play Store release

echo "========================================="
echo "Pomodoro Timer - Play Store Setup"
echo "========================================="
echo ""

# Step 1: Check if keystore already exists
KEYSTORE_PATH="$HOME/upload-keystore.jks"
KEY_PROPERTIES="android/key.properties"

if [ -f "$KEYSTORE_PATH" ]; then
    echo "✓ Keystore already exists at: $KEYSTORE_PATH"
    echo ""
else
    echo "Step 1: Create App Signing Keystore"
    echo "-----------------------------------"
    echo "This creates a keystore file to sign your app for Play Store."
    echo "IMPORTANT: Save this file and passwords securely!"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to cancel..."

    # Generate keystore
    keytool -genkey -v -keystore "$KEYSTORE_PATH" \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias upload

    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Keystore created successfully!"
        echo "  Location: $KEYSTORE_PATH"
        echo ""
        echo "⚠️  BACKUP THIS FILE IMMEDIATELY!"
        echo "  Without it, you cannot update your app on Play Store."
        echo ""
    else
        echo ""
        echo "✗ Failed to create keystore."
        exit 1
    fi
fi

# Step 2: Create key.properties
echo "Step 2: Configure Signing Properties"
echo "-------------------------------------"

if [ -f "$KEY_PROPERTIES" ]; then
    echo "⚠️  key.properties already exists."
    read -p "Overwrite it? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping key.properties creation."
    else
        rm "$KEY_PROPERTIES"
    fi
fi

if [ ! -f "$KEY_PROPERTIES" ]; then
    echo "Enter your keystore password (or press Enter to skip):"
    read -s STORE_PASSWORD
    echo ""

    if [ ! -z "$STORE_PASSWORD" ]; then
        echo "Enter your key password (or press Enter to use same as keystore password):"
        read -s KEY_PASSWORD
        echo ""

        if [ -z "$KEY_PASSWORD" ]; then
            KEY_PASSWORD=$STORE_PASSWORD
        fi

        # Create key.properties
        cat > "$KEY_PROPERTIES" << EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=upload
storeFile=$KEYSTORE_PATH
EOF

        echo "✓ Created android/key.properties"
        echo ""
    else
        echo "Skipped key.properties creation. You can create it manually later."
        echo ""
    fi
fi

# Step 3: Build release AAB
echo "Step 3: Build Release AAB"
echo "-------------------------"
read -p "Build release AAB now? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleaning project..."
    flutter clean

    echo "Building release AAB..."
    flutter build appbundle --release

    if [ $? -eq 0 ]; then
        AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
        echo ""
        echo "========================================="
        echo "✓ Release AAB built successfully!"
        echo "========================================="
        echo ""
        echo "Location: $AAB_PATH"
        echo "Size: $(du -h $AAB_PATH | cut -f1)"
        echo ""
        echo "Next steps:"
        echo "1. Test the release build on an emulator/device"
        echo "2. Upload $AAB_PATH to Google Play Console"
        echo "3. Complete store listing and submit for review"
        echo ""
        echo "See PLAY_STORE_GUIDE.md for complete instructions."
        echo ""
    else
        echo ""
        echo "✗ Build failed. Please check the errors above."
        exit 1
    fi
else
    echo "Skipped build. You can build later with:"
    echo "  flutter build appbundle --release"
    echo ""
fi

echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Important files:"
echo "  - Keystore: $KEYSTORE_PATH"
echo "  - Config: $KEY_PROPERTIES"
echo "  - Guide: PLAY_STORE_GUIDE.md"
echo ""
echo "⚠️  Remember to backup your keystore file!"
echo ""
