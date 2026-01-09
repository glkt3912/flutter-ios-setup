#!/bin/bash
# Flutter iOS Setup Configuration
# Copy this file to config.sh and customize as needed
#
# Usage:
#   cp config/config.example.sh config/config.sh
#   # Edit config/config.sh with your preferences
#   ./setup.sh

# ==============================================================================
# Flutter SDK Settings
# ==============================================================================

# Flutter SDK installation directory
# Default: $HOME/development/flutter
# Note: Use absolute path or expand $HOME
FLUTTER_INSTALL_DIR="${HOME}/development/flutter"

# Flutter channel (stable, beta, dev, master)
# Default: stable (recommended for production)
FLUTTER_CHANNEL="stable"

# ==============================================================================
# Test Project Settings
# ==============================================================================

# Directory where the test project will be created
# Default: current directory
# Note: Use "." for current directory or specify full path
TEST_PROJECT_DIR="."

# Test project name
# Default: flutter_test_app
TEST_PROJECT_NAME="flutter_test_app"

# Organization identifier for the test project
# Default: com.example
# Note: Used for iOS bundle identifier (e.g., com.example.flutter_test_app)
TEST_PROJECT_ORG="com.example"

# ==============================================================================
# Installation Options
# ==============================================================================

# Install CocoaPods (iOS dependency manager)
# Default: true
# Set to false if you want to install CocoaPods manually
INSTALL_COCOAPODS=true

# Install iOS development tools (ios-deploy, libimobiledevice, etc.)
# Default: true
# These tools are useful for physical device deployment
INSTALL_IOS_TOOLS=true

# Create a test Flutter project after setup
# Default: true
# Set to false to skip test project creation
CREATE_TEST_PROJECT=true

# ==============================================================================
# System Requirements
# ==============================================================================

# Minimum required disk space in GB
# Default: 20
# Xcode alone requires ~12-15GB
MIN_DISK_SPACE_GB=20

# Minimum required macOS version
# Default: 12.0 (Monterey)
# Flutter 3.x requires macOS 12 or higher
MIN_MACOS_VERSION="12.0"

# ==============================================================================
# Logging Settings
# ==============================================================================

# Log level: DEBUG, INFO, WARNING, ERROR
# Default: INFO
# DEBUG provides detailed information, ERROR only shows errors
LOG_LEVEL="INFO"

# Number of days to keep log files
# Default: 30
# Old log files will be automatically deleted
KEEP_LOGS_DAYS=30

# ==============================================================================
# Platform Support (Future Expansion)
# ==============================================================================

# Enable iOS development
# Default: true
ENABLE_IOS=true

# Enable Android development
# Default: false
# Note: Android support is not implemented yet
ENABLE_ANDROID=false

# Enable Web development
# Default: false
# Note: Web support is not implemented yet
ENABLE_WEB=false

# ==============================================================================
# Advanced Options
# ==============================================================================

# Skip already completed steps (resume capability)
# Default: true
# Set to false to force re-execution of all steps
SKIP_COMPLETED_STEPS=true

# Perform system checks before installation
# Default: true
# Set to false to skip system requirements check (not recommended)
PERFORM_SYSTEM_CHECKS=true

# Auto-accept prompts (non-interactive mode)
# Default: false
# Set to true for CI/CD environments (use with caution)
AUTO_ACCEPT=false
