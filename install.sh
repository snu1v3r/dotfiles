#!/usr/bin/env bash
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
if [ -x "$(command -v apt-get)" ]; then
    export PKG_MGR=apt
elif [ -x "$(command -v brew)" ]; then
    export PKG_MGR=brew
elif [ -x "$(command -v pkg)" ]; then
    export PKG_MGR=pkg
elif [ -x "$(command -v pacman)" ]; then
    export PKG_MGR=pacman
fi


install_info() {
  echo -e "$(date +%T) $BLUE[i]$CLEAR $1" | tee -a ${HOME}/install.log
}

install_warning() {
  echo -e "$(date +%T) $ORANGE[!]$CLEAR $1" | tee -a ${HOME}/install.log
}

install_packages() {
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get install -y $@
  elif [ -x "$(command -v brew)" ]; then
    brew install $@
  elif [ -x "$(command -v pkg)" ]; then
    sudo pkg install $@
  elif [ -x "$(command -v yay)" ]; then
    yay --noconfirm --needed -S $@
  elif [ -x "$(command -v pacman)" ]; then
    sudo pacman --noconfirm --needed -S $@
  else
    install_warning "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again."
  fi
}

install_info "Installation started"

if command -v gum &>/dev/null ; then
    install_info "Installing gum..."
    if [ "${PKG_MGR}" = "apt" ]; then
        GUMTAG=$(wget -qO- https://api.github.com/repos/charmbracelet/gum/releases/latest | jq -r .tag_name | cut -c2-)
        wget -q -O /tmp/gum.deb https://github.com/charmbracelet/gum/releases/download/v${GUMTAG}/gum_${GUMTAG}_amd64.deb
        sudo dpkg -i /tmp/gum.deb
        rm /tmp/gum.deb
    elif [ "${PKG_MGR}" = "pacman" ]; then
        sudo pacman -Sy --noconfirm --needed gum
    fi
fi

# Configure identification
echo -e "\nEnter identification for git and autocomplete..."
export USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

install_info "Installing for user: $USER_NAME"
install_info "Using e-mail: $USER_EMAIL"

# Select profile
if [ "$PROFILE" = "" ]; then
  RESULT=$(gum choose Main Hacking Server --header="Select the target profile:")
  if [ "$RESULT" = "" ]; then
    PROFILE="main"
  else
    PROFILE=$(echo "$RESULT" | tr '[:upper:]' '[:lower:]')
  fi
fi

install_info "The following profile is used: $PROFILE"

# Select target resolution
RESOLUTION=$(gum choose "2880x1800" "2560x1440" "1920x1080" "MULTI" --header="Select the target resolution:")
install_info "The following resolution is used: $RESOLUTION"

if command -v git &>/dev/null ; then
    install_info "Installing git..."
    install_packages git
fi

install_info "Cloning Dotfiles..."
rm -rf ~/.local/share/dotfiles/

# This is kept for the final version
# git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null
git clone --single-branch --branch dev --depth 1 --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null

install_info "Installation starting..."
exit

# Install everything
for f in ~/.local/share/dotfiles/install/*.sh; do
  install_info "Starting $f"
  source "$f"
done

install_info "Installation finished."

gum confirm "Reboot to apply all settings?" && reboot
