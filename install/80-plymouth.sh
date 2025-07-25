#!/usr/bin/env bash
# This script is used to install and configure plymouth

yay -S --noconfirm --needed \
  plymouth

sudo mkdir -p /usr/share/plymouth/themes
sudo cp -r ~/.local/share/themes/static/plymouth/* /usr/share/plymouth/themes

sudo plymouth-set-default-theme arch-linux-branded -R

# Needed to ensure that plymouth is loaded as early as possible
sudo mkinitcpio -A plymouth -g /boot/initramfs-linux.img
