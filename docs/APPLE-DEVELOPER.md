# Apple Developer Account Setup

Guide for setting up Apple Developer accounts and code signing for iOS app development.

## Account Types Overview

### Free Apple ID Account

**Cost**: Free
**Best for**: Learning, personal projects, testing on your own devices

**Capabilities**:
- Test apps on your own devices (up to 3 devices per type)
- Apps expire after 7 days (must reinstall)
- No App Store distribution
- No TestFlight
- Basic app services only

**Limitations**:
- Maximum 3 devices per device type (3 iPhones, 3 iPads, etc.)
- Must reinstall app every 7 days
- Cannot use advanced capabilities (Push Notifications, In-App Purchase, etc.)
- Cannot distribute to others

### Apple Developer Program

**Cost**: $99/year (USD)
**Best for**: App Store distribution, professional development

**Capabilities**:
- Unlimited device testing
- No app expiration
- App Store distribution
- TestFlight (up to 10,000 beta testers)
- All app capabilities and services
- App Analytics
- Beta OS access

**Required for**:
- Publishing to App Store
- Advanced app capabilities
- Long-term development

### Apple Developer Enterprise Program

**Cost**: $299/year (USD)
**Best for**: Internal company app distribution (NOT for App Store)

**Note**: Only for distributing apps within your organization. Cannot publish to public App Store.

## Getting Started with Free Account

### 1. Add Apple ID to Xcode

1. Open **Xcode**
2. Go to **Settings** (or **Preferences** in older versions)
3. Click **Accounts** tab
4. Click the **+** button at the bottom left
5. Select **Apple ID**
6. Sign in with your Apple ID
7. Click **Next**

Your account will appear in the list.

### 2. Configure Code Signing (Free Account)

1. Open your Flutter project in Xcode:
   ```bash
   cd your_flutter_project
   open ios/Runner.xcworkspace
   ```

2. In the project navigator (left sidebar), click **Runner**

3. Select the **Runner** target (under TARGETS)

4. Go to **Signing & Capabilities** tab

5. Under **Signing**, check **"Automatically manage signing"**

6. Select your **Team** (your Apple ID)

7. Xcode will automatically:
   - Create a development certificate
   - Generate a provisioning profile
   - Configure the bundle identifier

**Important**: The bundle identifier will be modified to include your team ID.
Example: `com.example.app` becomes `com.example.app.TEAM123`

### 3. Run on Device

```bash
flutter run
```

or in Xcode: Product > Run (Cmd+R)

**First run**: Xcode may prompt you to register your device. Click **Register** and wait for the process to complete.

## Upgrading to Paid Developer Program

### Benefits

- No 7-day expiration
- Unlimited devices
- App Store distribution
- TestFlight beta testing
- Push notifications, In-App Purchases, etc.

### Enrollment Process

1. Go to [developer.apple.com/programs/enroll](https://developer.apple.com/programs/enroll/)
2. Click **Start Your Enrollment**
3. Sign in with your Apple ID
4. Review the Apple Developer Agreement
5. Select entity type (Individual or Organization)
6. Complete personal/company information
7. Purchase membership ($99/year)

**Processing time**: Usually instant, but can take up to 48 hours for verification.

### After Enrollment

1. In Xcode, go to **Settings** > **Accounts**
2. Select your Apple ID
3. Click **Download Manual Profiles**
4. Your account type will update to show "Apple Developer Program"

## Code Signing Concepts

### What is Code Signing?

Code signing proves that:
1. The app comes from a known developer (you)
2. The app hasn't been modified since signing
3. The app is allowed to run on specific devices

### Signing Components

**Development Certificate**:
- Identifies you as a developer
- Stored in Keychain
- Used to sign apps during development

**Provisioning Profile**:
- Links your certificate, App ID, and devices
- Allows app to run on specific devices
- Different profiles for development, distribution, etc.

**Bundle Identifier**:
- Unique identifier for your app
- Format: `com.company.appname`
- Must be unique across App Store

### Automatic vs Manual Signing

**Automatic Signing** (Recommended for beginners):
- Xcode manages certificates and profiles
- Handles renewals automatically
- Simplest approach

**Manual Signing** (Advanced):
- You manage certificates and profiles
- More control
- Required for complex setups (CI/CD, multiple teams)

## Common Code Signing Issues

### "Failed to register bundle identifier"

**Problem**: Bundle ID is already taken or invalid.

**Solution**:
1. Change bundle identifier in Xcode:
   - Runner target > General > Bundle Identifier
2. Use reverse domain notation: `com.yourname.appname`
3. Make it unique (add numbers if needed): `com.yourname.myapp2`

### "No signing certificate found"

**Problem**: No valid certificate in Keychain.

**Solution**:
1. Enable "Automatically manage signing"
2. Select your team
3. Xcode will create certificate automatically

If that fails:
1. Xcode > Settings > Accounts
2. Select your Apple ID
3. Click "Manage Certificates"
4. Click "+" > "Apple Development"

### "Provisioning profile doesn't match"

**Solution**:
1. Clean build folder: Product > Clean Build Folder (Cmd+Shift+K)
2. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Rebuild project

### "Maximum number of certificates generated"

**Problem**: You've created too many certificates (limit varies by account type).

**Solution**:
1. Go to [developer.apple.com/account/resources/certificates](https://developer.apple.com/account/resources/certificates)
2. Revoke old/unused certificates
3. Create new certificate in Xcode

## TestFlight (Paid Account Only)

TestFlight allows you to distribute beta versions to testers.

### Setup

1. Archive your app in Xcode:
   - Product > Archive
2. Click "Distribute App"
3. Select "TestFlight & App Store"
4. Follow the prompts
5. Upload to App Store Connect

### Inviting Testers

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Select your app
3. Go to TestFlight tab
4. Add internal testers (your team, up to 100)
5. Add external testers (public, up to 10,000)

## Best Practices

1. **Start with free account** - Learn and test before paying
2. **Use automatic signing** - Unless you have specific needs
3. **Keep bundle ID consistent** - Don't change it after App Store submission
4. **Backup certificates** - Export from Keychain (File > Export Items)
5. **Use unique bundle IDs** - Follow reverse domain notation

## Resources

- [Apple Developer Portal](https://developer.apple.com)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [TestFlight Documentation](https://developer.apple.com/testflight/)

## Next Steps

- Connect your iOS device: [DEVICE-CONNECTION.md](DEVICE-CONNECTION.md)
- Deploy your first app to device
- Learn about App Store submission process
