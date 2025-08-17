#!/bin/bash

# omarchy-theme-set: Set a theme, specified by its name.
# Usage: omarchy-theme-set <theme-name>

if [[ -z "$1" && "$1" != "CNCLD" ]]; then
  echo "Usage: theme-set <theme-name>" >&2
  exit 1
fi

THEMES_DIR="$HOME/.local/share/themes/"
CURRENT_THEME_DIR="$HOME/.config/theme/current/"

THEME_NAME=$(echo "$1" | sed -E 's/<[^>]+>//g' | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
THEME_PATH="$THEMES_DIR/$THEME_NAME"

# Check if the theme entered exists
if [[ ! -d "$THEME_PATH" ]]; then
  echo "Theme '$THEME_NAME' does not exist in $THEMES_DIR" >&2
  exit 2
fi

# Update theme symlinks
ln -nsf "$THEME_PATH" "$CURRENT_THEME_DIR"

# Change gnome modes
if [[ -f ~/.config/theme/current/light.mode ]]; then
  gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
else
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
fi

# Change gnome icon theme color
if [[ -f ~/.config/theme/current/icons.theme ]]; then
  gsettings set org.gnome.desktop.interface icon-theme "$(<~/.config/omarchy/current/theme/icons.theme)"
else
  gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"
fi

# Ensure new theme is picked up by bat
bat cache --build

# Trigger alacritty config reload
touch "$HOME/.config/alacritty/alacritty.toml"

# Restart components to apply new theme
pkill -SIGUSR2 btop
~/.local/bin/restart-waybar.sh
~/.local/bin/restart-swayosd.sh
makoctl reload
hyprctl reload
#
# Set new background
ln -nsf $(find "$HOME/.config/theme/current/backgrounds/" -type f | head -n 1) "$HOME/.config/theme/background"
pkill -x swaybg
setsid swaybg -i "$HOME/.config/theme/background" -m fill &
