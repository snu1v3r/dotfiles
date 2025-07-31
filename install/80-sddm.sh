#!/usr/bin/env bash

yay -S --noconfirm --needed \
    sddm sddm-theme-mountain-git

sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
sudo sed -i "s/^\(Current=\).*/\\1mountain/" /etc/sddm.conf
sudo mkdir -p /etc/xdg/weston

sudo tee /etc/xdg/weston/weston.ini &>/dev/null <<EOF
[keyboard]
keymap_layout=us
keymap_variant=dvorak
EOF
