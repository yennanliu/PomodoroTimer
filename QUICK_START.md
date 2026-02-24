# Quick Start - Play Store Release

## Current Status
✓ App package configured: `com.yen.pomodoro_time`
✓ Version: 1.0.0 (versionCode: 1)
✓ Signing configuration ready
✓ App name: "Pomodoro Timer"

---

## Option 1: Automated Setup (Recommended)

Run the setup script that will guide you through everything:

```bash
./setup-release.sh
```

This script will:
1. Create your app signing keystore
2. Generate key.properties configuration
3. Build the release AAB
4. Show next steps

---

## Option 2: Manual Setup

### Step 1: Create Keystore (one-time)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Remember your passwords!** You'll need them to sign future updates.

### Step 2: Create key.properties

Create `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=/Users/YOUR_USERNAME/upload-keystore.jks
```

### Step 3: Build Release AAB

```bash
flutter clean
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Step 4: Test Release Build

```bash
flutter build apk --release
flutter install --release
```

---

## Play Store Submission

Once your AAB is built:

1. **Create Google Play Console account** ($25 one-time fee)
   - Visit: https://play.google.com/console/signup

2. **Create new app listing**
   - App name: Pomodoro Timer
   - Package: com.yen.pomodoro_time
   - Category: Productivity

3. **Upload release AAB**
   - File: `build/app/outputs/bundle/release/app-release.aab`

4. **Complete store listing** (see PLAY_STORE_GUIDE.md for details):
   - App icon (512x512)
   - Feature graphic (1024x500)
   - Screenshots (2-8 images)
   - Description
   - Content rating
   - Privacy policy (if applicable)

5. **Submit for review** (1-7 days)

---

## Assets Needed for Play Store

### Required Graphics

1. **App Icon**: 512x512 PNG
   - Current icon location: `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - You may want to create a high-res version

2. **Feature Graphic**: 1024x500 PNG
   - Showcase your app name and timer feature
   - Use soft red color scheme

3. **Screenshots**: Minimum 2, up to 8
   - Phone: 1080x1920 or 1440x2560
   - Capture:
     - Timer at 25:00
     - Timer running
     - Completion state

### App Description (Draft)

**Short** (80 chars):
```
Simple, elegant Pomodoro Timer to boost your productivity and focus.
```

**Long**:
```
🍅 Pomodoro Timer - Focus & Productivity

Stay focused and productive with this beautifully designed Pomodoro Timer app. Based on the proven Pomodoro Technique, this timer helps you work in focused 25-minute intervals for maximum efficiency.

✨ Features:
• 25-minute countdown timer with clear digital display
• Simple Start, Pause, and Reset controls
• Automatic reset when timer completes
• Clean, minimalist Material Design interface
• Smooth animations and elegant UI
• No ads, no tracking, no distractions

Perfect for students, professionals, and anyone looking to improve their focus and time management.
```

---

## Troubleshooting

### Build fails with signing error
- Verify `android/key.properties` exists and has correct paths
- Check keystore password is correct
- Ensure keystore file exists at specified path

### "Could not find or load main class"
- Run `flutter clean` and rebuild

### Version code error on upload
- Increment `versionCode` in `android/app/build.gradle.kts`
- Each Play Store release needs a higher version code

---

## Important Notes

🔐 **Security**:
- `key.properties` is in `.gitignore` (never commit it!)
- Backup your keystore file (`upload-keystore.jks`) securely
- Store passwords in a password manager

📱 **Version Management**:
- Current: v1.0.0 (versionCode 1)
- For updates: increment versionCode and versionName in `build.gradle.kts`

📝 **Documentation**:
- Full guide: `PLAY_STORE_GUIDE.md`
- This quick start: `QUICK_START.md`

---

## Next Steps

1. ✅ Run `./setup-release.sh` to create keystore and build AAB
2. ⬜ Create Play Store Console account
3. ⬜ Prepare store graphics (icon, screenshots, feature graphic)
4. ⬜ Upload AAB to Play Store
5. ⬜ Complete store listing
6. ⬜ Submit for review

Good luck! 🚀
