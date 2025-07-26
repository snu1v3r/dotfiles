# Use dark mode for QT apps too (like VLC and kdenlive)
sudo pacman -S --noconfirm kvantum-qt5

# Prefer dark mode everything
sudo pacman -S --noconfirm gnome-themes-extra # Adds Adwaita-dark theme
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Set initial theme
mkdir -p ~/.config/theme
ln -snf ~/.local/share/themes/dynamic/tokyo-night ~/.config/theme/current
ln -snf $(find ~/.config/theme/current/backgrounds -type f -print -quit) ~/.config/theme/background

# Set specific app links for current theme
ln -snf ~/.config/theme/current/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/theme/current/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/theme/current/mako.ini ~/.config/mako/config
mkdir -p ~/.config/bat/themes
ln -snf ~/.config/theme/current/bat-theme.tmTheme ~/.config/bat/themes/bat-theme.tmTheme
bat cache --build
