#!/usr/bin/env bash
install_info() {
  BLUE=$'\033[0;34m'
  CLEAR=$'\033[0m'
  echo -e "$(date +%T) $BLUE[i]$CLEAR $1" | tee -a ${HOME}/install.log
}

install_info "Installation started"

install_info "Installing gum..."
pacman -Q gum &>/dev/null || sudo pacman -Sy --noconfirm --needed gum

# Configure identification
echo -e "\nEnter identification for git and autocomplete..."
export USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

install_info "Installing for user: $USER_NAME"
install_info "Using e-mail: $USER_EMAIL"

# Select profile
if [ "$PROFILE" = "" ]; then
  RESULT=$(gum choose Main BaseVM HackingVM Headless --header="Select the target profile:")
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

install_info "Installing git..."
pacman -Q git &>/dev/null || sudo pacman -Sy --noconfirm --needed git

install_info "Cloning Dotfiles..."
rm -rf ~/.local/share/dotfiles/

# This is kept for the final version
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null

install_info "Installation starting..."

# Install everything
for f in ~/.local/share/dotfiles/install/*.sh; do
  install_info "Starting $f"
  source "$f"
done

# Ensure locate is up to date now that everything has been installed
sudo updatedb

install_info "Installation finished."

gum confirm "Reboot to apply all settings?" && reboot
