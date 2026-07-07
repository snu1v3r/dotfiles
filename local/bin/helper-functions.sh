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

if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO=${ID}
fi


log_info() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${BLUE}[i]${CLEAR} $1" | tee -a "${HOME}/install_log.txt"
    else
        echo -e "${BLUE}[i]${CLEAR} $1"
    fi
}

log_warning() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${ORANGE}[!]${CLEAR} $1" | tee -a "${HOME}/install_log.txt"
    else
        echo -e "${ORANGE}[!]${CLEAR} $1"
    fi
}

log_success() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${GREEN}[*]${CLEAR} $1" | tee -a "${HOME}/install_log.txt"
    else
        echo -e "${GREEN}[*]${CLEAR} $1"
    fi
}

log_error() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${RED}[E]${CLEAR} $1" | tee -a "${HOME}/install_log.txt"
    else
        echo -e "${RED}[E]${CLEAR} $1"
    fi
}

install_packages() {
    case "${DISTRO}" in 
        "debian"|"ubuntu"|"kali")
            sudo apt-get install -y "$@"
            ;;
        "macos")
            brew install "$@"
            ;;
        "alpine")
            sudo pkg install "$@"
            ;;
        "arch")
            if [ -x "$(command -v yay)" ]; then
                yay --noconfirm --needed -S "$@"
            else
                sudo pacman --noconfirm --needed -S "$@"
            fi
            ;;
        *)
            install_warning "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again."
    esac
}

update_and_upgrade() {
    case "${DISTRO}" in
        "debian"|"kali"|"ubuntu")
			sudo apt update && sudo apt upgrade -y
            ;;
        "macos")
            brew update && brew upgrade --quiet
            ;;
        "alpine")
            sudo apk -U upgrade
            ;;
        "arch")
			sudo pacman -Syyu --noconfirm
            ;;
        *)
            install_warning "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again."
    esac
}



# Compression
compress() {
	tar -czf "${1%/}.tar.gz" "${1%/}";
}

decompress() {
	tar -xzf "$@"
}

# Write iso file to sd card
iso2sd() {
  if [ $# -ne 2 ]; then
    echo "Usage: iso2sd <input_file> <output_device>"
    echo "Example: iso2sd ~/Downloads/ubuntu-25.04-desktop-amd64.iso /dev/sda"
    echo -e "\nAvailable SD cards:"
    lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
  else
    sudo dd bs=4M status=progress oflag=sync if="$1" of="$2"
    sudo eject $2
  fi
}

# Create a desktop launcher for a web app
web2app() {
  if [ "$#" -ne 3 ] && [ "$#" -ne 2 ]; then
    echo "Usage: web2app <AppName> <AppURL> [<IconURL>] (IconURL must be in PNG -- use https://dashboardicons.com)"
    return 1
  else
    local APP_NAME="$1"
    local APP_URL="$2"
    local ICON_URL="$3"
    local ICON_DIR="$HOME/.local/share/applications/icons"
    local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
    local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

    mkdir -p "$ICON_DIR"

    if [ "$#" -eq 3 ]; then
      if ! curl -sL -o "$ICON_PATH" "$ICON_URL"; then
        echo "Error: Failed to download icon."
        return 1
      fi
    fi

    cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=brave --new-window --ozone-platform=wayland --app="$APP_URL" --name="$APP_NAME" --class="$APP_NAME"
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true
EOF

    chmod +x "$DESKTOP_FILE"
  fi
}

web2app-remove() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: web2app-remove <AppName>"
    return 1
  fi

  local APP_NAME="$1"
  local ICON_DIR="$HOME/.local/share/applications/icons"
  local DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
  local ICON_PATH="${ICON_DIR}/${APP_NAME}.png"

  rm "$DESKTOP_FILE"
  rm "$ICON_PATH"
}

# Ensure changes to ~/.XCompose are immediately available
refresh-xcompose() {
  pkill fcitx5
  setsid fcitx5 &>/dev/null &
}

saveclip() {
  if [[ -n $XDG_SESSION_TYPE && $XDG_SESSION_TYPE = "wayland" ]]; then
    if [[ $(wl-paste -l) =~ 'image/png' ]]; then
      wl-paste -t "image/png" >$1
      log_info "Image saved to $(pwd)/$1"
      return 0
    else
      log_warning "No image on the clipboard"
      return 1
    fi
  else
    if [[ $(xclip -selection clipboard -o -t TARGETS) =~ 'image/png' ]]; then
      xclip -selection clipboard -t image/png -o >$1
      log_info "Image saved to $(pwd)/$1"
      return 0
    else
      log_warning "No image on the clipboard"
      return 1
    fi
  fi
}

saveclip() {
  if [[ -n $XDG_SESSION_TYPE && $XDG_SESSION_TYPE = "wayland" ]]; then
    if [[ $(wl-paste -l) =~ 'image/png' ]]; then
      wl-paste -t "image/png" >$1
      echo "Images saved to $(pwd)/$1"
      return 0
    else
      echo "No image on the clipboard"
      return 1
    fi
  else
    if [[ $(xclip -selection clipboard -o -t TARGETS) =~ 'image/png' ]]; then
      xclip -selection clipboard -t image/png -o >$1
      echo "Image saved to $(pwd)/$1"
      return 0
    else
      echo "No image no the clipboard"
      return 1
    fi
  fi
}

install-extras() {
	declare -a EXTRAS
	for FILE in ${HOME}/.local/share/dotfiles/install/extras/*; do
		TMP="${FILE%.*}"
		EXTRAS+=("${TMP##*/}")
	done;
	if [[ "${SHELL}" =~ "zsh" ]]; then
		RESULT=("${(f)$(gum choose "${EXTRAS[@]}" --no-limit --header="Choose the desired extras")}")
	else
		mapfile -t RESULT < <(gum choose "${EXTRAS[@]}" --no-limit --header="Choose the desired extras")
	fi
	for EXTRA in "${RESULT[@]}"; do
	    log_info "Starting ${EXTRA}.sh"
		source "${HOME}/.local/share/dotfiles/install/extras/${EXTRA}.sh"
	done;
}
