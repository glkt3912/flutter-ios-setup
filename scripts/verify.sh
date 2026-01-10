#!/bin/bash
# Flutter iOS Setup Verification Script
# Checks if the development environment is properly configured

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/logger.sh"
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/checks.sh"

# Initialize
init_logger

# Add Flutter to PATH if installed in default location
if [ -d "$HOME/development/flutter" ]; then
    export PATH="$HOME/development/flutter/bin:$PATH"
fi

log_header "Flutter iOS Development Environment Verification"

# Run checks
errors=0

check_flutter_sdk || ((errors++))
check_xcode_app || ((errors++))
check_cocoapods || ((errors++))
check_ios_tools || ((errors++))

# Development Tools Verification (optional)
echo ""
log_header "Development Tools Verification"

# Check VSCode (optional)
check_vscode || log_info "VSCode not installed (optional)"

# Check test project tools if it exists
TEST_PROJECT="${HOME}/flutter_test_app"
if [ -d "$TEST_PROJECT" ]; then
    log_info "Verifying test project development setup..."

    verify_analysis_options "$TEST_PROJECT" || log_info "Enhanced analysis_options.yaml not configured"
    verify_git_hooks "$TEST_PROJECT" || log_info "Git hooks not installed"

    if [ -d "$TEST_PROJECT/.vscode" ]; then
        log_success "VSCode workspace configured"
    else
        log_info "VSCode workspace not configured"
    fi
else
    log_info "Test project not found at $TEST_PROJECT"
fi

# Check Flutter aliases
if grep -q "Flutter Development Aliases" "$(get_shell_config_file)" 2>/dev/null; then
    log_success "Flutter command aliases configured"
else
    log_info "Flutter command aliases not configured"
fi

echo ""
if [ $errors -eq 0 ]; then
    log_success "All critical checks passed!"
    exit 0
else
    log_error "$errors check(s) failed"
    exit 1
fi
