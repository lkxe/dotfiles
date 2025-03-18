#!/bin/bash

# Default sink name - usually this is the default audio output
DEFAULT_SINK="@DEFAULT_AUDIO_SINK@"

# Function to get current volume
get_volume() {
  # Get volume using wpctl, grep for float value, convert to percentage
  VOLUME=$(wpctl get-volume $DEFAULT_SINK | grep -o '[0-9]*\.[0-9]*' | awk '{print int($1 * 100 + 0.5)}')
  echo $VOLUME
}

# Function to check if audio is muted
get_mute() {
  # Check if volume is muted
  MUTE=$(wpctl get-volume $DEFAULT_SINK | grep -c "MUTED")
  if [ "$MUTE" -eq 1 ]; then
    echo "yes"
  else
    echo "no"
  fi
}

# Function to toggle mute
toggle_mute() {
  wpctl set-mute $DEFAULT_SINK toggle
}

# Function to change volume
change_volume() {
  if [ "$1" = "up" ]; then
    wpctl set-volume $DEFAULT_SINK 5%+
  elif [ "$1" = "down" ]; then
    wpctl set-volume $DEFAULT_SINK 5%-
  fi
}

# Function to set volume to a specific percentage
set_volume() {
  # Ensure percentage is within bounds
  local percentage=$1
  if [ "$percentage" -lt 0 ]; then
    percentage=0
  elif [ "$percentage" -gt 101 ]; then
    percentage=100  # Cap at 100 even though scale goes to 101
  fi

  # Make sure 101 is treated as 100
  if [ "$percentage" -eq 101 ]; then
    percentage=100
  fi

  # Convert percentage to decimal (0.0 to 1.0) as wpctl expects
  local decimal=$(echo "scale=2; $percentage/100" | bc)

  # Set volume to the calculated percentage
  wpctl set-volume $DEFAULT_SINK $decimal
}

# Main command handling
case "$1" in
  get-volume)
    get_volume
    ;;
  get-mute)
    get_mute
    ;;
  toggle-mute)
    toggle_mute
    ;;
  change-volume)
    change_volume $2
    ;;
  set-volume)
    set_volume $2
    ;;
  *)
    echo "Usage: $0 {get-volume|get-mute|toggle-mute|change-volume [up|down]|set-volume [0-100]}"
    exit 1
    ;;
esac

exit 0
