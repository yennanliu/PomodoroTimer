# GitHub Secrets Setup Guide

This guide explains how to set up all the secrets needed for automated Play Store deployment.

---

## Prerequisites

1. ✅ Keystore created (run `./setup-release.sh` if not done yet)
2. ✅ Google Play Console account created
3. ✅ App created in Play Console (at least internal track)
4. ✅ Google Cloud service account with Play Store API access

---

## Required GitHub Secrets

Go to your repository: **Settings → Secrets and variables → Actions → New repository secret**

### 1. KEYSTORE_BASE64

This is your keystore file encoded in base64.

**On macOS/Linux:**
```bash
base64 -i ~/upload-keystore.jks | pbcopy
```

**On Windows (PowerShell):**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$HOME\upload-keystore.jks")) | Set-Clipboard
```

- Name: `KEYSTORE_BASE64`
- Value: Paste from clipboard (will be very long)

---

### 2. KEYSTORE_PASSWORD

Your keystore password (the one you created with keytool).

- Name: `KEYSTORE_PASSWORD`
- Value: Your keystore password

---

### 3. KEY_PASSWORD

Your key password (usually the same as keystore password).

- Name: `KEY_PASSWORD`
- Value: Your key password

---

### 4. KEY_ALIAS

The alias you used when creating the keystore (default is "upload").

- Name: `KEY_ALIAS`
- Value: `upload`

---

### 5. PLAYSTORE_SERVICE_ACCOUNT_JSON

The Google Cloud service account JSON file content.

**Steps:**

1. Go to Google Cloud Console: https://console.cloud.google.com/
2. Select/Create project linked to Play Console
3. Enable "Google Play Android Developer API"
4. Create Service Account:
   - IAM & Admin → Service Accounts
   - Create Service Account
   - Name: `github-actions-play-store`
5. Create JSON key:
   - Click on service account
   - Keys tab → Add Key → Create new key → JSON
   - Download the JSON file
6. Grant access in Play Console:
   - Play Console → Settings → API access
   - Find your service account
   - Grant access with permissions:
     - ✓ View app information
     - ✓ Manage releases
     - ✓ Manage testing tracks

**Copy JSON content:**

```bash
# On macOS/Linux
cat ~/Downloads/your-service-account-key.json | pbcopy

# On Windows (PowerShell)
Get-Content "$HOME\Downloads\your-service-account-key.json" | Set-Clipboard
```

- Name: `PLAYSTORE_SERVICE_ACCOUNT_JSON`
- Value: Paste entire JSON content

---

## Verify Secrets

After adding all secrets, you should have:

| Secret Name | Description |
|-------------|-------------|
| `KEYSTORE_BASE64` | Base64-encoded keystore file |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `KEY_ALIAS` | Key alias (usually "upload") |
| `PLAYSTORE_SERVICE_ACCOUNT_JSON` | Google Cloud service account JSON |

---

## Testing the Setup

### Test Build Workflow

1. Create a test branch:
```bash
git checkout -b test-ci
git push origin test-ci
```

2. Create a PR to main - this will trigger the build workflow
3. Check Actions tab for build results

### Test Deploy Workflow

1. Make sure you've:
   - ✅ Created keystore
   - ✅ Added all GitHub secrets
   - ✅ Manually uploaded at least one version to Play Console (required for API access)

2. Create and push a version tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```

3. Check Actions tab for deployment progress
4. Check Play Console → Internal testing track for the upload

---

## Important Notes

### First Release Must Be Manual

⚠️ **The first release to any track MUST be uploaded manually** through Play Console. The API cannot create the initial release.

After the first manual upload:
1. Internal track ✅
2. Subsequent versions can be automated

### Service Account Permissions

The service account needs these permissions in Play Console:
- **View app information** (read-only)
- **Manage releases** (create and edit releases)
- **Manage testing tracks** (internal, alpha, beta)

Do NOT grant:
- Admin access
- Financial data access
- User data access

### Security Best Practices

1. **Never commit secrets to git**
   - Use GitHub Secrets only
   - Don't store in code or config files

2. **Rotate keys periodically**
   - Service account keys should be rotated annually
   - Update GitHub secret when rotating

3. **Use separate service accounts**
   - One for CI/CD
   - One for human access (if needed)
   - Makes auditing easier

4. **Limit service account scope**
   - Only grant necessary permissions
   - Don't reuse for other projects

---

## Troubleshooting

### "Permission denied" error
- Verify service account has correct permissions in Play Console
- Check that API is enabled in Google Cloud Console
- Ensure service account JSON is correct

### "Version code already exists"
- Increment `versionCode` in `android/app/build.gradle.kts`
- Each release needs a unique, higher version code

### "No edit can be made to the app"
- First release must be manual
- Upload one version manually first
- Then automation will work

### "Invalid keystore format"
- Verify base64 encoding is correct
- Check that entire keystore was encoded
- Try encoding again

### Build times out
- GitHub Actions has 6-hour limit (shouldn't be an issue)
- Check for hanging tests
- Review build logs

---

## Workflow Diagram

```
Developer → Commit → Push to main → Build Workflow (PR/Push)
                                         ↓
                                    Run Tests
                                         ↓
                                    Build Debug APK
                                         ↓
                                    Upload Artifact

Developer → Create Tag (v1.0.x) → Deploy Workflow
                                         ↓
                                    Run Tests
                                         ↓
                                    Build Release AAB
                                         ↓
                                    Sign with Keystore
                                         ↓
                                    Upload to Play Store (Internal)
                                         ↓
                                    Manual: Promote to Production
```

---

## Next Steps

After setup:

1. Test the build workflow (PR to main)
2. Create keystore if not done: `./setup-release.sh`
3. Manually upload v1.0.0 to Play Console
4. Add all GitHub secrets
5. Test deployment: `git tag v1.0.1 && git push origin v1.0.1`
6. Promote to production manually in Play Console

---

## Support

If you encounter issues:
1. Check GitHub Actions logs
2. Review Google Play Console error messages
3. Verify all secrets are set correctly
4. Ensure first release was manual
5. Check service account permissions

Common error messages and solutions in CICD_AUTOMATION.md
