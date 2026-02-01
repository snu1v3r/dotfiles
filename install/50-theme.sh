#!/usr/bin/env bash

# Use dark mode for QT apps too (like VLC and kdenlive)
if [ ! "${PROFILE}" = "headless" ]; then
    case "${DISTRO}" in
        "arch")
            install_packages kvantum-qt5 gnome-themes-extra
            ;;
        "debian"|"ubuntu")
            install_packages qt5-style-kvantum gnome-themes-extra
            ;;
    esac
fi

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
