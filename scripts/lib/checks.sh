#!/bin/bash
# Checks Library for Flutter iOS Setup
# Provides system requirement and installation check functions

# Check macOS version requirement
# Usage: check_macos_version
# Returns: 0 if meets requirement, 1 otherwise
check_macos_version() {
    local current_version
    local required_version="${MIN_MACOS_VERSION:-12.0}"

    current_version=$(get_macos_version)
    log_info "Checking macOS version: $current_version (required: >= $required_version)"

    if version_gte "$current_version" "$required_version"; then
        log_success "macOS version check passed"
        return 0
    else
        log_error "macOS $required_version or higher is required. Current: $current_version"
        return 1
    fi
}

# Check available disk space
# Usage: check_disk_space
# Returns: 0 if sufficient space, 1 otherwise
check_disk_space() {
    local available_gb
    local required_gb="${MIN_DISK_SPACE_GB:-20}"

    available_gb=$(get_available_disk_space "$HOME")
    log_info "Checking disk space: ${available_gb}GB available (required: >= ${required_gb}GB)"

    if [ "$available_gb" -ge "$required_gb" ]; then
        log_success "Disk space check passed"
        return 0
    else
        log_warning "Low disk space: ${available_gb}GB available, ${required_gb}GB recommended"
        log_warning "Xcode requires ~12-15GB, Flutter ~1-2GB"

        if ! ask_user_confirmation "Continue with low disk space?"; then
            log_error "Installation cancelled due to insufficient disk space"
            return 1
        fi

        return 0
    fi
}

# Check internet connectivity
# Usage: check_internet_connection
# Returns: 0 if connected, 1 otherwise
check_internet_connection() {
    log_info "Checking internet connection..."

    if check_internet; then
        log_success "Internet connection check passed"
        return 0
    else
        log_error "No internet connection detected"
        log_error "Internet connection is required to download Flutter SDK and dependencies"
        return 1
    fi
}

# Check if Homebrew is installed
# Usage: check_homebrew
# Returns: 0 if installed, 1 otherwise
check_homebrew() {
    log_info "Checking Homebrew installation..."

    if command_exists brew; then
        local brew_version
        brew_version=$(brew --version | head -n 1 | awk '{print $2}')
        log_success "Homebrew is installed: v$brew_version"
        save_installation_info "homebrew_version" "$brew_version"
        return 0
    else
        log_warning "Homebrew is not installed"
        return 1
    fi
}

# Check if Xcode Command Line Tools are installed
# Usage: check_xcode_cli_tools
# Returns: 0 if installed, 1 otherwise
check_xcode_cli_tools() {
    log_info "Checking Xcode Command Line Tools..."

    if xcode-select -p &> /dev/null; then
        local cli_path
        cli_path=$(xcode-select -p)
        log_success "Xcode Command Line Tools installed at: $cli_path"
        return 0
    else
        log_warning "Xcode Command Line Tools not installed"
        return 1
    fi
}

# Check if Xcode app is installed
# Usage: check_xcode_app
# Returns: 0 if installed, 1 otherwise
check_xcode_app() {
    log_info "Checking Xcode app..."

    if [ -d "/Applications/Xcode.app" ]; then
        local xcode_version
        xcode_version=$(get_xcode_version)
        log_success "Xcode is installed: v$xcode_version"
        save_installation_info "xcode_version" "$xcode_version"
        return 0
    else
        log_warning "Xcode app is not installed"
        return 1
    fi
}

# Check if Flutter SDK is installed
# Usage: check_flutter_sdk
# Returns: 0 if installed, 1 otherwise
check_flutter_sdk() {
    log_info "Checking Flutter SDK..."

    if command_exists flutter; then
        local flutter_version
        local flutter_path
        flutter_version=$(get_flutter_version)
        flutter_path=$(command -v flutter)
        log_success "Flutter is installed: v$flutter_version at $flutter_path"
        save_installation_info "flutter_version" "$flutter_version"
        save_installation_info "flutter_path" "$flutter_path"
        return 0
    else
        log_warning "Flutter SDK is not installed"
        return 1
    fi
}

# Check if CocoaPods is installed
# Usage: check_cocoapods
# Returns: 0 if installed, 1 otherwise
check_cocoapods() {
    log_info "Checking CocoaPods..."

    if command_exists pod; then
        local pod_version
        pod_version=$(pod --version)
        log_success "CocoaPods is installed: v$pod_version"
        save_installation_info "cocoapods_version" "$pod_version"
        return 0
    else
        log_warning "CocoaPods is not installed"
        return 1
    fi
}

# Check if Git is installed
# Usage: check_git
# Returns: 0 if installed, 1 otherwise
check_git() {
    log_info "Checking Git..."

    if command_exists git; then
        local git_version
        git_version=$(git --version | awk '{print $3}')
        log_success "Git is installed: v$git_version"
        return 0
    else
        log_warning "Git is not installed"
        return 1
    fi
}

# Check if iOS development tools are installed
# Usage: check_ios_tools
# Returns: 0 if all tools installed, 1 otherwise
check_ios_tools() {
    log_info "Checking iOS development tools..."

    local all_installed=true

    # Check ios-deploy
    if command_exists ios-deploy; then
        log_success "ios-deploy is installed"
    else
        log_warning "ios-deploy is not installed"
        all_installed=false
    fi

    # Check ideviceinstaller
    if command_exists ideviceinstaller; then
        log_success "ideviceinstaller is installed"
    else
        log_warning "ideviceinstaller is not installed"
        all_installed=false
    fi

    if $all_installed; then
        return 0
    else
        return 1
    fi
}

# Perform all system checks
# Usage: perform_system_checks
# Returns: 0 if all checks pass, 1 otherwise
perform_system_checks() {
    log_header "System Requirements Check"

    local checks_passed=true

    # Critical checks (must pass)
    if ! check_macos_version; then
        checks_passed=false
    fi

    if ! check_internet_connection; then
        checks_passed=false
    fi

    if ! check_disk_space; then
        checks_passed=false
    fi

    # Warning checks (can continue)
    check_homebrew || true
    check_xcode_cli_tools || true
    check_xcode_app || true
    check_flutter_sdk || true
    check_cocoapods || true
    check_git || true
    check_ios_tools || true

    if $checks_passed; then
        log_success "All critical system checks passed"
        return 0
    else
        log_error "Some critical system checks failed"
        return 1
    fi
}

# Check if Xcode license is accepted
# Usage: check_xcode_license
# Returns: 0 if accepted, 1 otherwise
check_xcode_license() {
    if [ -d "/Applications/Xcode.app" ]; then
        if /usr/bin/xcrun --version &> /dev/null; then
            log_debug "Xcode license is accepted"
            return 0
        else
            log_warning "Xcode license may not be accepted"
            return 1
        fi
    fi
    return 1
}

# Check if Rosetta 2 is installed (for Apple Silicon)
# Usage: check_rosetta
# Returns: 0 if installed or not needed, 1 otherwise
check_rosetta() {
    if is_apple_silicon; then
        log_info "Checking Rosetta 2 (Apple Silicon)..."

        if /usr/bin/pgrep -q oahd; then
            log_success "Rosetta 2 is installed"
            return 0
        else
            log_warning "Rosetta 2 is not installed"
            return 1
        fi
    else
        log_debug "Rosetta 2 not required (Intel Mac)"
        return 0
    fi
}
