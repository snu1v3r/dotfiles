#!/bin/bash

# Lock the screen
pidof hyprlock || hyprlock

# Ensure 1password is locked
if pgrep -x "keepassxc" >/dev/null; then
  keepassxc --lock
fi

# Avoid running screensaver when locked
pkill -f "alacritty --class Screensaver"
