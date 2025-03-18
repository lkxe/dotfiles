#!/bin/bash

# Function to check if a player is active
is_player_active() {
    local player="$1"
    playerctl -l 2>/dev/null | grep -q "$player"
    return $?
}

# Find active player with priority for Spotify
get_active_player() {
    if is_player_active "spotify"; then
        echo "spotify"
    else
        # Get first available player if any
        playerctl -l 2>/dev/null | head -n 1
    fi
}

# Get active player
PLAYER=$(get_active_player)

# Command handling based on argument
case "$1" in
    "status")
        if [ -n "$PLAYER" ]; then
            playerctl status -p "$PLAYER" 2>/dev/null || echo "Stopped"
        else
            echo "Stopped"
        fi
        ;;
    "play-pause")
        if [ -n "$PLAYER" ]; then
            playerctl play-pause -p "$PLAYER" 2>/dev/null
        fi
        ;;
    "title")
        if [ -n "$PLAYER" ]; then
            title=$(playerctl metadata -p "$PLAYER" title 2>/dev/null)
            echo "${title:0:50}"  # Cut to 50 chars max
        else
            echo ""
        fi
        ;;
    "next")
        if [ -n "$PLAYER" ]; then
            playerctl next -p "$PLAYER" 2>/dev/null
        fi
        ;;
    "previous")
        if [ -n "$PLAYER" ]; then
            playerctl previous -p "$PLAYER" 2>/dev/null
        fi
        ;;
    *)
        # Default action - status
        if [ -n "$PLAYER" ]; then
            playerctl status -p "$PLAYER" 2>/dev/null || echo "Stopped"
        else
            echo "Stopped"
        fi
        ;;
esac

exit 0
