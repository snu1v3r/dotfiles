#!/usr/bin/env bash

install_packages alacritty playerctl pamixer playerctl pavucontrol wireplumber galculator \
    vlc nautilus fcitx5 evince imv

case "${FLAVOR}" in
    "arch")
        install_packages brave-bin \
          fcitx5-configtool fcitx5-gtk fcitx5-qt \
          wl-clip-persist clipse sushi \
          pamac-git networkmanager network-manager-applet
        ;;
    "debian")
        install_packages network-manager gnome-sushi fcitx5-config-qt
        ;;
esac

sudo systemctl enable NetworkManager.service
# yay -S --noconfirm --needed \
#   spotify \
#   obsidian

if [ "$PROFILE" = "main" ]; then
    install_packages keepassxc brightnessctl gnome-keyring thunderbird virt-manager passt
    case "${FLAVOR}" in
        "arch")
            install_packages nextcloud-client qt5-wayland qemu-base qemu-desktop
            ;;
        "debian")
            install_packages nextcloud-desktop qemu-system-gui qemu-system-q86 \
                qemu-user qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
            ;;
    esac
    # Enable virtualization
    sudo systemctl enable libvirtd.service
fi

# Needed to pre-install keepassxc plugin in brave-bin
if command -v keepassxc &>/dev/null && [ -f /opt/brave-bin/brave ]; then
    sudo mkdir -p /opt/brave-bin/extensions
    echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' | sudo tee /opt/brave-bin/extensions/oboonakemofpalcgghocfoadofidjkkk.json
fi
