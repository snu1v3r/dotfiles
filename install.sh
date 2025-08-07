#!/usr/bin/env bash
set -e

# First we determine some general settings
BLACK=$'\033[0;30m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
ORANGE=$'\033[0;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[1;37m'
CLEAR=$'\033[0m'

if [ -f /etc/os-release ]; then
    FLAVOR=$(grep "^ID" /etc/os-release| cut -d"=" -f2)
fi


install_info() {
  echo -e "$(date +%T) $BLUE[i]$CLEAR $1" | tee -a ${HOME}/install.log
}

install_warning() {
  echo -e "$(date +%T) $ORANGE[!]$CLEAR $1" | tee -a ${HOME}/install.log
}

install_packages() {
    case "${FLAVOR}" in 
        "debian")
            sudo apt-get install -y $@
            ;;
        "macos")
            brew install $@
            ;;
        "alpine")
            sudo pkg install $@
            ;;
        "arch")
            if [ -x "$(command -v yay)" ]; then
                yay --noconfirm --needed -S $@
            else
                sudo pacman --noconfirm --needed -S $@
            fi
            ;;
        *)
            install_warning "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again."
    esac
}

install_info "Cloning Dotfiles..."
if ! command -v git &>/dev/null ; then
    install_info "Installing git..."
    install_packages git
fi
rm -rf ~/.local/share/dotfiles/

# This is kept for the final version
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null

install_info "Installation of individual scripts starting..."

install_info "Profile used is: ${FLAVOR}"

# Install everything
for f in ~/.local/share/dotfiles/install/*.sh; do
  install_info "Starting $f"
  source "$f"
done

install_info "Installation finished."

gum confirm "Reboot to apply all settings?" && sudo reboot
