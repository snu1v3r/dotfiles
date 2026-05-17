if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "gnome" ] && [ ! "${PROFILE}" = "headless" ]; then
	install_packages gdm gnome xorg-xserver xorg-xinit gnome-tweaks iwd openssh smartmontools wget \
		wireless_tools wpa_supplicant xdg-utils gnome-extensions-cli
	sudo systemctl enable gdm.service
	gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+dvorak')]"
	gext -F install paperwm@paperwm.github.com
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
	[org/gnome/shell/extensions/paperwm]
	cycle-width-steps=[0.5, 0.6667, 1.0]
	horizontal-margin=6
	restore-attach-modal-dialogs='true'
	restore-edge-tiling='true'
	restore-workspaces-only-on-primary='false'
	selection-border-radius-top=10
	selection-border-radius-bottom=10
	selection-border-size=4
	vertical-margin=6
	vertical-margin-bottom=6
	window-gap=6
	winprops=['{"wm_class":"*","preferredWidth":"50%"}', '{"wm_class":"KeePassXC","title":"","scratch_layer":true}']
	[org/gnome/shell/extensions/paperwm/workspaces]
	list=['9c589144-7a28-4185-91fd-10a042220bf2', 'f42aa9a3-bba4-4394-b6b5-7df54aa1f65c', '7d25e9ec-14e7-45ea-95c2-67e334173014']
	[org/gnome/shell/extensions/paperwm/workspaces/7d25e9ec-14e7-45ea-95c2-67e334173014]
	index=2
	name='Socials'
	[org/gnome/shell/extensions/paperwm/workspaces/9c589144-7a28-4185-91fd-10a042220bf2]
	index=0
	name='Terminal'
	[org/gnome/shell/extensions/paperwm/workspaces/f42aa9a3-bba4-4394-b6b5-7df54aa1f65c]
	index=1
	name='Browser'
	[org/gnome/shell/extensions/paperwm/keybindings]
	new-window=['']
	[org/gnome/desktop/wm/keybindings]
	close=['<Super>w']
	toggle-maximized=['<Alt>Return']
	new-window=['']
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
	[org/gnome/mutter]
	workspaces-only-on-primary=false
	EOF
fi


