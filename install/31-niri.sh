#!/usr/bin/env bash

if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "niri" ] && [ ! "${PROFILE}" = "headless" ]; then
    tee "${HOME}/.config/niri/overrides.kdl" &>/dev/null <<- EOF
	output "Virtual-1" {

	EOF
    case "${RESOLUTION}" in
    "2880x1800")
      echo -e "// Resolution selected from install script\n\n   mode \"${RESOLUTION}\"\n   scale 1.6\n\n}" >>~/.config/niri/overrides.kdl
      ;;
    "MULTI")
      # echo -e "// Resolution selected from install script\n\n   mode \"3456x2160\"\n   scale 1.6\n\n}" >>~/.config/niri/overrides.kdl
      echo -e "// Resolution selected from install script\n\n   mode \"2880x1800\"\n   scale 1.6\n\n}" >>~/.config/niri/overrides.kdl
      ;;
	"2560x1400")
	  echo -e "// Resolution selected from install script\n\n   mode \"${RESOLUTION}\"\n   scale 1\n\n}" >>~/.config/niri/overrides.kdl
	  ;;
    *)
      echo -e "// Resolution selected from install script\n\n   mode \"${RESOLUTION}\"\n   scale 1\n\n}" >>~/.config/niri/overrides.kdl
      ;;
    esac
    install_packages \
      niri xwayland-satellite \
	  slurp grim wl-clipboard satty

	install_packages dms-shell dms-shell-niri xdg-desktop-portal-gtk
	if [ "${PROFILE}" = "main" ]; then
		install_packages greetd-dms-greeter-git
		sudo systemctl enable greetd
		sudo tee "/etc/greetd/config.toml" &>/dev/null <<- EOF
		[terminal]
		vt = 1

		[default_session]
		user = "greeter"
		command = "dms-greeter --command niri"
		EOF
		sudo tee -a "/etc/pam.d/greetd" &>/dev/null <<- EOF
		auth		optional    pam_gnome_keyring.so
		session		optional    pam_gnome_keyring.so    auto_start
		EOF
	fi
	systemctl --user add-wants niri.service dms
fi

# xdg-desktop-portal-gnome xdg-desktop-portal-gtk noctalia-shell 
