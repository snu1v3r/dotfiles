#!/usr/bin/env bash

if [ ! "${PROFILE}" = "headless" ]; then
    # This script is used to install and configure plymouth

    install_packages plymouth

    sudo mkdir -p /usr/share/plymouth/themes
    sudo cp -r ~/.local/share/themes/static/plymouth/* /usr/share/plymouth/themes
    sudo plymouth-set-default-theme arch-linux-branded -R

    if [ -f /etc/mkinitcpio.conf ]; then
        # This ensures that plymouth is hooked before encrypt
        sudo sed -i "s/\(^HOOKS=([^)]*\)encrypt/\\1plymouth encrypt/" /etc/mkinitcpio.conf

        # Regenerate boot image
        sudo mkinitcpio -g /boot/initramfs-linux.img
    fi

fi
