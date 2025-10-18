#!/usr/bin/env bash
if [ ! "${PROFILE}" = "headless" ]; then
    install_packages alacritty playerctl pamixer playerctl pavucontrol wireplumber qalculate-gtk \
        vlc nautilus evince imv kitty elephant-desktopapplications

    case "${DISTRO}" in
        "arch")
            install_packages brave-bin \
                fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt \
                wl-clip-persist clipse sushi \
                networkmanager network-manager-applet
            ;;
        "debian")
            install_packages network-manager gnome-sushi fcitx5-config-qt flameshot
            ;;
    esac

    sudo systemctl enable NetworkManager.service
    # yay -S --noconfirm --needed \
    #   spotify \
    #   obsidian

    if [ "$PROFILE" = "main" ]; then
        install_packages keepassxc brightnessctl gnome-keyring thunderbird
        case "${DISTRO}" in
            "arch")
                install_packages nextcloud-client qt5-wayland
                ;;
            "debian")
                install_packages nextcloud-desktop
                ;;
        esac
    fi

    # Needed to pre-install keepassxc plugin in brave-bin
    if command -v keepassxc &>/dev/null && [ -f /opt/brave-bin/brave ]; then
        sudo mkdir -p /opt/brave-bin/extensions
        echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' | sudo tee /opt/brave-bin/extensions/oboonakemofpalcgghocfoadofidjkkk.json
    fi
fi


