#!/usr/bin/env bash

if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "niri" ] && [ ! "${PROFILE}" = "headless" ]; then
    tee "${HOME}/.config/niri/overrides.kdl" &>/dev/null <<EOF
output "Virtual-1" {

EOF
    case "${RESOLUTION}" in
    "2880x1800")
      echo -e "// Resolution selected from install script\n\n   mode \"${RESOLUTION}\"\n   scale 1.6\n\n}" >>~/.config/niri/overrides.kdl
      ;;
    "MULTI")
      echo -e "// Resolution selected from install script\n\n   mode \"3456x2160\"\n   scale 1.6\n\n}" >>~/.config/niri/overrides.kdl
      ;;
    *)
      echo -e "// Resolution selected from install script\n\n   mode \"${RESOLUTION}\"\n   scale 1\n\n}" >>~/.config/niri/overrides.kdl
      ;;
    esac
    install_packages \
      niri xwayland-satellite \
	  slurp grim wl-clipboard satty

	install_packages dms-shell dms-shell-niri xdg-desktop-portal-gtk
	systemctl --user add-wants niri.service dms
fi

# xdg-desktop-portal-gnome xdg-desktop-portal-gtk noctalia-shell 
