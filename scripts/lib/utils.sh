#!/bin/bash
# Utilities Library for Flutter iOS Setup
# Provides common utility functions

# Compare two semantic versions
# Usage: version_gte "1.2.3" "1.2.0" && echo "newer or equal"
# Returns: 0 (true) if version1 >= version2, 1 (false) otherwise
version_gte() {
    local version1="$1"
    local version2="$2"

    # Remove leading 'v' if present
    version1="${version1#v}"
    version2="${version2#v}"

    # Split versions into arrays
    IFS='.' read -ra v1_parts <<< "$version1"
    IFS='.' read -ra v2_parts <<< "$version2"

    # Compare each part
    for i in {0..2}; do
        local part1="${v1_parts[$i]:-0}"
        local part2="${v2_parts[$i]:-0}"

        if [ "$part1" -gt "$part2" ]; then
            return 0
        elif [ "$part1" -lt "$part2" ]; then
            return 1
        fi
    done

    # Versions are equal
    return 0
}

# Backup a file with timestamp
# Usage: backup_file "/path/to/file"
backup_file() {
    local file_path="$1"
    local backup_path="${file_path}.backup.$(date +%Y%m%d-%H%M%S)"

    if [ -f "$file_path" ]; then
        cp "$file_path" "$backup_path"
        log_debug "Backed up: $file_path -> $backup_path"
        return 0
    else
        log_warning "File not found for backup: $file_path"
        return 1
    fi
}

# Detect current shell
# Usage: SHELL_TYPE=$(detect_shell)
# Returns: "zsh", "bash", or "unknown"
detect_shell() {
    if [ -n "${ZSH_VERSION:-}" ]; then
        echo "zsh"
    elif [ -n "${BASH_VERSION:-}" ]; then
        echo "bash"
    else
        echo "unknown"
    fi
}

# Get shell config file path
# Usage: shell_config=$(get_shell_config_file)
get_shell_config_file() {
    local shell_type
    shell_type=$(detect_shell)

    case "$shell_type" in
        zsh)
            echo "$HOME/.zshrc"
            ;;
        bash)
            if [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            log_error "Unknown shell type: $shell_type"
            return 1
            ;;
    esac
}

# Initialize state file
# Usage: init_state_file
init_state_file() {
    if [ ! -f "$STATE_FILE" ]; then
        local os_version
        local arch
        local shell_type
        local username

        os_version=$(sw_vers -productVersion)
        arch=$(uname -m)
        shell_type=$(detect_shell)
        username=$(whoami)

        cat > "$STATE_FILE" <<EOF
{
  "setup_version": "1.0.0",
  "last_run": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "system_info": {
    "os_version": "${os_version}",
    "arch": "${arch}",
    "shell": "${shell_type}",
    "user": "${username}"
  },
  "completed_steps": [],
  "installations": {}
}
EOF
        log_debug "Initialized state file: $STATE_FILE"
    fi
}

# Check if a step is completed
# Usage: is_step_completed "flutter_sdk" && echo "already done"
# Returns: 0 (true) if step is completed, 1 (false) otherwise
is_step_completed() {
    local step_name="$1"

    if [ ! -f "$STATE_FILE" ]; then
        return 1
    fi

    # Check if step is in completed_steps array
    if command -v jq &> /dev/null; then
        # Use jq if available (more reliable)
        jq -e ".completed_steps | index(\"$step_name\")" "$STATE_FILE" > /dev/null 2>&1
    else
        # Fallback to grep (less reliable but works)
        grep -q "\"$step_name\"" "$STATE_FILE"
    fi
}

# Mark a step as completed
# Usage: mark_step_completed "flutter_sdk"
mark_step_completed() {
    local step_name="$1"

    if [ ! -f "$STATE_FILE" ]; then
        init_state_file
    fi

    # Update last_run timestamp
    local temp_file="${STATE_FILE}.tmp"

    if command -v jq &> /dev/null; then
        # Use jq if available
        jq ".last_run = \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\" | .completed_steps += [\"$step_name\"] | .completed_steps |= unique" "$STATE_FILE" > "$temp_file"
        mv "$temp_file" "$STATE_FILE"
    else
        # Fallback: simple append (may create duplicates)
        sed "s/\"completed_steps\": \[\(.*\)\]/\"completed_steps\": [\1, \"$step_name\"]/" "$STATE_FILE" > "$temp_file"
        mv "$temp_file" "$STATE_FILE"
    fi

    log_debug "Marked step as completed: $step_name"
}

# Save installation info to state file
# Usage: save_installation_info "flutter_version" "3.16.0"
save_installation_info() {
    local key="$1"
    local value="$2"

    if [ ! -f "$STATE_FILE" ]; then
        init_state_file
    fi

    local temp_file="${STATE_FILE}.tmp"

    if command -v jq &> /dev/null; then
        jq ".installations.${key} = \"${value}\"" "$STATE_FILE" > "$temp_file"
        mv "$temp_file" "$STATE_FILE"
    fi

    log_debug "Saved installation info: $key = $value"
}

# Get available disk space in GB
# Usage: disk_space=$(get_available_disk_space "/")
get_available_disk_space() {
    local path="${1:-/}"
    df -g "$path" | tail -1 | awk '{print $4}'
}

# Check if a command exists
# Usage: command_exists "flutter" && echo "found"
# Returns: 0 (true) if command exists, 1 (false) otherwise
command_exists() {
    command -v "$1" &> /dev/null
}

# Wait for a process to complete with timeout
# Usage: wait_for_process <pid> <timeout_seconds>
# Returns: 0 if process completed, 1 if timeout
wait_for_process() {
    local pid=$1
    local timeout=${2:-300}  # Default 5 minutes
    local elapsed=0

    while kill -0 "$pid" 2>/dev/null; do
        if [ $elapsed -ge $timeout ]; then
            log_error "Process timeout after ${timeout}s"
            return 1
        fi
        sleep 1
        ((elapsed++))
    done

    return 0
}

# Clean old log files
# Usage: cleanup_old_logs
cleanup_old_logs() {
    if [ -d "$LOG_DIR" ]; then
        local keep_days="${KEEP_LOGS_DAYS:-30}"
        find "$LOG_DIR" -name "*.log" -type f -mtime "+${keep_days}" -delete 2>/dev/null
        log_debug "Cleaned up log files older than ${keep_days} days"
    fi
}

# Download file with retry
# Usage: download_with_retry "https://example.com/file" "/path/to/save"
# Returns: 0 on success, 1 on failure
download_with_retry() {
    local url="$1"
    local output="$2"
    local max_retries=3
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        if curl -fsSL "$url" -o "$output"; then
            log_debug "Download successful: $url"
            return 0
        else
            ((retry_count++))
            log_warning "Download failed (attempt $retry_count/$max_retries): $url"
            sleep 2
        fi
    done

    log_error "Download failed after $max_retries attempts: $url"
    return 1
}

# Check internet connectivity
# Usage: check_internet && echo "connected"
# Returns: 0 if internet is available, 1 otherwise
check_internet() {
    if ping -c 1 -t 5 google.com &> /dev/null || \
       ping -c 1 -t 5 1.1.1.1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Get macOS version
# Usage: macos_version=$(get_macos_version)
get_macos_version() {
    sw_vers -productVersion
}

# Get system architecture
# Usage: arch=$(get_system_arch)
# Returns: "arm64" or "x86_64"
get_system_arch() {
    uname -m
}

# Check if running on Apple Silicon
# Usage: is_apple_silicon && echo "M-series Mac"
# Returns: 0 if Apple Silicon, 1 otherwise
is_apple_silicon() {
    [ "$(get_system_arch)" = "arm64" ]
}

# Add line to file if not exists
# Usage: add_line_to_file "export PATH=..." "$HOME/.zshrc"
add_line_to_file() {
    local line="$1"
    local file="$2"

    # Create file if it doesn't exist
    touch "$file"

    # Add line if it doesn't exist
    if ! grep -qF "$line" "$file"; then
        echo "$line" >> "$file"
        log_debug "Added line to $file"
        return 0
    else
        log_debug "Line already exists in $file"
        return 1
    fi
}

# Check if running with sudo/root
# Usage: is_root && echo "running as root"
# Returns: 0 if root, 1 otherwise
is_root() {
    [ "$(id -u)" -eq 0 ]
}

# Ensure script is not run as root (unless explicitly allowed)
# Usage: ensure_not_root
ensure_not_root() {
    if is_root; then
        log_error "This script should not be run as root or with sudo"
        log_info "Run as a regular user. The script will prompt for sudo when needed."
        exit 1
    fi
}

# Get Flutter version if installed
# Usage: flutter_version=$(get_flutter_version)
get_flutter_version() {
    if command_exists flutter; then
        flutter --version | head -n 1 | awk '{print $2}'
    else
        echo "not installed"
    fi
}

# Get Xcode version if installed
# Usage: xcode_version=$(get_xcode_version)
get_xcode_version() {
    if [ -d "/Applications/Xcode.app" ]; then
        /usr/bin/xcodebuild -version | head -n 1 | awk '{print $2}'
    else
        echo "not installed"
    fi
}
