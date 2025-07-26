# Icons are placed in the correct location using the stow functionality
# This only ensures that the database is updated
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null

# Desktop files are placed in the correct location using the stow functionality
# This only ensures that the database is updated
update-desktop-database ~/.local/share/applications

# This ensures that the font cache is updated
fc-cache
