#!/usr/bin/env bash

if [ "$PROFILE" = "hacking" ]; then
    echo -e "[ownstuff]\nServer = https://ftp.f3l.de/~martchus/\$repo/os/\$arch\nServer = https://martchus.dyn.f3l.de/repo/arch/\$repo/os/\$arch" | sudo tee -a /etc/pacman.conf
    sudo pacman-key --keyserver keyserver.ubuntu.com --recv-keys B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # import key
    sudo pacman-key --finger    B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # verify fingerprint
    sudo pacman-key --lsign-key B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # sign imported key locally
    sudo pacman -Sy --noconfirm
    sudo pacman -S --noconfirm syncthing syncthingtray-qt6
fi
