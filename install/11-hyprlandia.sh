if [ "${FLAVOR}" = "arch" ] && [ ! "${PROFILE}" = "headless" ]; then
    install_packages \
      hyprland hyprshot hyprpicker hyprlock hypridle hyprpolkitagent hyprland-qtutils \
      wofi waybar mako swaybg \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
fi

