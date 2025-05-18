#!/bin/bash

set -euo pipefail

# Default values
FILE_SIZE=""
NUM_FILES=""
INTERFACE="eth0"
AVG_PKT_SIZE=1
OUTPUT_PATH="/tmp"
LOG_PREFIX="[DumpOnator]"
VERSION="2.0"

function usage() {
  cat <<EOF
########################################################################
##                       DumpOnator $VERSION                        ##
##--------------------------- USAGE -------------------------------##
##   $0 -s <FileSizeMB> -n <NumFiles> [options]                    ##
##                                                                ##
## Required arguments:                                            ##
##   -s, --size       File size per capture (in MB)               ##
##   -n, --num        Number of files to create                   ##
##                                                                ##
## Optional arguments:                                            ##
##   -i, --interface  Capture interface (default: eth0)           ##
##   -p, --pkt-size   Average packet size (default: 1 byte)       ##
##   -o, --output     Output directory (default: /tmp)            ##
##   -h, --help       Show this help and exit                     ##
##                                                                ##
## Example:                                                       ##
##   $0 -s 10 -n 4 -i eth1 -o /captures                           ##
########################################################################
EOF
}

# Parse arguments
if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--size)      FILE_SIZE="$2"; shift 2 ;;
    -n|--num)       NUM_FILES="$2"; shift 2 ;;
    -i|--interface) INTERFACE="$2"; shift 2 ;;
    -o|--output)    OUTPUT_PATH="$2"; shift 2 ;;
    -p|--pkt-size)  AVG_PKT_SIZE="$2"; shift 2 ;;
    -h|--help)      usage; exit 0 ;;
    *) echo "Unknown argument: $1"; usage; exit 1 ;;
  esac
done

# Validate required arguments
ERRORS=()
if [[ -z "$FILE_SIZE" || ! "$FILE_SIZE" =~ ^[1-9][0-9]*$ ]]; then
  ERRORS+=("File size (-s) must be a positive integer (MB)")
fi
if [[ -z "$NUM_FILES" || ! "$NUM_FILES" =~ ^[1-9][0-9]*$ ]]; then
  ERRORS+=("Number of files (-n) must be a positive integer")
fi
if [[ ! "$AVG_PKT_SIZE" =~ ^[1-9][0-9]*$ ]]; then
  ERRORS+=("Average packet size (-p) must be a positive integer")
fi

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  usage
  for err in "${ERRORS[@]}"; do echo "  ERROR: $err"; done
  exit 1
fi

echo "$LOG_PREFIX Starting DumpOnator..."
echo "$LOG_PREFIX File size: $FILE_SIZE MB"
echo "$LOG_PREFIX Number of files: $NUM_FILES"
echo "$LOG_PREFIX Interface: $INTERFACE"
echo "$LOG_PREFIX Average packet size: $AVG_PKT_SIZE bytes"
echo "$LOG_PREFIX Output directory: $OUTPUT_PATH"

# Calculate total packets
TOTAL_PKTS=$((FILE_SIZE * NUM_FILES * 1024 * 1024 / AVG_PKT_SIZE))

# Check tcpdump presence
if ! command -v tcpdump > /dev/null; then
  echo "$LOG_PREFIX ERROR: tcpdump not found. Please install it."
  exit 1
fi

# Prepare output directory
mkdir -p "$OUTPUT_PATH"

CMD="tcpdump -n -C $FILE_SIZE -W $NUM_FILES -c $TOTAL_PKTS -i $INTERFACE -w $OUTPUT_PATH/packetcapture -s 65535"
echo "$LOG_PREFIX Running command: $CMD"
logger "$LOG_PREFIX $CMD"

$CMD
EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
  echo "$LOG_PREFIX Capture complete. Files saved in $OUTPUT_PATH"
else
  echo "$LOG_PREFIX Capture failed with exit code $EXIT_CODE"
fi