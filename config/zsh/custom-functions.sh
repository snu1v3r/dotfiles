# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

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

colorlog() {
  BLACK=$'\033[0;30m'
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  ORANGE=$'\033[0;33m'
  BLUE=$'\033[0;34m'
  PURPLE=$'\033[0;35m'
  CYAN=$'\033[0;36m'
  WHITE=$'\033[1;37m'
  CLEAR=$'\033[0m'
}

log_info() {
  colorlog
  echo -e "${BLUE}[i]${CLEAR} $1"
}

log_warning() {
  colorlog
  echo -e "${ORANGE}[!]${CLEAR} $1"
}

log_success() {
  colorlog
  echo -e "${GREEN}[*]${CLEAR} $1"
}

log_error() {
  colorlog
  echo -e "${RED}[E]${CLEAR} $1"
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
