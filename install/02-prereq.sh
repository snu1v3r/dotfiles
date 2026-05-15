# Some cleanup to enable stow

if [ -f "${HOME}/.config/kglobalshortcutsrc" ] && [ ! -L "${HOME}/.config/kglobalshortcutsrc" ]; then
    rm ${HOME}/.config/kglobalshortcutsrc ${HOME}/.config/kwinrc &>/dev/null
fi

# yay is used for the aur repo
if [ ${DISTRO} = "arch" ]; then
    sudo sed -i 's/#\(\[multilib\]\)/\1\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
    sudo pacman -Syyu --noconfirm
    install_packages base-devel
    if ! command -v yay &>/dev/null; then
      git clone https://aur.archlinux.org/yay-bin.git
      cd yay-bin
      makepkg -si --noconfirm
      cd ~
      rm -rf yay-bin
    fi
fi
#
# This creates the first boot script. All other scripts can append post install commands
tee -a ${HOME}/first_boot.sh &>/dev/null <<EOF
#!/usr/bin/env bash
# This script is created for first boot after installation configuration
# It is started by the 'first_boot.service' service.
#
# After execution of this script the service and the script will be removed.
# 
# If this script is still available  then something went wrong.
#
# Any necessery first install actions can be added to this script by just adding to the 'first_boot.sh' script
EOF

chmod +x "${HOME}/first_boot.sh"

# stow is needed for activating the configuration directories
install_packages stow
