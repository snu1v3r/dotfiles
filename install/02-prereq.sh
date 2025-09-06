# Some cleanup to enable stow

if [ -f "${HOME}/.config/kglobalshortcutsrc" ] && [ ! -L "${HOME}/.config/kglobalshortcutsrc" ]; then
    rm ${HOME}/.config/kglobalshortcutsrc ${HOME}/.config/kwinrc &>/dev/null
fi

# stow is needed for activating the configuration directories
install_packages stow

# yay is used for the aur repo
if [ ${DISTRO} = "arch" ]; then
    sudo sed -i 's/#\(\[multilib\]\)/\1\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
    sudo pacman -Syyu
    install_packages base-devel
    if ! command -v yay &>/dev/null; then
      git clone https://aur.archlinux.org/yay-bin.git
      cd yay-bin
      makepkg -si --noconfirm
      cd ~
      rm -rf yay-bin
    fi
fi
