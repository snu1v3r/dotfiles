yay -S --noconfirm --needed \
  brave-bin \
  galculator nautilus vlc \
  fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt \
  evince imv \
  wl-clip-persist clipse sushi pamixer playerctl pavucontrol wireplumber \
  pamac-git

# yay -S --noconfirm --needed \
#   spotify \
#   obsidian

if [ "$PROFILE" = "main" ]; then
  yay -S --noconfirm --needed \
    keepassxc nextcloud-client qt5-wayland brightnessctl gnome-keyring \
    thunderbird virt-manager qemu-base qemu-desktop
  sudo systemctl enable libvirtd.service
fi

# Needed to pre-install keepassxc plugin in brave-bin

if command -v keepassxc &>/dev/null; then
  if [ -f /opt/brave-bin/brave ]; then
    sudo mkdir -p /opt/brave-bin/extensions
    echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' | sudo tee /opt/brave-bin/extensions/oboonakemofpalcgghocfoadofidjkkk.json
  fi
fi
