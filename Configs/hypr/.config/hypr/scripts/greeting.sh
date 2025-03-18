#!/bin/bash

# Get the current hour
HOUR=$(date +%H)
NAME="Your Name"  # Change this to your name

# Set greeting based on time of day
if [ $HOUR -ge 5 ] && [ $HOUR -lt 12 ]; then
    echo "Good morning, $NAME"
elif [ $HOUR -ge 12 ] && [ $HOUR -lt 18 ]; then
    echo "Good afternoon, $NAME"
elif [ $HOUR -ge 18 ] && [ $HOUR -lt 22 ]; then
    echo "Good evening, $NAME"
else
    echo "Good night, $NAME"
fi
