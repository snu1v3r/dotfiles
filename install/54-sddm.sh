#!/usr/bin/env bash

# SDDM as a login manager is only used on the main Arch machine. In other (vm) variants automatic login is used
if [ "${PROFILE}" = "main" ] && [ "${DISTRO}" = "arch" ] && [ ! command -v gdm 2>/dev/null ] || [ "${DISPLAYMANAGER}" = "niri" ]; then
    install_packages sddm qt5-quickcontrols qt5-quickcontrols2 qt5-graphicaleffects
    sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf

	if [ "${DISPLAYMANAGER}" = "niri" ]; then
		install_packages sddm-theme-noctalia-git xorg-xrandr
		sudo sed -i "s/^\(Current=\).*/\\1noctalia/" /etc/sddm.conf
		sudo sed -i "s/^\(DisplayCommand=\).*/\\1xrandr --output Virtual-1 --mode 2560x1440 --rate 60/" /etc/sddm.conf

	else
		sudo sed -i "s/^\(Current=\).*/\\1mountain/" /etc/sddm.conf
		install_packages weston
		sudo mkdir -p /etc/xdg/weston
		sudo tee /etc/xdg/weston/weston.ini &>/dev/null <<- EOF
		[keyboard]
		keymap_layout=us
		keymap_variant=dvorak
		EOF
	fi

    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r ~/.local/share/themes/static/sddm/* /usr/share/sddm/themes
    sudo systemctl enable sddm.service
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
