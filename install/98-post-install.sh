#!/usr/bin/env bash

# Icons are placed in the correct location using the stow functionality
# This only ensures that the database is updated
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null || true # This catches a possible fail of the command

# Desktop files are placed in the correct location using the stow functionality
# This only ensures that the database is updated
update-desktop-database ~/.local/share/applications

# This ensures that the font cache is updated
fc-cache
sudo updatedb

# This removes directory's I never use
cd ~ && rm -rf Desktop Documents Music Pictures Public Templates Videos
