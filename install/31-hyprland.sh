if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "hyprland" ] && [ ! "${PROFILE}" = "headless" ]; then
    tee ${HOME}/.config/hypr/overrides.conf &>/dev/null <<EOF
# This file can be used to override monitor settings on a system specific level 
# See https://wiki.hyprland.org/Configuring/Monitors/

# Use single default monitor (see all monitors with: hyprctl monitors)
# monitor= ,preferred,auto,auto
# monitor = [name], preferred | <width>x<height>[@<frequency>],auto | <position right>x<position down>, auto | <scaling factor>

# Example for Framework 13 w/ 6K XDR Apple display
# monitor = DP-5, 6016x3384@60.00, auto, 2
# monitor = eDP-1, 2880x1920@120.00, auto, 2
#
# Extra env variables
# env = GDK_SCALE,1 # Change to 1 if on a 1x display
#
# Some suggestions
#
# Laptop only
# monitor = , 2880x1800@60.00, auto, 1.6
# env = GDK_SCALE, 1.6
# 
# Asus screen
# monitor = , 1920x1080@60.00, auto, 1
# env = GDK_SCALE, 1
#
# HP-monitors
# monitor = , 2560x1440@60.00, auto, 1
# env = GDK_SCALE, 1
#
EOF
    case "${RESOLUTION}" in
    "2880x1800")
      echo -e "# Resolution selected from install script\n\nmonitor = , ${RESOLUTION}@60.00, auto, 1.6\nenv= GDK_SCALE, 1.6" >>~/.config/hypr/overrides.conf
      ;;
    "MULTI")
      echo -e "# Resolution selected from install script\n\nmonitor = eDP-1, 2880x1800@120.00, auto, 1.6\nmonitor = DP-4, 2560x1440@60.00, auto, 1\nmonitor = DP-5, 2560x1440@60.00, auto, 1" >>~/.config/hypr/overrides.conf
      ;;
    *)
      echo -e "# Resolution selected from install script\n\nmonitor = , ${RESOLUTION}@60.00, auto, 1\nenv = GDK_SCALE, 1" >>~/.config/hypr/overrides.conf
      ;;
    esac
    install_packages \
      hyprland hyprshot hyprpicker hyprlock hypridle hyprpolkitagent hyprland-qtutils \
      waybar mako swaybg swayosd \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk uwsm wiremix walker-bin \
	wl-clipboard wl-clip-persist swappy elephant-desktopapplications
fi

