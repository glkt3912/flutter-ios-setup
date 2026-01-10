#!/bin/bash
#
# Flutter iOS Development Environment Setup Script
# Automates the installation and configuration of Flutter for iOS development on macOS
#
# Usage: ./setup.sh
#
# For more information, see README.md or docs/SETUP-GUIDE.md

set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Script metadata
readonly SETUP_VERSION="1.0.0"
readonly TOTAL_STEPS=12

# Get script directory (works even if called from another location)
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Setup paths
readonly CONFIG_DIR="${SCRIPT_DIR}/config"
readonly LOG_DIR="${SCRIPT_DIR}/logs"
readonly STATE_DIR="${SCRIPT_DIR}/state"
readonly SCRIPTS_LIB_DIR="${SCRIPT_DIR}/scripts/lib"

# Create necessary directories
mkdir -p "$LOG_DIR" "$STATE_DIR"

# Setup logging
readonly LOG_FILE="${LOG_DIR}/setup-$(date +%Y%m%d-%H%M%S).log"
readonly STATE_FILE="${STATE_DIR}/setup-state.json"

# Load configuration
if [ ! -f "${CONFIG_DIR}/config.sh" ]; then
    echo "Configuration file not found. Creating from example..."
    cp "${CONFIG_DIR}/config.example.sh" "${CONFIG_DIR}/config.sh"
    echo "Created config/config.sh"
    echo "Review and customize if needed, then run this script again."
    echo ""
    read -p "Continue with default configuration? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Please edit config/config.sh and run this script again."
        exit 0
    fi
fi

source "${CONFIG_DIR}/config.sh"

# Load utility libraries
source "${SCRIPTS_LIB_DIR}/logger.sh"
source "${SCRIPTS_LIB_DIR}/utils.sh"
source "${SCRIPTS_LIB_DIR}/checks.sh"

# Initialize logger
init_logger

# ==============================================================================
# Installation Functions
# ==============================================================================

# Install Homebrew
install_homebrew() {
    local step_name="homebrew"

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Homebrew (already installed)"
        return 0
    fi

    log_step 1 $TOTAL_STEPS "Installing Homebrew"

    if check_homebrew; then
        mark_step_completed "$step_name"
        return 0
    fi

    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for current session
    if is_apple_silicon; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    log_success "Homebrew installed successfully"
    mark_step_completed "$step_name"
}

# Install Xcode Command Line Tools
install_xcode_cli_tools() {
    local step_name="xcode_cli"

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Xcode CLI Tools (already installed)"
        return 0
    fi

    log_step 2 $TOTAL_STEPS "Installing Xcode Command Line Tools"

    if check_xcode_cli_tools; then
        mark_step_completed "$step_name"
        return 0
    fi

    log_info "Installing Xcode Command Line Tools..."
    xcode-select --install

    log_warning "Follow the prompts to install Xcode Command Line Tools"
    log_warning "Press Enter after installation completes..."
    read -r

    if check_xcode_cli_tools; then
        log_success "Xcode Command Line Tools installed"
        mark_step_completed "$step_name"
    else
        log_error "Xcode Command Line Tools installation failed"
        return 1
    fi
}

# Setup Xcode
setup_xcode() {
    local step_name="xcode_app"

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Xcode setup (already configured)"
        return 0
    fi

    log_step 3 $TOTAL_STEPS "Setting up Xcode"

    if [ ! -d "/Applications/Xcode.app" ]; then
        log_warning "Xcode is not installed"
        log_info "Xcode is required for iOS development (Size: ~12-15GB)"
        echo ""
        echo "Please install Xcode from the App Store:"
        echo "  1. Open App Store"
        echo "  2. Search for 'Xcode'"
        echo "  3. Click 'Get' or 'Install'"
        echo "  4. Wait for installation to complete (30-60 minutes)"
        echo ""

        if ask_user_confirmation "Open App Store now?"; then
            open "macappstore://apps.apple.com/app/xcode/id497799835"
        fi

        log_warning "Press Enter after Xcode installation completes..."
        read -r

        if [ ! -d "/Applications/Xcode.app" ]; then
            log_error "Xcode not found at /Applications/Xcode.app"
            return 1
        fi
    fi

    # Accept license
    log_info "Accepting Xcode license..."
    sudo xcodebuild -license accept 2>/dev/null || {
        log_warning "Could not auto-accept license, opening manual prompt..."
        sudo xcodebuild -license
    }

    # Set command line tools path
    log_info "Setting Xcode path..."
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

    # Run first launch
    log_info "Running Xcode first launch setup..."
    sudo xcodebuild -runFirstLaunch 2>/dev/null || true

    log_success "Xcode setup complete"
    mark_step_completed "$step_name"
}

# Install Flutter SDK
install_flutter_sdk() {
    local step_name="flutter_sdk"

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Flutter SDK (already installed)"
        return 0
    fi

    log_step 4 $TOTAL_STEPS "Installing Flutter SDK"

    if check_flutter_sdk && [ -d "$FLUTTER_INSTALL_DIR" ]; then
        mark_step_completed "$step_name"
        return 0
    fi

    # Create parent directory
    local parent_dir
    parent_dir="$(dirname "$FLUTTER_INSTALL_DIR")"
    mkdir -p "$parent_dir"

    log_info "Cloning Flutter SDK to: $FLUTTER_INSTALL_DIR"
    log_warning "This may take several minutes..."

    git clone https://github.com/flutter/flutter.git \
        -b "${FLUTTER_CHANNEL:-stable}" \
        --depth 1 \
        "$FLUTTER_INSTALL_DIR"

    # Add to PATH temporarily
    export PATH="$FLUTTER_INSTALL_DIR/bin:$PATH"

    log_info "Precaching iOS artifacts..."
    "$FLUTTER_INSTALL_DIR/bin/flutter" precache --ios

    log_success "Flutter SDK installed at: $FLUTTER_INSTALL_DIR"
    save_installation_info "flutter_path" "$FLUTTER_INSTALL_DIR"
    mark_step_completed "$step_name"
}

# Configure shell environment
configure_shell_environment() {
    local step_name="shell_config"

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Shell configuration (already configured)"
        return 0
    fi

    log_step 5 $TOTAL_STEPS "Configuring Shell Environment"

    local shell_config
    shell_config=$(get_shell_config_file)

    log_info "Configuring $shell_config"

    # Backup existing config
    backup_file "$shell_config"

    # Add Flutter to PATH
    local flutter_config="
# Flutter Development Environment (added by flutter-ios-setup)
export FLUTTER_HOME=\"$FLUTTER_INSTALL_DIR\"
export PATH=\"\$FLUTTER_HOME/bin:\$PATH\"
export PATH=\"\$FLUTTER_HOME/bin/cache/dart-sdk/bin:\$PATH\"
export PATH=\"\$HOME/.pub-cache/bin:\$PATH\"

# iOS Development
export GEM_HOME=\"\$HOME/.gem\"
export PATH=\"\$GEM_HOME/bin:\$PATH\"
"

    if ! grep -q "FLUTTER_HOME" "$shell_config" 2>/dev/null; then
        echo "$flutter_config" >> "$shell_config"
        log_success "Added Flutter to $shell_config"
    else
        log_info "Flutter already configured in $shell_config"
    fi

    # Source for current session
    export PATH="$FLUTTER_INSTALL_DIR/bin:$PATH"

    log_success "Shell environment configured"
    log_warning "Restart your terminal or run: source $shell_config"
    mark_step_completed "$step_name"
}

# Install CocoaPods
install_cocoapods() {
    local step_name="cocoapods"

    if [ "${INSTALL_COCOAPODS:-true}" != "true" ]; then
        log_info "Skipping: CocoaPods (disabled in config)"
        return 0
    fi

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: CocoaPods (already installed)"
        return 0
    fi

    log_step 6 $TOTAL_STEPS "Installing CocoaPods"

    if check_cocoapods; then
        mark_step_completed "$step_name"
        return 0
    fi

    log_info "Installing CocoaPods via Homebrew..."
    brew install cocoapods

    log_info "Setting up CocoaPods..."
    pod setup --silent

    log_success "CocoaPods installed successfully"
    mark_step_completed "$step_name"
}

# Install iOS development tools
install_ios_tools() {
    local step_name="ios_tools"

    if [ "${INSTALL_IOS_TOOLS:-true}" != "true" ]; then
        log_info "Skipping: iOS tools (disabled in config)"
        return 0
    fi

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: iOS tools (already installed)"
        return 0
    fi

    log_step 7 $TOTAL_STEPS "Installing iOS Development Tools"

    log_info "Installing ios-deploy..."
    brew install ios-deploy 2>/dev/null || true

    log_info "Installing libimobiledevice..."
    brew install libimobiledevice 2>/dev/null || true

    log_info "Installing ideviceinstaller..."
    brew install ideviceinstaller 2>/dev/null || true

    log_success "iOS development tools installed"
    mark_step_completed "$step_name"
}

# Run Flutter Doctor
run_flutter_doctor() {
    local step_name="flutter_doctor"

    log_step 8 $TOTAL_STEPS "Running Flutter Doctor"

    export PATH="$FLUTTER_INSTALL_DIR/bin:$PATH"

    log_separator
    flutter doctor -v
    log_separator

    mark_step_completed "$step_name"
}

# Create test project
create_test_project() {
    local step_name="test_project"

    if [ "${CREATE_TEST_PROJECT:-true}" != "true" ]; then
        log_info "Skipping: Test project creation (disabled in config)"
        return 0
    fi

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Test project (already created)"
        return 0
    fi

    log_step 9 $TOTAL_STEPS "Creating Test Project"

    local project_dir="${TEST_PROJECT_DIR}/${TEST_PROJECT_NAME}"

    if [ -d "$project_dir" ]; then
        log_warning "Project already exists: $project_dir"
        if ! ask_user_confirmation "Recreate project?"; then
            mark_step_completed "$step_name"
            return 0
        fi
        rm -rf "$project_dir"
    fi

    log_info "Creating Flutter project: $TEST_PROJECT_NAME"

    cd "$TEST_PROJECT_DIR"
    flutter create "$TEST_PROJECT_NAME" \
        --org "$TEST_PROJECT_ORG" \
        --platforms=ios

    cd "$TEST_PROJECT_NAME"

    log_info "Getting Flutter dependencies..."
    flutter pub get

    log_info "Installing iOS dependencies..."
    if [ -f "ios/Podfile" ]; then
        cd ios
        pod install
        cd ..
    else
        log_warning "Podfile not found - will be auto-generated on first build"
        log_info "Run 'flutter run' to automatically install iOS dependencies"
    fi

    log_success "Test project created at: $project_dir"
    mark_step_completed "$step_name"
}

# Setup development convenience features
setup_dev_tools() {
    local step_name="dev_tools"

    if [ "${SKIP_COMPLETED_STEPS:-true}" = "true" ] && is_step_completed "$step_name"; then
        log_info "Skipping: Development tools (already configured)"
        return 0
    fi

    log_step 10 $TOTAL_STEPS "Setting up Development Tools"

    # 1. Code Quality Tools
    if [ "${SETUP_CODE_QUALITY_TOOLS:-true}" = "true" ]; then
        setup_code_quality_tools
    fi

    # 2. VSCode Settings
    if [ "${SETUP_VSCODE_SETTINGS:-true}" = "true" ]; then
        setup_vscode_dev_environment
    fi

    # 3. Flutter Aliases
    if [ "${SETUP_FLUTTER_ALIASES:-true}" = "true" ]; then
        setup_flutter_command_aliases
    fi

    # 4. Git Hooks
    if [ "${SETUP_GIT_HOOKS:-true}" = "true" ]; then
        setup_git_commit_hooks
    fi

    log_success "Development tools configured"
    mark_step_completed "$step_name"
}

# Setup code quality tools (analysis_options.yaml)
setup_code_quality_tools() {
    log_info "Setting up Code Quality Tools..."

    local template_file="${SCRIPT_DIR}/templates/analysis_options.yaml"

    if [ ! -f "$template_file" ]; then
        log_warning "Code quality template not found: $template_file"
        return 1
    fi

    # Apply to test project if it exists
    if [ "${CREATE_TEST_PROJECT:-true}" = "true" ]; then
        local project_dir="${TEST_PROJECT_DIR}/${TEST_PROJECT_NAME}"

        if [ -d "$project_dir" ]; then
            local dest_file="${project_dir}/analysis_options.yaml"

            if copy_template "$template_file" "$dest_file" "Enhanced analysis_options.yaml"; then
                log_info "Run 'flutter analyze' in your project to see static analysis results"
            fi
        fi
    fi

    log_success "Code quality tools configured"
}

# Setup VSCode development environment
setup_vscode_dev_environment() {
    log_info "Setting up VSCode Development Environment..."

    # Check if VSCode is installed (optional)
    if ! check_vscode; then
        log_info "VSCode not detected. You can install it later from: https://code.visualstudio.com/"
        log_info "VSCode settings will still be created for future use."
    fi

    # Setup workspace for test project
    if [ "${CREATE_TEST_PROJECT:-true}" = "true" ]; then
        local project_dir="${TEST_PROJECT_DIR}/${TEST_PROJECT_NAME}"

        if [ -d "$project_dir" ]; then
            setup_vscode_workspace "$project_dir"
            log_info "Open project in VSCode: code $project_dir"
        fi
    fi

    log_success "VSCode development environment configured"
}

# Setup Flutter command aliases
setup_flutter_command_aliases() {
    log_info "Setting up Flutter Command Aliases..."

    if add_flutter_aliases; then
        log_info "Available aliases: fl, flr, fld, fla, flf, and more"
        log_info "Run 'source $(get_shell_config_file)' or restart terminal to use aliases"
    else
        log_warning "Failed to add Flutter aliases"
        return 1
    fi

    log_success "Flutter command aliases configured"
}

# Setup Git commit hooks
setup_git_commit_hooks() {
    log_info "Setting up Git Commit Hooks..."

    # Install hooks for test project
    if [ "${CREATE_TEST_PROJECT:-true}" = "true" ]; then
        local project_dir="${TEST_PROJECT_DIR}/${TEST_PROJECT_NAME}"

        if [ -d "$project_dir" ]; then
            if install_git_hooks "$project_dir"; then
                log_info "Pre-commit hook will auto-format code and run analysis"

                if [ "${GIT_HOOKS_STRICT:-true}" = "true" ]; then
                    log_info "Strict mode: commits will fail if analysis finds issues"
                else
                    log_info "Permissive mode: commits allowed even with warnings"
                fi
            else
                log_warning "Failed to install git hooks"
                return 1
            fi
        fi
    fi

    log_success "Git commit hooks configured"
}

# ==============================================================================
# Main Setup Flow
# ==============================================================================

main() {
    # Ensure not running as root
    ensure_not_root

    # Print header
    log_header "Flutter iOS Development Environment Setup v${SETUP_VERSION}"
    log_info "Log file: $LOG_FILE"
    log_info "State file: $STATE_FILE"
    echo ""

    # Initialize state file
    init_state_file

    # Perform system checks
    if [ "${PERFORM_SYSTEM_CHECKS:-true}" = "true" ]; then
        log_step 0 $TOTAL_STEPS "System Requirements Check"
        if ! perform_system_checks; then
            log_error "System checks failed. Please resolve issues and try again."
            exit 1
        fi
        echo ""
    fi

    # Run installation steps
    install_homebrew
    install_xcode_cli_tools
    setup_xcode
    install_flutter_sdk
    configure_shell_environment
    install_cocoapods
    install_ios_tools
    run_flutter_doctor
    create_test_project
    setup_dev_tools

    # Cleanup old logs
    cleanup_old_logs

    # Print summary
    log_header "Setup Complete!"
    log_success "Flutter iOS development environment is ready"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal (or run: source $(get_shell_config_file))"
    echo "  2. Verify installation: flutter doctor"
    echo "  3. Run verification script: ./scripts/verify.sh"
    if [ "${CREATE_TEST_PROJECT:-true}" = "true" ]; then
        echo "  4. Test app in simulator: cd ${TEST_PROJECT_NAME} && flutter run"
    fi
    echo ""
    echo "For device connection, see: docs/DEVICE-CONNECTION.md"
    echo "For troubleshooting, see: docs/TROUBLESHOOTING.md"
    echo ""
}

# Run main function
main "$@"
