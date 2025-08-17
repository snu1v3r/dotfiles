if [ "${FLAVOR}" = "arch" ] && [ ! "${PROFILE}" = "headless" ]; then
    install_packages \
      hyprland hyprshot hyprpicker hyprlock hypridle hyprpolkitagent hyprland-qtutils \
      waybar mako swaybg swayosd \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk uwsm wiremix walker-bin
fi

