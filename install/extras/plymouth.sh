#!/usr/bin/env bash

install_packages plymouth

sudo mkdir -p /usr/share/plymouth/themes
sudo cp -r ~/.local/share/themes/static/plymouth/* /usr/share/plymouth/themes
sudo ~/.local/bin/plymouth-set-default-theme arch-linux-branded -R

if [ -f /etc/mkinitcpio.conf ]; then
	# This ensures that plymouth is hooked before encrypt
	sudo sed -i "s/\(^HOOKS=([^)]*\)encrypt/\\1plymouth encrypt/" /etc/mkinitcpio.conf

	# Regenerate boot image
	kernel_version=`ls -t1 /usr/lib/modules/ | head -n 1`
	sudo mkinitcpio -k "${kernel_version}" -g /boot/initramfs-linux.img
fi
