#!/bin/bash

# Count the number of available updates
# Using checkupdates command which is part of pacman-contrib
checkupdates | wc -l
