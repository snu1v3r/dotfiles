yay -S --noconfirm --needed \
  hyprland hyprshot hyprpicker hyprlock hypridle hyprpolkitagent hyprland-qtutils \
  wofi waybar mako swaybg \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

# Ensure that the zsh configuration is loaded from the .config/zsh directory
# Start Hyprland on first session
echo 'export ZDOTDIR=${HOME}/.config/zsh' >~/.zprofile
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland &>/dev/null" >>~/.zprofile
