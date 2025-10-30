#!/usr/bin/env bash

# SDDM as a login manager is only used on the main Arch machine. In other (vm) variants automatic login is used
if [ "${PROFILE}" = "main" ] && [ "${DISTRO}" = "arch" ] && [ ! command -v gdm 2>/dev/null ]; then
    install_packages sddm weston qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r ~/.local/share/themes/static/sddm/* /usr/share/sddm/themes
    sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
    sudo sed -i "s/^\(Current=\).*/\\1mountain/" /etc/sddm.conf
    sudo systemctl enable sddm.service
    sudo mkdir -p /etc/xdg/weston
    sudo tee /etc/xdg/weston/weston.ini &>/dev/null <<- EOF
	[keyboard]
	keymap_layout=us
	keymap_variant=dvorak
	EOF
    # This is needed to ensure that sddm will also unlock the keyring
    sudo rm /etc/pam.d/sddm && sudo tee /etc/pam.d/sddm &>/dev/null <<- EOF
	#%PAM-1.0

	auth        include     system-login
	auth       optional    pam_gnome_keyring.so
	-auth       optional    pam_kwallet5.so

	account     include     system-login

	password    include     system-login
	password   optional    pam_gnome_keyring.so    use_authtok

	session     optional    pam_keyinit.so          force revoke
	session     include     system-login
	session    optional    pam_gnome_keyring.so    auto_start
	-session    optional    pam_kwallet5.so         auto_start
	EOF
fi
