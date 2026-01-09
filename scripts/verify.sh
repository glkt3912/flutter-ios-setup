#!/bin/bash
# Flutter iOS Setup Verification Script
# Checks if the development environment is properly configured

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/logger.sh"
source "${SCRIPT_DIR}/lib/utils.sh"
source "${SCRIPT_DIR}/lib/checks.sh"

# Initialize
init_logger

log_header "Flutter iOS Development Environment Verification"

# Run checks
errors=0

check_flutter_sdk || ((errors++))
check_xcode_app || ((errors++))
check_cocoapods || ((errors++))
check_ios_tools || ((errors++))

echo ""
if [ $errors -eq 0 ]; then
    log_success "All checks passed!"
    exit 0
else
    log_error "$errors check(s) failed"
    exit 1
fi
