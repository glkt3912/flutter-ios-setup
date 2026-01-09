#!/bin/bash
# Logger Library for Flutter iOS Setup
# Provides colored output and logging functionality

# Color codes for terminal output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Log levels
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARNING=2
readonly LOG_LEVEL_ERROR=3

# Default log level (can be overridden by config)
CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO}

# Set log level from string
# Usage: set_log_level "DEBUG"
set_log_level() {
    case "${1:-INFO}" in
        DEBUG)
            CURRENT_LOG_LEVEL=$LOG_LEVEL_DEBUG
            ;;
        INFO)
            CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO
            ;;
        WARNING)
            CURRENT_LOG_LEVEL=$LOG_LEVEL_WARNING
            ;;
        ERROR)
            CURRENT_LOG_LEVEL=$LOG_LEVEL_ERROR
            ;;
        *)
            CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO
            ;;
    esac
}

# Internal logging function
# Usage: _log <level> <level_num> <color> <message>
_log() {
    local level="$1"
    local level_num="$2"
    local color="$3"
    local message="$4"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    # Check if message should be logged based on log level
    if [ "$level_num" -ge "$CURRENT_LOG_LEVEL" ]; then
        # Print to terminal with color
        echo -e "${color}[${level}]${NC} ${message}"

        # Log to file without color codes (if LOG_FILE is set)
        if [ -n "${LOG_FILE:-}" ]; then
            echo "[${timestamp}] [${level}] ${message}" >> "$LOG_FILE"
        fi
    fi
}

# Log debug message
# Usage: log_debug "Debug message"
log_debug() {
    _log "DEBUG" $LOG_LEVEL_DEBUG "$CYAN" "$1"
}

# Log info message
# Usage: log_info "Info message"
log_info() {
    _log "INFO" $LOG_LEVEL_INFO "$BLUE" "$1"
}

# Log success message
# Usage: log_success "Success message"
log_success() {
    _log "SUCCESS" $LOG_LEVEL_INFO "$GREEN" "$1"
}

# Log warning message
# Usage: log_warning "Warning message"
log_warning() {
    _log "WARNING" $LOG_LEVEL_WARNING "$YELLOW" "$1"
}

# Log error message
# Usage: log_error "Error message"
log_error() {
    _log "ERROR" $LOG_LEVEL_ERROR "$RED" "$1"
}

# Print a separator line
# Usage: log_separator
log_separator() {
    echo "======================================================================"
}

# Print a header
# Usage: log_header "Header Text"
log_header() {
    echo ""
    log_separator
    echo -e "${MAGENTA}$1${NC}"
    log_separator
}

# Print a section
# Usage: log_section "Section Title"
log_section() {
    echo ""
    echo -e "${CYAN}>>> $1${NC}"
}

# Print a step
# Usage: log_step <step_num> <total_steps> "Step description"
log_step() {
    local step_num="$1"
    local total_steps="$2"
    local description="$3"
    echo ""
    echo -e "${BLUE}[${step_num}/${total_steps}]${NC} ${description}"
}

# Ask user for confirmation
# Usage: if ask_user_confirmation "Continue?"; then ... fi
# Returns: 0 (true) if user confirms, 1 (false) otherwise
ask_user_confirmation() {
    local prompt="${1:-Continue?}"
    local response

    # If AUTO_ACCEPT is enabled, always return true
    if [ "${AUTO_ACCEPT:-false}" = "true" ]; then
        log_debug "Auto-accepting prompt: $prompt"
        return 0
    fi

    echo -n "$prompt [y/N]: "
    read -r response

    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Print spinner while a command runs
# Usage: show_spinner <pid> "Loading message"
show_spinner() {
    local pid=$1
    local message="${2:-Processing...}"
    local spin='-\|/'
    local i=0

    echo -n "$message "
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${message} ${spin:$i:1}"
        sleep .1
    done
    printf "\r${message} Done\n"
}

# Print progress bar
# Usage: print_progress <current> <total> "Message"
print_progress() {
    local current=$1
    local total=$2
    local message="${3:-Progress}"
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))

    printf "\r${message}: ["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%" "$percent"

    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# Log command execution
# Usage: log_command "command description" command arg1 arg2
log_command() {
    local description="$1"
    shift

    log_debug "Executing: $*"
    log_info "$description"

    if [ "$CURRENT_LOG_LEVEL" -le "$LOG_LEVEL_DEBUG" ]; then
        # In debug mode, show output
        "$@"
    else
        # In normal mode, suppress output
        "$@" >> "${LOG_FILE:-/dev/null}" 2>&1
    fi
}

# Initialize logger
# Call this after loading config to set log level
init_logger() {
    if [ -n "${LOG_LEVEL:-}" ]; then
        set_log_level "$LOG_LEVEL"
        log_debug "Log level set to: $LOG_LEVEL"
    fi
}
