#!/usr/bin/env bash
case "${FLAVOR}" in
    "debian")
        install_packages fonts-noto fonts-noto-color-emoji fonts-noto-cjk fonts-noto-extra 
        if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
            cd /tmp
            wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
            unzip JetBrainsMono.zip -d JetBrainsFont
            cp JetBrainsFont/JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts
            cp JetBrainsFont/JetBrainsMonoNerdFont-Bold.ttf ~/.local/share/fonts
            cp JetBrainsFont/JetBrainsMonoNerdFont-Italic.ttf ~/.local/share/fonts
            cp JetBrainsFont/JetBrainsMonoNerdFont-BoldItalic.ttf ~/.local/share/fonts
            rm -rf JetBrainsMono.zip JetBrainsFont
            fc-cache
            cd -
        fi
        ;;
    "arch")
        install_packages ttf-font-awesome noto-fonts noto-fonts-emoji \
            noto-fonts-cjk noto-fonts-extra ttf-jetbrains-mono-nerd
        ;;
esac

