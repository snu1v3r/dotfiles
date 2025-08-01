#!/usr/bin/env bash
# Bluetooth is only needed on the main host. Other variants don't need this

if [ "$PROFILE" = "main" ]; then
    case "${FLAVOR}" in
        "arch")
            # Install bluetooth controls
            install_packages blueberry
            ;;
        "debian")
            install_packages bluetooth
            ;;
    esac
fi

# Turn on bluetooth by default
sudo systemctl enable --now bluetooth.service
