if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "gnome" ] && [ ! "${PROFILE}" = "headless" ]; then
	install_packages gdm gnome xorg-xserver xorg-xinit
	sudo systemctl enable gdm.service
fi

