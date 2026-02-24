# Automated Play Store Publishing - Overview

This repository is configured for automated Play Store deployment using GitHub Actions.

---

## 🎯 What's Automated?

### Fully Automated ✅
- **Building**: AAB/APK builds on every PR/push
- **Testing**: Automated test runs
- **Uploading**: AAB upload to Play Store Internal Track
- **Versioning**: Triggered by git tags

### Semi-Automated ⚠️
- **Promotion**: Manual promotion from Internal → Production
- **Store Listing**: Initial setup manual, updates can be automated
- **Screenshots**: Manual (or use Fastlane automation)

### Must Be Manual ❌
- **First Release**: Initial upload to Play Console
- **Account Setup**: Google Play Console account creation
- **Service Account**: Google Cloud API setup

---

## 📋 Quick Start

### Option 1: Semi-Automated (Recommended)

Perfect for most developers. Automated builds and uploads, manual production releases.

```bash
# 1. Verify setup
./verify-cicd-setup.sh

# 2. Create keystore (if not done)
./setup-release.sh

# 3. Follow GITHUB_SECRETS_SETUP.md to add secrets

# 4. Tag and push to trigger deployment
git tag v1.0.1
git push origin v1.0.1

# 5. Check GitHub Actions tab for progress
# 6. Manually promote in Play Console when ready
```

### Option 2: Manual First, Automate Later

Best for first-time publishers. Learn the process, then add automation.

```bash
# 1. Create keystore
./setup-release.sh

# 2. Build AAB manually
flutter build appbundle --release

# 3. Upload to Play Console manually
# 4. Once comfortable, set up automation (Option 1)
```

### Option 3: Full Fastlane Automation (Advanced)

Most powerful option with screenshot automation and metadata management.

```bash
# 1. Install Fastlane
cd android
bundle install

# 2. Configure Fastlane (see CICD_AUTOMATION.md)

# 3. Enable Fastlane workflow
mv .github/workflows/deploy-playstore-fastlane.yml.disabled \
   .github/workflows/deploy-playstore-fastlane.yml

# 4. Deploy
bundle exec fastlane deploy_internal
```

---

## 📁 Files Overview

### Documentation
| File | Purpose |
|------|---------|
| `PLAY_STORE_GUIDE.md` | Complete Play Store submission guide |
| `QUICK_START.md` | Quick reference for manual releases |
| `CICD_AUTOMATION.md` | Detailed automation explanation |
| `GITHUB_SECRETS_SETUP.md` | Step-by-step secrets configuration |
| `AUTOMATION_README.md` | This file - automation overview |

### Scripts
| File | Purpose |
|------|---------|
| `setup-release.sh` | Create keystore and build release |
| `verify-cicd-setup.sh` | Verify CI/CD configuration |

### CI/CD Configuration
| File | Purpose |
|------|---------|
| `.github/workflows/build.yml` | Build and test on PRs |
| `.github/workflows/deploy-playstore.yml` | Deploy to Play Store |
| `.github/workflows/deploy-playstore-fastlane.yml.disabled` | Fastlane alternative |
| `android/fastlane/Fastfile` | Fastlane lanes configuration |
| `distribution/whatsnew/` | Release notes directory |

---

## 🔄 Typical Workflow

### Development
```bash
# 1. Create feature branch
git checkout -b feature/new-timer-sound

# 2. Make changes
# ... edit code ...

# 3. Push and create PR
git push origin feature/new-timer-sound

# GitHub Actions will:
# - Build the app
# - Run tests
# - Upload debug APK artifact
```

### Release
```bash
# 1. Merge PR to main
git checkout main
git pull

# 2. Update version (if needed)
# Edit android/app/build.gradle.kts:
# versionCode = 2
# versionName = "1.0.1"

# 3. Update release notes
# Edit distribution/whatsnew/whatsnew-en-US

# 4. Commit version bump
git add .
git commit -m "Bump version to 1.0.1"
git push

# 5. Create and push tag
git tag v1.0.1
git push origin v1.0.1

# GitHub Actions will:
# - Build release AAB
# - Sign with keystore
# - Upload to Internal Track

# 6. Test on Internal Track
# - Install from Play Console
# - Verify functionality

# 7. Promote to Production
# - Go to Play Console
# - Promote Internal → Production
```

---

## 🔐 Security Setup

### Required Secrets

Add these in: **GitHub Repo → Settings → Secrets and variables → Actions**

| Secret | Description | How to Get |
|--------|-------------|------------|
| `KEYSTORE_BASE64` | Base64-encoded keystore | `base64 -i ~/upload-keystore.jks \| pbcopy` |
| `KEYSTORE_PASSWORD` | Keystore password | From keystore creation |
| `KEY_PASSWORD` | Key password | From keystore creation |
| `KEY_ALIAS` | Key alias | Usually `upload` |
| `PLAYSTORE_SERVICE_ACCOUNT_JSON` | Service account JSON | Google Cloud Console |

**Detailed instructions**: See `GITHUB_SECRETS_SETUP.md`

---

## 🚀 Deployment Tracks

### Internal Track (Automated)
- **Purpose**: Initial testing
- **Audience**: Internal testers only
- **Deployment**: Automated via GitHub Actions
- **Review**: Minimal/none

### Alpha Track (Manual Promotion)
- **Purpose**: Limited external testing
- **Audience**: Closed testing group
- **Deployment**: Manually promote from Internal
- **Review**: Minimal

### Beta Track (Manual Promotion)
- **Purpose**: Wider testing before production
- **Audience**: Open testing (optional)
- **Deployment**: Manually promote from Alpha
- **Review**: Standard

### Production Track (Manual Promotion)
- **Purpose**: Public release
- **Audience**: All users
- **Deployment**: Manually promote from Beta
- **Review**: Full review (first time)

---

## 🔍 Monitoring & Troubleshooting

### Check Build Status
1. Go to GitHub repository
2. Click "Actions" tab
3. View workflow runs

### Check Play Store Upload
1. Go to Play Console
2. Navigate to Release → Testing → Internal testing
3. Check for new version

### Common Issues

**Build fails with "signing error"**
- Check GitHub secrets are set correctly
- Verify keystore password matches

**Upload fails with "permission denied"**
- Ensure service account has correct permissions
- Check API is enabled in Google Cloud

**Version already exists**
- Increment `versionCode` in build.gradle.kts
- Each release needs unique version code

**First release fails**
- First release to any track MUST be manual
- Upload one version manually first

---

## 📊 Comparison: Manual vs Automated

| Aspect | Manual | Semi-Automated | Full Automated |
|--------|--------|----------------|----------------|
| Build AAB | Manual command | GitHub Actions | GitHub Actions |
| Sign AAB | Local keystore | GitHub Secrets | GitHub Secrets |
| Upload | Manual upload | GitHub Actions | GitHub Actions |
| Testing | Manual install | Internal track | Multi-track |
| Production | Manual | Manual approval | Auto-deploy |
| Rollback | Manual | Manual | Auto (Fastlane) |
| Setup Time | 0 min | 30 min | 2 hours |
| Maintenance | Low | Low | Medium |
| Control | Full | High | Medium |
| Speed | Slow | Fast | Fastest |

**Recommendation**: Start with Semi-Automated, upgrade to Full when needed.

---

## 📈 Version Management

### Manual Approach
```kotlin
// android/app/build.gradle.kts
versionCode = 1  // Increment manually
versionName = "1.0.0"  // Update manually
```

### Automated Approach (Fastlane)
```ruby
# Automatically increment version code
increment_version_code(
  gradle_file_path: "./app/build.gradle.kts"
)
```

---

## 🎓 Learning Path

### Week 1: Manual Process
- Set up keystore
- Build release manually
- Upload to Play Console manually
- Learn the review process

### Week 2: CI/CD Basics
- Add GitHub secrets
- Enable build workflow
- Test PR builds
- Monitor Actions

### Week 3: Automated Deployment
- Enable deploy workflow
- Deploy to Internal track
- Test automation
- Manual promotion

### Week 4+: Advanced Features
- Fastlane integration
- Automated screenshots
- Metadata management
- Multi-track deployments

---

## 📞 Getting Help

### Check Documentation
1. This file for overview
2. `CICD_AUTOMATION.md` for technical details
3. `GITHUB_SECRETS_SETUP.md` for secrets
4. `PLAY_STORE_GUIDE.md` for Play Store specifics

### Verify Setup
```bash
./verify-cicd-setup.sh
```

### Common Resources
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Play Console Help](https://support.google.com/googleplay/android-developer)
- [Fastlane Docs](https://docs.fastlane.tools/)
- [Flutter Deployment](https://docs.flutter.dev/deployment/android)

---

## ✅ Checklist

Before first automated deployment:

- [ ] Read `CICD_AUTOMATION.md`
- [ ] Run `./verify-cicd-setup.sh`
- [ ] Create keystore with `./setup-release.sh`
- [ ] Create Google Play Console account
- [ ] Create app in Play Console
- [ ] Upload first version manually
- [ ] Create Google Cloud service account
- [ ] Add all GitHub secrets
- [ ] Test build workflow (PR)
- [ ] Test deploy workflow (tag)
- [ ] Promote to production manually

**You're ready to automate! 🎉**
