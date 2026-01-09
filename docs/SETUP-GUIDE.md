# Complete Setup Guide

Detailed guide for setting up Flutter iOS development environment on macOS.

## Overview

This setup process will install and configure:
- Flutter SDK (latest stable)
- Xcode and iOS development tools
- CocoaPods (iOS dependency manager)
- Development tools (ios-deploy, libimobiledevice)
- Shell environment configuration

**Estimated time**: 1-2 hours (mostly Xcode download)

## Prerequisites

Before running the setup:

- **macOS 12.0+** (Monterey or later)
- **20GB+** free disk space
- **Stable internet** connection
- **Administrator access** (for sudo commands)
- **Apple ID** (free account works)

## Installation Steps

### Step 1: Clone or Download

```bash
# Clone the repository
git clone <your-repo-url> flutter-ios-setup
cd flutter-ios-setup

# Or download and extract ZIP
```

### Step 2: Review Configuration (Optional)

The script uses default settings, but you can customize:

```bash
# Copy example config
cp config/config.example.sh config/config.sh

# Edit configuration
nano config/config.sh
```

**Key settings**:
- `FLUTTER_INSTALL_DIR`: Where Flutter will be installed
- `TEST_PROJECT_NAME`: Name for test project
- `CREATE_TEST_PROJECT`: Whether to create test project

### Step 3: Run Setup Script

```bash
./setup.sh
```

The script will:
1. Check system requirements
2. Install/verify Homebrew
3. Prompt for Xcode installation (if needed)
4. Install Flutter SDK
5. Configure your shell environment
6. Install CocoaPods
7. Install iOS development tools
8. Run Flutter Doctor
9. Create test project (if enabled)

### Step 4: Install Xcode

When prompted:

1. Script will open App Store automatically
2. Search for "Xcode" if not redirected
3. Click "Get" or cloud download icon
4. Wait for download (12-15GB, 30-60 minutes)
5. After installation, return to terminal
6. Press Enter to continue
7. Enter password when prompted for sudo

The script will then:
- Accept Xcode license
- Configure Xcode settings
- Install additional components

### Step 5: Restart Terminal

After setup completes, restart your terminal or run:

```bash
# For zsh (default on modern macOS)
source ~/.zshrc

# For bash
source ~/.bashrc
```

This loads Flutter into your PATH.

### Step 6: Verify Installation

```bash
# Run verification script
./scripts/verify.sh

# Or manually check
flutter doctor -v
```

Expected output:
```
[✓] Flutter (Channel stable, X.X.X)
[✓] Xcode - develop for iOS and macOS (X.X.X)
[✓] CocoaPods version X.X.X
```

## Post-Installation

### Test in Simulator

1. Open simulator:
   ```bash
   open -a Simulator
   ```

2. Run test app (if created):
   ```bash
   cd flutter_test_app
   flutter run
   ```

3. App should build and launch in simulator

### Connect Physical Device

See [DEVICE-CONNECTION.md](DEVICE-CONNECTION.md) for:
- Enabling Developer Mode
- Trusting your computer
- Configuring code signing

### Setup Apple Developer Account

See [APPLE-DEVELOPER.md](APPLE-DEVELOPER.md) for:
- Free vs paid account
- Code signing configuration
- TestFlight setup

## What Gets Installed

### System Modifications

**Homebrew** (if not present):
- Location: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
- Used for: Installing tools and dependencies

**Flutter SDK**:
- Default location: `~/development/flutter`
- Size: ~1-2GB
- Includes: Flutter framework, Dart SDK, iOS toolchain

**Xcode**:
- Location: `/Applications/Xcode.app`
- Size: ~12-15GB
- Includes: iOS SDK, simulators, build tools

**CocoaPods**:
- iOS dependency manager
- Installed via Homebrew
- Used by: Flutter iOS projects

**iOS Tools**:
- `ios-deploy`: Deploy apps to physical devices
- `libimobiledevice`: Communicate with iOS devices
- `ideviceinstaller`: Install apps on devices

### Configuration Changes

**Shell Configuration** (~/.zshrc or ~/.bashrc):
```bash
export FLUTTER_HOME="$HOME/development/flutter"
export PATH="$FLUTTER_HOME/bin:$PATH"
export PATH="$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
```

**State Tracking**:
- `state/setup-state.json`: Installation state for resume capability
- `logs/setup-*.log`: Detailed installation logs

## Resume Capability

If setup is interrupted, simply run `./setup.sh` again. The script will:
- Check what's already completed
- Skip completed steps
- Continue from where it left off

To force re-installation of a step, edit `state/setup-state.json` and remove the step name from `completed_steps` array.

## Customization

### Change Flutter Installation Location

Edit `config/config.sh`:
```bash
FLUTTER_INSTALL_DIR="/custom/path/flutter"
```

### Skip Test Project Creation

Edit `config/config.sh`:
```bash
CREATE_TEST_PROJECT=false
```

### Disable iOS Tools

Edit `config/config.sh`:
```bash
INSTALL_IOS_TOOLS=false
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions to common issues.

Quick fixes:

**Flutter not found after setup**:
```bash
source ~/.zshrc  # or ~/.bashrc
flutter --version
```

**Xcode license issue**:
```bash
sudo xcodebuild -license accept
```

**CocoaPods issues**:
```bash
brew upgrade cocoapods
pod repo update
```

## Uninstallation

To remove Flutter and related tools:

1. **Remove Flutter**:
   ```bash
   rm -rf ~/development/flutter
   ```

2. **Remove from shell config**:
   Edit `~/.zshrc` or `~/.bashrc` and remove Flutter-related lines

3. **Optional - Remove Homebrew packages**:
   ```bash
   brew uninstall cocoapods ios-deploy libimobiledevice ideviceinstaller
   ```

4. **Optional - Remove Xcode**:
   - Drag `/Applications/Xcode.app` to Trash
   - Clear derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData`

**Note**: This doesn't remove Homebrew itself, as it may be used by other tools.

## Next Steps

1. **Learn Flutter**: [flutter.dev/docs/get-started/codelab](https://flutter.dev/docs/get-started/codelab)
2. **Connect Device**: [DEVICE-CONNECTION.md](DEVICE-CONNECTION.md)
3. **Setup Code Signing**: [APPLE-DEVELOPER.md](APPLE-DEVELOPER.md)
4. **Build Your App**: Start developing!

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Samples](https://flutter.github.io/samples/)
- [iOS Development](https://developer.apple.com/ios/)
- [Xcode Documentation](https://developer.apple.com/xcode/)

## Getting Help

- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- Review installation logs: `cat logs/setup-*.log`
- Search [Flutter issues](https://github.com/flutter/flutter/issues)
- Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- Create an issue in this repository
