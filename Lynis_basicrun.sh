#!/bin/bash

# Lynis Security Audit Script
# Version: 1.0
# Description: Optimized script to run Lynis security audits with error handling and logging

# Configuration
LOG_DIR="/var/log/lynis"
LOG_FILE="$LOG_DIR/lynis_audit_$(date +%Y%m%d_%H%M%S).log"
LYNIS_BIN=$(command -v lynis 2>/dev/null)
TEMP_DIR="/tmp/lynis_temp"
MAX_PARALLEL_JOBS=3

# Audit categories to run
AUDIT_CATEGORIES=(
  "system"
  "security-policy"
  "hardening"
  "patch-management"
  "malware"
  "rogue-software"
  "intrusion-detection"
  "configuration-issues"
  "vulnerabilities"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display messages
log_message() {
  local level="$1"
  local message="$2"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  
  case "$level" in
    "INFO")  color="$GREEN" ;;
    "WARN")  color="$YELLOW" ;;
    "ERROR") color="$RED" ;;
    *)       color="$NC" ;;
  esac
  
  echo -e "${color}[${timestamp}] ${level}: ${message}${NC}" | tee -a "$LOG_FILE"
}

# Function to check prerequisites
check_prerequisites() {
  # Check if Lynis is installed
  if [ -z "$LYNIS_BIN" ]; then
    log_message "ERROR" "Lynis not found. Please install Lynis first."
    exit 1
  fi

  # Check if running as root
  if [ "$(id -u)" != "0" ]; then
    log_message "ERROR" "This script must be run as root."
    exit 1
  fi

  # Create log directory if it doesn't exist
  mkdir -p "$LOG_DIR" || {
    log_message "ERROR" "Failed to create log directory: $LOG_DIR"
    exit 1
  }

  # Create temporary directory
  mkdir -p "$TEMP_DIR" || {
    log_message "ERROR" "Failed to create temporary directory: $TEMP_DIR"
    exit 1
  }
}

# Function to run a single audit
run_audit() {
  local category="$1"
  local output_file="$TEMP_DIR/lynis_${category}.out"
  
  log_message "INFO" "Starting audit for category: $category"
  
  if ! "$LYNIS_BIN" audit --tests-from-group "$category" > "$output_file" 2>&1; then
    log_message "ERROR" "Audit failed for category: $category. Check $output_file for details."
  else
    log_message "INFO" "Audit completed for category: $category. Results in $output_file"
  fi
}

# Function to clean up
cleanup() {
  log_message "INFO" "Cleaning up temporary files..."
  rm -rf "$TEMP_DIR"
}

# Trap for cleanup on script exit
trap cleanup EXIT

# Main function
main() {
  log_message "INFO" "Starting Lynis security audit..."

  # Check prerequisites
  check_prerequisites

  # Run audits in parallel with limited concurrency
  for category in "${AUDIT_CATEGORIES[@]}"; do
    # Limit number of parallel jobs
    while [ "$(jobs -r | wc -l)" -ge "$MAX_PARALLEL_JOBS" ]; do
      sleep 1
    done
    
    run_audit "$category" &
  done

  # Wait for all background jobs to complete
  wait

  log_message "INFO" "All audits completed. Logs saved to $LOG_FILE"
  log_message "INFO" "Detailed results available in $TEMP_DIR"
}

# Execute main function
main
