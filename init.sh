#!/bin/bash
#
# AI-TEAM-TMUX - Initial Setup and Maintenance Script
# This script helps with initial setup and log management
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ai-team-tmux"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/ai-team-tmux"
LOG_DIR="${DATA_DIR}/logs"
RECORD_DIR="${DATA_DIR}/recordings"
CONFIG_FILE="${CONFIG_DIR}/config.conf"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Show usage
show_usage() {
    cat << EOF
AI-TEAM-TMUX - Setup and Maintenance Script

USAGE:
    ./init.sh [command]

COMMANDS:
    setup           Initial setup - create directories and config
    clean-logs      Remove log files older than 7 days
    clean-all-logs  Remove all log files
    clean-records   Remove recording files older than 7 days
    clean-all       Remove all logs and recordings
    status          Show current setup status
    help            Show this help message

EXAMPLES:
    ./init.sh setup         # Initial setup
    ./init.sh clean-logs    # Clean old logs
    ./init.sh status        # Check setup status

EOF
}

# Initial setup
setup() {
    print_info "Starting AI-Team-TMUX initial setup..."
    
    # Create directories
    print_info "Creating directories..."
    mkdir -p "$CONFIG_DIR" "$LOG_DIR" "$RECORD_DIR"
    print_success "Directories created"
    
    # Create config file if it doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        print_info "Creating configuration file..."
        cat > "$CONFIG_FILE" << EOF
# AI-Team-TMUX Configuration
# Generated on: $(date)

# Default session name (do not modify - use command line argument instead)
# DEFAULT_SESSION_NAME="ai-team-tmux"

# Enable logging (yes/no)
ENABLE_LOGGING="yes"

# Enable session recording (yes/no)
ENABLE_RECORDING="no"

# Log level (info/debug)
LOG_LEVEL="info"

# Keep logs for this many days (0 = keep forever)
LOG_RETENTION_DAYS="7"

# Keep recordings for this many days (0 = keep forever)
RECORD_RETENTION_DAYS="3"

# Custom AI commands (uncomment to override)
# AI_CLAUDE_CMD="claude"
# AI_CURSOR_CMD="cursor-agent"
# AI_CODEX_CMD="codex"
# AI_GEMINI_CMD="gemini"
EOF
        print_success "Configuration file created at: $CONFIG_FILE"
    else
        print_info "Configuration file already exists"
    fi
    
    # Check for required dependencies
    print_info "Checking dependencies..."
    local missing_deps=()
    
    command -v tmux >/dev/null 2>&1 || missing_deps+=("tmux")
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_warning "Missing dependencies: ${missing_deps[*]}"
        print_info "Please install missing dependencies to use AI-Team-TMUX"
    else
        print_success "All required dependencies are installed"
    fi
    
    # Check for AI CLIs
    print_info "Checking for AI CLIs..."
    local found_ais=()
    
    command -v claude >/dev/null 2>&1 && found_ais+=("claude")
    command -v cursor-agent >/dev/null 2>&1 && found_ais+=("cursor-agent")
    command -v codex >/dev/null 2>&1 && found_ais+=("codex")
    command -v gemini >/dev/null 2>&1 && found_ais+=("gemini")
    
    if [ ${#found_ais[@]} -gt 0 ]; then
        print_success "Found AI CLIs: ${found_ais[*]}"
    else
        print_warning "No AI CLIs found. AI-Team-TMUX will create sessions with available CLIs only."
    fi
    
    # Make main script executable
    if [ -f "ai-team-tmux" ]; then
        chmod +x ai-team-tmux
        print_success "Main script is executable"
    fi
    
    print_success "Setup completed successfully!"
    echo ""
    echo "You can now run: ./ai-team-tmux"
}

# Clean old logs
clean_logs() {
    local days="${1:-7}"
    print_info "Cleaning log files older than $days days..."
    
    if [ -d "$LOG_DIR" ]; then
        local count=$(find "$LOG_DIR" -name "*.log" -type f -mtime +$days 2>/dev/null | wc -l)
        if [ "$count" -gt 0 ]; then
            find "$LOG_DIR" -name "*.log" -type f -mtime +$days -delete
            print_success "Removed $count old log file(s)"
        else
            print_info "No old log files to remove"
        fi
    else
        print_warning "Log directory does not exist"
    fi
}

# Clean all logs
clean_all_logs() {
    print_warning "This will remove ALL log files. Continue? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if [ -d "$LOG_DIR" ]; then
            local count=$(find "$LOG_DIR" -name "*.log" -type f 2>/dev/null | wc -l)
            rm -f "$LOG_DIR"/*.log 2>/dev/null || true
            print_success "Removed $count log file(s)"
        else
            print_warning "Log directory does not exist"
        fi
    else
        print_info "Cancelled"
    fi
}

# Clean old recordings
clean_records() {
    local days="${1:-3}"
    print_info "Cleaning recording files older than $days days..."
    
    if [ -d "$RECORD_DIR" ]; then
        local count=$(find "$RECORD_DIR" -name "*.rec" -type f -mtime +$days 2>/dev/null | wc -l)
        if [ "$count" -gt 0 ]; then
            find "$RECORD_DIR" -name "*.rec" -type f -mtime +$days -delete
            print_success "Removed $count old recording file(s)"
        else
            print_info "No old recording files to remove"
        fi
    else
        print_warning "Recording directory does not exist"
    fi
}

# Clean everything
clean_all() {
    print_warning "This will remove ALL logs and recordings. Continue? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        clean_all_logs
        if [ -d "$RECORD_DIR" ]; then
            local count=$(find "$RECORD_DIR" -name "*.rec" -type f 2>/dev/null | wc -l)
            rm -f "$RECORD_DIR"/*.rec 2>/dev/null || true
            print_success "Removed $count recording file(s)"
        fi
    else
        print_info "Cancelled"
    fi
}

# Show status
status() {
    echo "AI-TEAM-TMUX Status"
    echo "==================="
    echo ""
    
    # Check directories
    echo "Directories:"
    [ -d "$CONFIG_DIR" ] && echo "  ✓ Config: $CONFIG_DIR" || echo "  ✗ Config: $CONFIG_DIR (not found)"
    [ -d "$LOG_DIR" ] && echo "  ✓ Logs: $LOG_DIR" || echo "  ✗ Logs: $LOG_DIR (not found)"
    [ -d "$RECORD_DIR" ] && echo "  ✓ Recordings: $RECORD_DIR" || echo "  ✗ Recordings: $RECORD_DIR (not found)"
    echo ""
    
    # Check config file
    echo "Configuration:"
    if [ -f "$CONFIG_FILE" ]; then
        echo "  ✓ Config file exists"
        source "$CONFIG_FILE" 2>/dev/null || true
        echo "  - Logging: ${ENABLE_LOGGING:-yes}"
        echo "  - Recording: ${ENABLE_RECORDING:-no}"
    else
        echo "  ✗ Config file not found"
    fi
    echo ""
    
    # Check logs
    if [ -d "$LOG_DIR" ]; then
        local log_count=$(find "$LOG_DIR" -name "*.log" -type f 2>/dev/null | wc -l)
        local log_size=$(du -sh "$LOG_DIR" 2>/dev/null | cut -f1)
        echo "Logs:"
        echo "  - Files: $log_count"
        echo "  - Total size: ${log_size:-0}"
        
        if [ "$log_count" -gt 0 ]; then
            echo "  - Latest logs:"
            ls -lt "$LOG_DIR"/*.log 2>/dev/null | head -3 | awk '{print "    " $9}'
        fi
    fi
    echo ""
    
    # Check recordings
    if [ -d "$RECORD_DIR" ]; then
        local rec_count=$(find "$RECORD_DIR" -name "*.rec" -type f 2>/dev/null | wc -l)
        local rec_size=$(du -sh "$RECORD_DIR" 2>/dev/null | cut -f1)
        echo "Recordings:"
        echo "  - Files: $rec_count"
        echo "  - Total size: ${rec_size:-0}"
    fi
    echo ""
    
    # Check tmux sessions
    echo "Active tmux sessions:"
    if tmux list-sessions 2>/dev/null | grep -E "^ai-team" > /dev/null; then
        tmux list-sessions 2>/dev/null | grep -E "^ai-team" | sed 's/^/  /'
    else
        echo "  No active AI-Team sessions"
    fi
}

# Main execution
case "${1:-help}" in
    setup)
        setup
        ;;
    clean-logs)
        clean_logs "${2:-7}"
        ;;
    clean-all-logs)
        clean_all_logs
        ;;
    clean-records)
        clean_records "${2:-3}"
        ;;
    clean-all)
        clean_all
        ;;
    status)
        status
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac