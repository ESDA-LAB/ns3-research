#!/bin/bash

# ===========================
# Script Name: install.sh
# Description: NS3 installation script.
# Author: Konstantinos Antonopoulos
# Date: 2024-11-01
# Version: 0.1
# ===========================

# Exit immediately if a command exits with a non-zero status
set -e

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Try 'sudo $0'." 1>&2
   exit 1
fi

# Enable script variables.
DEBUG=false

# Functions
# Print usage information
usage() {
    echo "Usage: $0 [-h] [-d] [-f <filename>]"
    echo "Options:"
    echo "  -h          Show this help message"
    echo "  -d          Enable debug mode"
    exit 1
}

# Enable debug logging if DEBUG is true
log_debug() {
    if [ "$DEBUG" = true ]; then
        echo "[DEBUG] $1"
    fi
}

# Parse command-line arguments
while getopts "hdf:" opt; do
    case ${opt} in
        h )
            usage
            ;;
        d )
            DEBUG=true
            ;;
        \? )
            echo "Invalid option: -$OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Main script execution
main() {
    echo "NS3 installation started at $(date)"
    docker build -t esda-ns3:v3.42 -f ./docker/Dockerfile .
    echo "NS3 installation completed at $(date)"
}

# Execute main function
main
