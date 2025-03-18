#!/bin/bash

# Try to find a suitable terminal
TERMINAL=""

# Check for various terminals in order of preference
if command -v ghostty &> /dev/null; then
    TERMINAL="ghostty"
elif command -v alacritty &> /dev/null; then
    TERMINAL="alacritty"
elif command -v kitty &> /dev/null; then
    TERMINAL="kitty"
elif command -v xterm &> /dev/null; then
    TERMINAL="xterm"
elif command -v gnome-terminal &> /dev/null; then
    TERMINAL="gnome-terminal -- "
elif command -v konsole &> /dev/null; then
    TERMINAL="konsole -e"
fi

if [ -z "$TERMINAL" ]; then
    notify-send "Error" "No suitable terminal found to run updates"
    exit 1
fi

# Run the update command with the chosen terminal
# Using nohup and disown to completely detach from eww process
if [ "$TERMINAL" = "ghostty" ]; then
    # Different syntax for ghostty
    nohup $TERMINAL -e "sudo pacman -Syu; echo 'Press any key to exit...'; read" > /dev/null 2>&1 &
elif [ "$TERMINAL" = "gnome-terminal -- " ]; then
    # Different syntax for gnome-terminal
    nohup $TERMINAL bash -c "sudo pacman -Syu; echo 'Press any key to exit...'; read" > /dev/null 2>&1 &
else
    # Standard syntax for most terminals
    nohup $TERMINAL -e bash -c "sudo pacman -Syu; echo 'Press any key to exit...'; read" > /dev/null 2>&1 &
fi

disown
