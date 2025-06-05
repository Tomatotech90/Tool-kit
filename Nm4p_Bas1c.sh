#!/bin/bash

# Nmap Basic Scan Script
# Version: 1.0
# Description: Optimized script to run Nmap scans with input validation, logging, and HTML conversion

# Configuration
LOG_DIR="/var/log/nmap_scans"
LOG_FILE="$LOG_DIR/nmap_scan_$(date +%Y%m%d_%H%M%S).log"
NMAP_BIN=$(command -v nmap 2>/dev/null)
XSLTPROC_BIN=$(command -v xsltproc 2>/dev/null)
OUTPUT_DIR="nmap_outputs"

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

# Function to validate IP address
validate_ip() {
  local ip="$1"
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    for octet in ${ip//./ }; do
      if [ "$octet" -gt 255 ] || [ "$octet" -lt 0 ]; then
        return 1
      fi
    done
    return 0
  else
    return 1
  fi
}

# Function to validate target name
validate_target_name() {
  local name="$1"
  if [[ $name =~ ^[a-zA-Z0-9_-]+$ ]]; then
    return 0
  else
    return 1
  fi
}

# Function to check prerequisites
check_prerequisites() {
  # Check if running as root
  if [ "$(id -u)" != "0" ]; then
    log_message "ERROR" "This script must be run as root for Nmap scans."
    exit 1
  }

  # Check if Nmap is installed
  if [ -z "$NMAP_BIN" ]; then
    log_message "ERROR" "Nmap not found. Please install Nmap first."
    exit 1
  }

  # Create log directory
  mkdir -p "$LOG_DIR" || {
    log_message "ERROR" "Failed to create log directory: $LOG_DIR"
    exit 1
  }

  # Create output directory
  mkdir -p "$OUTPUT_DIR" || {
    log_message "ERROR" "Failed to create output directory: $OUTPUT_DIR"
    exit 1
  }
}

# Function to run Nmap scan
run_nmap_scan() {
  local target_name="$1"
  local target_ip="$2"
  local use_pn="$3"
  local nmap_command

  if [ "$use_pn" = "yes" ]; then
    nmap_command="$NMAP_BIN -sCV --reason -oA $OUTPUT_DIR/$target_name -Pn $target_ip"
  else
    nmap_command="$NMAP_BIN -sCV --reason -oA $OUTPUT_DIR/$target_name $target_ip"
  }

  log_message "INFO" "Running Nmap scan with command: $nmap_command"
  if ! $nmap_command >> "$LOG_FILE" 2>&1; then
    log_message "ERROR" "Nmap scan failed. Check $LOG_FILE for details."
    return 1
  else
    log_message "INFO" "Nmap scan completed. Results saved in $OUTPUT_DIR/$target_name.*"
    return 0
  fi
}

# Function to convert XML to HTML
convert_to_html() {
  local target_name="$1"
  local xsltproc_command="$XSLTPROC_BIN $OUTPUT_DIR/$target_name.xml -o $OUTPUT_DIR/$target_name.html"

  if [ -z "$XSLTPROC_BIN" ]; then
    log_message "ERROR" "xsltproc not found. Please install xsltproc to convert to HTML."
    return 1
  fi

  log_message "INFO" "Converting XML to HTML with command: $xsltproc_command"
  if ! $xsltproc_command >> "$LOG_FILE" 2>&1; then
    log_message "ERROR" "HTML conversion failed. Check $LOG_FILE for details."
    return 1
  else
    log_message "INFO" "HTML conversion completed. Output saved to $OUTPUT_DIR/$target_name.html"
    return 0
  fi
}

# Main function
main() {
  log_message "INFO" "Starting Nmap scan script..."

  # Check prerequisites
  check_prerequisites

  # Get and validate target name
  while true; do
    read -p "Enter target name (alphanumeric, underscores, or hyphens only): " target_name
    if validate_target_name "$target_name"; then
      break
    else
      log_message "ERROR" "Invalid target name. Use only alphanumeric characters, underscores, or hyphens."
    fi
  done

  # Get and validate IP address
  while true; do
    read -p "Enter target IP address: " target_ip
    if validate_ip "$target_ip"; then
      break
    else
      log_message "ERROR" "Invalid IP address format. Please enter a valid IPv4 address."
    fi
  done

  # Get -Pn flag preference
  while true; do
    read -p "Add -Pn flag? (yes/no): " use_pn
    if [[ "$use_pn" =~ ^(yes|no)$ ]]; then
      break
    else
      log_message "ERROR" "Please enter 'yes' or 'no'."
    fi
  done

  # Run Nmap scan
  run_nmap_scan "$target_name" "$target_ip" "$use_pn" || exit 1

  # Convert to HTML if requested
  while true; do
    read -p "Convert to HTML using xsltproc? (yes/no): " use_xsltproc
    if [[ "$use_xsltproc" =~ ^(yes|no)$ ]]; then
      break
    else
      log_message "ERROR" "Please enter 'yes' or 'no'."
    fi
  done

  if [ "$use_xsltproc" = "yes" ]; then
    convert_to_html "$target_name" || exit 1
  fi

  log_message "INFO" "Script completed successfully."
}

# Execute main function
main
