#!/bin/bash

# Verification Script for CI/CD Setup
# Checks if all required components are in place for automated deployment

echo "========================================"
echo "CI/CD Setup Verification"
echo "========================================"
echo ""

ERRORS=0
WARNINGS=0

# Check 1: Keystore exists
echo "1. Checking keystore..."
if [ -f "$HOME/upload-keystore.jks" ]; then
    echo "   ✓ Keystore found at $HOME/upload-keystore.jks"
else
    echo "   ✗ Keystore not found at $HOME/upload-keystore.jks"
    echo "     Run: ./setup-release.sh"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 2: GitHub workflows exist
echo "2. Checking GitHub workflows..."
if [ -f ".github/workflows/build.yml" ]; then
    echo "   ✓ Build workflow exists"
else
    echo "   ✗ Build workflow missing"
    ERRORS=$((ERRORS + 1))
fi

if [ -f ".github/workflows/deploy-playstore.yml" ]; then
    echo "   ✓ Deploy workflow exists"
else
    echo "   ✗ Deploy workflow missing"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 3: Fastlane setup (optional)
echo "3. Checking Fastlane setup (optional)..."
if [ -f "android/fastlane/Fastfile" ]; then
    echo "   ✓ Fastlane configured"
else
    echo "   ⚠ Fastlane not configured (optional)"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Check 4: Release notes
echo "4. Checking release notes..."
if [ -f "distribution/whatsnew/whatsnew-en-US" ]; then
    echo "   ✓ Release notes template exists"
else
    echo "   ⚠ Release notes missing"
    echo "     Create: distribution/whatsnew/whatsnew-en-US"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Check 5: Git repository
echo "5. Checking Git setup..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "   ✓ Git repository initialized"

    # Check remote
    if git remote -v | grep -q origin; then
        REMOTE_URL=$(git remote get-url origin)
        echo "   ✓ Remote configured: $REMOTE_URL"
    else
        echo "   ✗ No remote configured"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "   ✗ Not a git repository"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check 6: Android configuration
echo "6. Checking Android configuration..."
if grep -q "com.yen.pomodoro_time" android/app/build.gradle.kts; then
    echo "   ✓ Package name configured"
else
    echo "   ✗ Package name not set"
    ERRORS=$((ERRORS + 1))
fi

if grep -q "versionCode = 1" android/app/build.gradle.kts; then
    echo "   ✓ Version code set"
else
    echo "   ⚠ Version code not found"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Check 7: Documentation
echo "7. Checking documentation..."
DOCS=("PLAY_STORE_GUIDE.md" "QUICK_START.md" "CICD_AUTOMATION.md" "GITHUB_SECRETS_SETUP.md")
for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo "   ✓ $doc exists"
    else
        echo "   ⚠ $doc missing"
        WARNINGS=$((WARNINGS + 1))
    fi
done
echo ""

# Summary
echo "========================================"
echo "Summary"
echo "========================================"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✓ All checks passed!"
    echo ""
    echo "Next steps:"
    echo "1. Create Google Cloud service account"
    echo "2. Add GitHub secrets (see GITHUB_SECRETS_SETUP.md)"
    echo "3. Manually upload first version to Play Console"
    echo "4. Create and push a git tag to trigger deployment"
    echo ""
elif [ $ERRORS -eq 0 ]; then
    echo "✓ No errors found"
    echo "⚠ $WARNINGS warning(s) - review above"
    echo ""
    echo "You can proceed, but address warnings for best results."
    echo ""
else
    echo "✗ $ERRORS error(s) found"
    echo "⚠ $WARNINGS warning(s) found"
    echo ""
    echo "Fix errors before attempting automated deployment."
    echo ""
    exit 1
fi

echo "========================================"
echo "Manual Checklist"
echo "========================================"
echo ""
echo "Before first automated deployment:"
echo "  [ ] Google Play Console account created"
echo "  [ ] App created in Play Console"
echo "  [ ] First version uploaded manually"
echo "  [ ] Google Cloud service account created"
echo "  [ ] Service account granted Play Store API access"
echo "  [ ] All GitHub secrets added"
echo ""
echo "See GITHUB_SECRETS_SETUP.md for detailed instructions."
echo ""
