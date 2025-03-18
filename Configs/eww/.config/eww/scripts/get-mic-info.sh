#!/bin/bash
# Function to check if source is muted
get_source_mute() {
  if pactl get-source-mute @DEFAULT_SOURCE@ | grep -q "yes"; then
    echo "yes"
  else
    echo "no"
  fi
}

# Function to toggle source mute state
toggle_source_mute() {
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

# Main switch statement to handle command line arguments
case "$1" in
  "get-source-mute")
    get_source_mute
    ;;
  "toggle-source-mute")
    toggle_source_mute
    ;;
  *)
    echo "Usage: $0 {get-source-mute|toggle-source-mute}"
    exit 1
    ;;
esac
