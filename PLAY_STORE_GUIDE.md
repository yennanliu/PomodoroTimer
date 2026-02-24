# Google Play Store Publishing Guide - Pomodoro Timer

This guide walks you through publishing your Pomodoro Timer app to the Google Play Store.

---

## Prerequisites

### 1. Google Play Console Account
- **Cost**: $25 one-time registration fee
- **Sign up**: https://play.google.com/console/signup
- **Requirements**: Google account, payment method, developer identity verification

### 2. App Requirements Checklist
- [ ] App functionality working correctly
- [ ] App signing key created
- [ ] Release build generated (AAB format)
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (at least 2, up to 8)
- [ ] Privacy policy URL (required if app handles sensitive data)
- [ ] Content rating questionnaire completed

---

## Phase 1: Prepare Your App for Release

### Step 1.1: Create App Signing Key

The keystore is used to sign your app. **Keep this file secure - losing it means you cannot update your app!**

```bash
# Create a keystore (run once, save the file securely)
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# You'll be asked for:
# - Keystore password (remember this!)
# - Key password (remember this!)
# - Your name, organization, city, state, country
```

**Important**: Back up `~/upload-keystore.jks` to a secure location!

### Step 1.2: Configure Gradle for Signing

Create `android/key.properties`:

```properties
storePassword=<your-keystore-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-your-keystore>/upload-keystore.jks
```

**Security**: Add `key.properties` to `.gitignore` to avoid committing secrets!

### Step 1.3: Update App Configuration

Edit `android/app/build.gradle.kts`:

1. Add signing configuration (before `android` block):
```kotlin
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

2. Add signing configs inside `android` block:
```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### Step 1.4: Update App Metadata

Edit `android/app/build.gradle.kts`:

```kotlin
defaultConfig {
    applicationId = "com.yourcompany.pomodoro_timer"
    minSdk = 21  // Minimum Android version
    targetSdk = 35  // Latest Android version
    versionCode = 1  // Increment for each release
    versionName = "1.0.0"  // User-visible version
}
```

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="Pomodoro Timer"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
    <!-- ... -->
</application>
```

### Step 1.5: Review Permissions

Check `android/app/src/main/AndroidManifest.xml` - remove unnecessary permissions:
- Internet permission (only if needed for analytics/ads)
- Storage permissions (not needed for this app)

---

## Phase 2: Build Release Version

### Step 2.1: Build App Bundle (AAB)

Google Play requires AAB format (not APK):

```bash
# Clean and build release AAB
flutter clean
flutter build appbundle --release

# Output location:
# build/app/outputs/bundle/release/app-release.aab
```

### Step 2.2: Test Release Build

Before uploading, test the release build:

```bash
# Install release APK for testing
flutter build apk --release
flutter install --release
```

**Verify**:
- [ ] App launches correctly
- [ ] Timer functions work (Start, Pause, Reset)
- [ ] No crashes or errors
- [ ] UI looks correct on different screen sizes

---

## Phase 3: Prepare Store Assets

### Step 3.1: App Icon (Required)

**High-res icon**: 512x512 PNG, 32-bit, with alpha channel

Design requirements:
- No rounded corners (Google Play adds them)
- Full square with transparency if needed
- Represents your app clearly

### Step 3.2: Feature Graphic (Required)

**Size**: 1024x500 PNG

Design tips:
- Showcase app name and key feature
- Use your app's color scheme (soft red)
- Keep text minimal and readable

### Step 3.3: Screenshots (Required)

**Minimum**: 2 screenshots (up to 8 allowed)
**Recommended sizes**:
- Phone: 1080x1920 or 1440x2560
- Tablet: 1920x1200 or 2560x1600 (optional)

**What to capture**:
1. Timer at 25:00 (default state)
2. Timer running (showing countdown)
3. Timer completed state (with celebration message)

**How to capture from emulator**:
```bash
# Launch app on emulator
flutter run -d emulator-5554

# Use emulator's built-in screenshot tool (⌘+S on Mac)
# Or use Android Studio's Screenshot tool
```

### Step 3.4: App Description

**Short description** (80 characters max):
```
Simple, elegant Pomodoro Timer to boost your productivity and focus.
```

**Full description** (4000 characters max):
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

🎯 How It Works:
1. Start the timer to begin your 25-minute focus session
2. Work without distractions until the timer ends
3. Take a short break when the timer completes
4. Repeat to maintain consistent productivity

📱 Why This App?
• Lightweight and fast - no unnecessary features
• Beautiful, distraction-free interface
• Works offline - no internet required
• Completely free with no in-app purchases

Perfect for students, professionals, writers, developers, and anyone looking to improve their focus and time management.

Based on the Pomodoro Technique® developed by Francesco Cirillo.
```

### Step 3.5: Categorization & Tags

- **App category**: Productivity
- **Tags**: pomodoro, timer, productivity, focus, time management
- **Content rating**: Everyone

---

## Phase 4: Create Play Console Listing

### Step 4.1: Create New App

1. Go to https://play.google.com/console
2. Click "Create app"
3. Fill in:
   - **App name**: Pomodoro Timer
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free

### Step 4.2: Complete Store Listing

Navigate to "Store presence" → "Main store listing":

1. **App name**: Pomodoro Timer
2. **Short description**: (paste from Step 3.4)
3. **Full description**: (paste from Step 3.4)
4. **App icon**: Upload 512x512 PNG
5. **Feature graphic**: Upload 1024x500 PNG
6. **Phone screenshots**: Upload 2-8 screenshots
7. **App category**: Productivity
8. **Contact details**: Your email
9. **Privacy policy**: URL (optional, but recommended)

### Step 4.3: Content Rating

1. Navigate to "Policy" → "App content" → "Content rating"
2. Complete questionnaire:
   - Violence: None
   - Sexual content: None
   - Profanity: None
   - Controlled substances: None
   - Interactive elements: None
3. Submit and get rating

### Step 4.4: Target Audience & Content

1. **Target age**: Everyone (suitable for all ages)
2. **News app**: No
3. **COVID-19 contact tracing or status**: No
4. **Data safety**: Complete the questionnaire
   - Data collection: None (app doesn't collect user data)
   - Data sharing: None
   - Security practices: Data encrypted in transit

### Step 4.5: Select Countries

1. Navigate to "Production" → "Countries/regions"
2. Select "Add countries/regions"
3. Choose "Available in all countries" or select specific countries

---

## Phase 5: Release & Publish

### Step 5.1: Create Release

1. Navigate to "Production" → "Releases"
2. Click "Create new release"
3. Upload `app-release.aab` from `build/app/outputs/bundle/release/`
4. Add release notes:

```
Initial release (v1.0.0)

Features:
• 25-minute Pomodoro timer
• Start, Pause, and Reset controls
• Auto-reset on completion
• Clean Material Design interface
• Smooth animations
```

### Step 5.2: Review & Rollout

1. Review all sections - ensure all required items have green checkmarks
2. Click "Start rollout to Production"
3. Confirm rollout

**Timeline**:
- Initial review: 1-7 days
- Status: Check "Publishing overview" for updates
- Approval: You'll receive email notification

---

## Phase 6: Post-Launch

### Step 6.1: Monitor Release

- Check for crashes in Play Console → "Quality" → "Android vitals"
- Monitor ratings and reviews
- Respond to user feedback

### Step 6.2: Future Updates

When releasing updates:

1. Increment version in `android/app/build.gradle.kts`:
   ```kotlin
   versionCode = 2  // Increment by 1
   versionName = "1.0.1"  // Semantic versioning
   ```

2. Build new AAB:
   ```bash
   flutter build appbundle --release
   ```

3. Create new release in Play Console with release notes

---

## Checklist Summary

**Before Submission**:
- [ ] Google Play Developer account created ($25)
- [ ] App signing keystore created and backed up
- [ ] Release AAB built and tested
- [ ] App icon (512x512) prepared
- [ ] Feature graphic (1024x500) prepared
- [ ] Screenshots (2-8) captured
- [ ] Store description written
- [ ] Content rating completed
- [ ] Data safety form completed

**After Submission**:
- [ ] Release submitted for review
- [ ] Monitoring Play Console for approval status
- [ ] Ready to respond to any Google feedback
- [ ] Marketing materials prepared (optional)

---

## Useful Links

- **Play Console**: https://play.google.com/console
- **Developer Policy**: https://play.google.com/about/developer-content-policy/
- **App Signing Help**: https://support.google.com/googleplay/android-developer/answer/9842756
- **Launch Checklist**: https://developer.android.com/distribute/best-practices/launch/launch-checklist

---

## Troubleshooting

### "App not signed" error
- Verify `key.properties` exists and has correct values
- Check keystore file path is correct
- Ensure signing config is added to `build.gradle.kts`

### "Version code must be greater than X"
- Increment `versionCode` in `build.gradle.kts`
- Each release needs a unique, higher version code

### "Missing required assets"
- Ensure all required graphics are uploaded
- Check file formats and dimensions match requirements
- Verify app icon has no transparency (or use adaptive icon)

### Review taking too long
- First submission typically takes 3-7 days
- Check for emails from Google Play team
- Respond promptly to any requests for information

---

**Good luck with your app launch! 🚀**
