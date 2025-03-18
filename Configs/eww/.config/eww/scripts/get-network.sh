#!/bin/bash

# Directory to store network stats
STATS_DIR="/tmp/eww-network-stats"
mkdir -p "$STATS_DIR"

# Get default network interface name (the one with default route)
DEFAULT_INTERFACE=$(ip route | grep '^default' | head -n1 | awk '{print $5}')

# If no default interface found, try to find any active interface
if [ -z "$DEFAULT_INTERFACE" ]; then
    DEFAULT_INTERFACE=$(ip -o link show | grep 'state UP' | awk -F': ' '{print $2}' | head -n1)
fi

# If still no interface found, use the first non-loopback interface
if [ -z "$DEFAULT_INTERFACE" ]; then
    DEFAULT_INTERFACE=$(ip -o link show | grep -v 'LOOPBACK' | awk -F': ' '{print $2}' | head -n1)
fi

# If still nothing, default to "lo"
if [ -z "$DEFAULT_INTERFACE" ]; then
    DEFAULT_INTERFACE="lo"
fi

# File to store previous stats
PREV_FILE="$STATS_DIR/$DEFAULT_INTERFACE"

# Current timestamp
CURRENT_TIME=$(date +%s)

# Get current RX and TX bytes
RX_BYTES=$(cat "/sys/class/net/$DEFAULT_INTERFACE/statistics/rx_bytes" 2>/dev/null || echo 0)
TX_BYTES=$(cat "/sys/class/net/$DEFAULT_INTERFACE/statistics/tx_bytes" 2>/dev/null || echo 0)

# Create previous stats file if it doesn't exist
if [ ! -f "$PREV_FILE" ]; then
    echo "$CURRENT_TIME $RX_BYTES $TX_BYTES" > "$PREV_FILE"
    echo "0 KB/s"
    exit 0
fi

# Read previous stats
read -r PREV_TIME PREV_RX PREV_TX < "$PREV_FILE"

# Calculate time difference in seconds
TIME_DIFF=$((CURRENT_TIME - PREV_TIME))

# Avoid division by zero
if [ "$TIME_DIFF" -eq 0 ]; then
    TIME_DIFF=1
fi

# Calculate speed in bytes per second
RX_SPEED=$(( (RX_BYTES - PREV_RX) / TIME_DIFF ))
TX_SPEED=$(( (TX_BYTES - PREV_TX) / TIME_DIFF ))

# Save current stats for next time
echo "$CURRENT_TIME $RX_BYTES $TX_BYTES" > "$PREV_FILE"

# Format the output with appropriate units
format_speed() {
    local speed=$1

    if [ "$speed" -gt 1048576 ]; then  # > 1 MB/s
        echo "$(awk "BEGIN {printf \"%.1f\", $speed/1048576}") MB/s"
    elif [ "$speed" -gt 1024 ]; then   # > 1 KB/s
        echo "$(awk "BEGIN {printf \"%.1f\", $speed/1024}") KB/s"
    else                               # B/s
        echo "$speed B/s"
    fi
}

# Output the appropriate speed based on the argument
case "$1" in
    down)
        format_speed "$RX_SPEED"
        ;;
    up)
        format_speed "$TX_SPEED"
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

exit 0
