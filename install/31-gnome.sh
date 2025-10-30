if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "gnome" ] && [ ! "${PROFILE}" = "headless" ]; then
	install_packages gdm gnome xorg-xserver xorg-xinit
	sudo systemctl enable gdm.service
	gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+dvorak')]"
	# Clear existing use for <Meta>+number
	for i in {1..9}; do
		gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]";
	done
	# Set switch to workspace
	for i in {1..10}; do
		gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$((i%10))']";
	done
	# Move windows to workspaces
	for i in {1..10}; do
		gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Shift><Super>$((i%10))']";
	done
	dconf load '/' <<- EOF
	[org/gnome/settings-daemon/plugins/media-keys]
	custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']
	home=['<Super>f']
	www=['<Super>b']
	[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
	binding='<Super>Return'
	command='/usr/bin/kitty'
	name='Terminal'
	[org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1]
	binding='<Super>c'
	command='/usr/bin/qalculate-gtk'
	name='Calculator'
	[org/gnome/shell]
	favorite-apps=['brave-browser.desktop', 'org.gnome.Nautilus.desktop', 'kitty.desktop']
	welcome-dialog-last-shown-version='49.1'
	[org/gnome/desktop/wm/keybindings]
	close=['<Super>w']
	toggle-maximized=['<Alt>Return']
	EOF
fi

