#!/bin/bash

THEMES_DIR="$HOME/.local/share/themes/dynamic"
CURRENT_THEME_LINK="$HOME/.config/theme/current"

THEMES=($(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 | sort))
TOTAL=${#THEMES[@]}

# Get current theme from symlink
if [[ -L "$CURRENT_THEME_LINK" ]]; then
  CURRENT_THEME=$(realpath "$CURRENT_THEME_LINK")
else
  # Default to first theme if no symlink exists
  CURRENT_THEME=$(realpath "${THEMES[0]}")
fi

# Find current theme index
INDEX=0
for i in "${!THEMES[@]}"; do
  THEMES[$i]=$(realpath "${THEMES[$i]}")

  if [[ "${THEMES[$i]}" == "$CURRENT_THEME" ]]; then
    INDEX=$i
    break
  fi
done

# Get next theme (wrap around)
NEXT_INDEX=$(((INDEX + 1) % TOTAL))
NEW_THEME=${THEMES[$NEXT_INDEX]}
NEW_THEME_NAME=$(basename "$NEW_THEME")

~/.local/bin/theme-set.sh $NEW_THEME_NAME

# Notify of the new theme
notify-send "Theme changed to $NEW_THEME_NAME" -t 2000
