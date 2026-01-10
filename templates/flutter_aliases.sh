#!/bin/bash
# Flutter Development Aliases (added by flutter-ios-setup)
# Convenient shortcuts for common Flutter commands

# ============================================================================
# Basic Flutter Commands
# ============================================================================

alias fl='flutter'
alias flr='flutter run'
alias flrd='flutter run -d'
alias flb='flutter build'
alias flt='flutter test'
alias flc='flutter clean'
alias flpg='flutter pub get'
alias flpu='flutter pub upgrade'
alias flpo='flutter pub outdated'

# ============================================================================
# Development & Debugging
# ============================================================================

alias fld='flutter doctor -v'
alias fla='flutter analyze'
alias flf='dart format .'
alias flfc='dart format --set-exit-if-changed .'
alias fldev='flutter devices'
alias fllog='flutter logs'

# ============================================================================
# iOS Specific
# ============================================================================

alias flios='flutter run -d ios'
alias flsim='open -a Simulator'
alias flbuildios='flutter build ios'
alias flbuildipa='flutter build ipa'

# ============================================================================
# Android Specific (for future use)
# ============================================================================

# alias flandroid='flutter run -d android'
# alias flbuildapk='flutter build apk'
# alias flbuildaab='flutter build appbundle'

# ============================================================================
# Project Management
# ============================================================================

alias flcreate='flutter create'
alias flupgrade='flutter upgrade'
alias flchannel='flutter channel'
alias flconfig='flutter config'

# ============================================================================
# Performance & Profiling
# ============================================================================

alias flprofile='flutter run --profile'
alias flrelease='flutter run --release'
alias fltrace='flutter run --trace-startup'

# ============================================================================
# Clean & Reset
# ============================================================================

alias flcleanall='flutter clean && flutter pub get && cd ios && pod install && cd ..'
alias flreset='flutter clean && rm -rf ios/Pods ios/.symlinks ios/Podfile.lock pubspec.lock && flutter pub get && cd ios && pod install && cd ..'

# ============================================================================
# Useful Functions
# ============================================================================

# Run Flutter Doctor and copy output to clipboard (macOS)
fldoc() {
    flutter doctor -v | tee >(pbcopy)
    echo "Output copied to clipboard"
}

# Create new Flutter project with specified name
flnew() {
    if [ -z "$1" ]; then
        echo "Usage: flnew <project_name>"
        return 1
    fi
    flutter create "$1" --org com.example --platforms=ios,android
    cd "$1" || return
}

# Hot reload shortcut (for use outside flutter run)
flhot() {
    echo "Press 'r' to hot reload, 'R' to hot restart, 'q' to quit"
}
