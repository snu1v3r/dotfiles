
# Bluetooth is only needed on the main host. Other variants don't need this

if [ "$PROFILE" = "main" ]; then
    # Install bluetooth controls
    yay -S --noconfirm --needed blueberry

    # Turn on bluetooth by default
    sudo systemctl enable --now bluetooth.service
fi
