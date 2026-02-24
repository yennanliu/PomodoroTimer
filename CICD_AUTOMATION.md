# CI/CD Automation for Play Store Publishing

## What Can Be Automated?

### ✅ Fully Automatable
1. **Building AAB/APK** - GitHub Actions can build release bundles
2. **Uploading to Play Store** - API can upload AAB files
3. **Submitting for review** - API can promote releases
4. **Version management** - Automated version bumping
5. **Release notes** - Generated from commit messages

### ⚠️ Must Be Done Manually (At Least Once)
1. **Initial Play Console setup** - Create app, first-time configuration
2. **Store listing creation** - Screenshots, descriptions, graphics
3. **First release** - Must manually submit first version
4. **Service account setup** - Create API credentials in Google Cloud

### 🔄 Can Be Updated Via Automation
- AAB uploads (after first manual release)
- Release notes
- Version codes/names
- Staged rollouts
- Promoting releases between tracks (internal → alpha → beta → production)

---

## Automation Strategy

### Phase 1: Manual Setup (One-Time)
1. Create Google Play Console account
2. Create app and complete initial store listing
3. Manually upload first version (v1.0.0)
4. Set up Google Cloud service account
5. Configure GitHub secrets

### Phase 2: Automated Updates (Ongoing)
1. Push code to GitHub
2. GitHub Actions builds AAB
3. Automatically uploads to Play Store (internal/alpha/beta track)
4. Manually promote to production when ready

---

## Implementation Guide

### Step 1: Google Cloud Service Account Setup

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com/

2. **Select/Create Project**
   - Select the project linked to your Play Console
   - Or create new: "PomodoroTimer-PlayStore"

3. **Enable Google Play Android Developer API**
   ```
   https://console.cloud.google.com/apis/library/androidpublisher.googleapis.com
   ```
   - Click "Enable"

4. **Create Service Account**
   - Navigate to: IAM & Admin → Service Accounts
   - Click "Create Service Account"
   - Name: `github-actions-play-store`
   - Click "Create and Continue"
   - Skip role assignment (we'll do it in Play Console)
   - Click "Done"

5. **Create JSON Key**
   - Click on the service account
   - Go to "Keys" tab
   - Click "Add Key" → "Create new key"
   - Choose "JSON"
   - **Save the downloaded JSON file securely!**

6. **Grant Access in Play Console**
   - Go to Play Console: https://play.google.com/console
   - Navigate to: Settings → API access
   - Link your Google Cloud project (if not already linked)
   - Find your service account in the list
   - Click "Grant access"
   - Permissions needed:
     - ✓ View app information and download bulk reports (read-only)
     - ✓ Manage releases (create and edit releases)
     - ✓ Manage testing tracks
   - Click "Invite user" and "Send invite"

---

### Step 2: GitHub Repository Setup

#### Add GitHub Secrets

Go to your repository: Settings → Secrets and variables → Actions

Add these secrets:

1. **PLAYSTORE_SERVICE_ACCOUNT_JSON**
   - Content: Entire JSON file from Step 1.5
   - Click "New repository secret"
   - Name: `PLAYSTORE_SERVICE_ACCOUNT_JSON`
   - Value: Paste the entire JSON content

2. **KEYSTORE_BASE64**
   - Your keystore file encoded in base64
   ```bash
   base64 -i ~/upload-keystore.jks | pbcopy
   ```
   - Paste the output as secret value

3. **KEYSTORE_PASSWORD**
   - Your keystore password

4. **KEY_PASSWORD**
   - Your key password

5. **KEY_ALIAS**
   - Usually: `upload`

---

### Step 3: GitHub Actions Workflow

I'll create two workflows:
1. **PR Build** - Build and test on pull requests
2. **Play Store Deploy** - Build and deploy to Play Store on release tags

---

## Workflow Options

### Option A: Deploy to Internal Track (Safest)
- Automatically deploy to internal testing track
- Manually promote to production in Play Console

### Option B: Deploy to Beta Track
- Automatically deploy to beta track
- Good for testing with external users
- Manually promote to production

### Option C: Full Automation (Risky)
- Automatically deploy to production
- No manual review step
- Only recommended for mature apps with good testing

**Recommendation**: Start with Option A (Internal Track)

---

## Alternative: Fastlane (More Features)

Fastlane is a popular tool that provides more features than direct API access:

- Screenshot automation
- Metadata management
- More control over releases
- Better error handling

Would you like me to set up Fastlane instead of raw API?

---

## Cost Considerations

- **Google Play Console**: $25 one-time
- **Google Cloud API**: Free (within quotas)
- **GitHub Actions**:
  - Public repos: Free unlimited
  - Private repos: 2,000 minutes/month free
  - Flutter builds: ~10-15 minutes each

---

## Security Best Practices

1. **Never commit secrets to git**
   - Use GitHub Secrets only
   - Rotate service account keys periodically

2. **Use minimal permissions**
   - Service account should only have Play Store access
   - Don't use personal Google account

3. **Protect main branch**
   - Require PR reviews
   - Only deploy from protected branches

4. **Version tagging**
   - Only deploy on git tags (e.g., v1.0.1)
   - Prevents accidental deployments

---

## Recommended Workflow

```
Developer workflow:
1. Create feature branch
2. Make changes
3. Create PR → GitHub Actions builds and tests
4. Merge to main
5. Create git tag (v1.0.1)
6. Push tag → GitHub Actions builds and uploads to Internal Track
7. Test on internal track
8. Manually promote to Beta/Production in Play Console
```

---

## Next Steps

Choose your automation level:

**Conservative (Recommended for first-time)**
- Manual build and upload
- Learn the process
- Switch to automation later

**Semi-Automated (Recommended)**
- GitHub Actions builds AAB
- Auto-upload to Internal Track
- Manual promotion to Production

**Full Automation (Advanced)**
- Complete CI/CD pipeline
- Fastlane integration
- Automated screenshots
- Automated metadata updates

Which approach would you like me to implement?
