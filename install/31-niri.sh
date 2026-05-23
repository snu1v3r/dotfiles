#!/usr/bin/env bash

if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "niri" ] && [ ! "${PROFILE}" = "headless" ]; then
    tee "${HOME}/.config/niri/overrides.kdl" &>/dev/null <<EOF
output "Virtual-1" {

EOF
    case "${RESOLUTION}" in
    "2880x1800")
      echo -e "# Resolution selected from install script\n\nmonitor = , ${RESOLUTION}@60.00, auto, 1.6\nenv= GDK_SCALE, 1.6" >>~/.config/niri/overrides.kdl
      ;;
    "MULTI")
      echo -e "# Resolution selected from install script\n\nmonitor = eDP-1, 2880x1800@120.00, auto, 1.6\nmonitor = DP-4, 2560x1440@60.00, auto, 1\nmonitor = DP-5, 2560x1440@60.00, auto, 1" >>~/.config/niri/overrides.kdl
      ;;
    *)
      echo -e "// Resolution selected from install script\n\n   mode \"${RESOLUTION}@60.007\"\n   scale 1\n\n}" >>~/.config/niri/overrides.kdl
      ;;
    esac
    install_packages \
      niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk noctalia-shell \
	  slurp grim wl-clipboard satty
fi


