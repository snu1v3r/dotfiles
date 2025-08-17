#!/bin/bash
BIN_PATH=~/.local/bin

menu() {
  local prompt="$1"
  local options="$2"
  local extra="$3"
  local preselect="$4"

  read -r -a args <<<"$extra"

  if [[ -n "$preselect" ]]; then
    local index
    index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
    if [[ -n "$index" ]]; then
      args+=("-a" "$index")
    fi
  fi
  echo -e "${options}" | walker --dmenu --theme dmenu_250 -p "${prompt}..." "${args[@]}"
}

terminal() {
  alacritty --class Popup -e $1
}

present_terminal() {
  alacritty --class Popup -e bash -c "eval \"$1\"; ~/.local/bin/show-done.sh;"
}

edit_in_nvim() {
  notify-send "Editing config file" "$1"
  alacritty -e nvim "$1"
}

open_web() {
  setsid brave --new-window --ozone-platform=wayland --password-store=gnome --app="$1" &
}

install() {
  present_terminal "echo 'Installing $1...'; yay -Sy --noconfirm $2"
}

install_and_launch() {
  present_terminal "echo 'Installing $1...'; yay -Sy --noconfirm $2 && gtk-launch $3"
}

install_font() {
  present_terminal "echo 'Installing $1...'; yay -Sy --noconfirm --needed $2 && sleep 2 && ~/.local/bin/font-set.sh '$3'"
}

show_learn_menu() {
  case $(menu "Learn" "  Keybindings\n  Hyprland\n󰣇  Arch\n  Neovim\n󱆃  Bash\n  Zsh") in
  *Keybindings*) $BIN_PATH/show-menu-keybindings.sh ;;
  *Hyprland*) open_web "https://wiki.hypr.land/" ;;
  *Arch*) open_web "https://wiki.archlinux.org/title/Main_page" ;;
  *Bash*) open_web "https://devhints.io/bash" ;;
  *Zsh*) open_web "https://devhints.io/zsh" ;;
  *Neovim*) open_web "https://www.lazyvim.org/keymaps" ;;
  *) show_main_menu ;;
  esac
}

show_style_menu() {
  case $(menu "Style" "󰸌  Theme\n  Font\n  Background") in
  *Theme*) show_theme_menu ;;
  *Font*) show_font_menu ;;
  *Background*) $BIN_PATH/omarchy-theme-bg-next ;;
  *) show_main_menu ;;
  esac
}

show_theme_menu() {
  theme=$(menu "Theme" "$($BIN_PATH/omarchy-theme-list)" "" "$($BIN_PATH/omarchy-theme-current)")
  if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
    show_main_menu
  else
    $BIN_PATH/omarchy-theme-set "$theme"
  fi
}

show_font_menu() {
  theme=$(menu "Font" "$($BIN_PATH/font-list.sh)" "-w 350" "$($BIN_PATH/font-current.sh)")
  if [[ "$theme" == "CNCLD" || -z "$theme" ]]; then
    show_main_menu
  else
    $BIN_PATH/font-set.sh "$theme"
  fi
}

show_capture_menu() {
    case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰃉  Color (hex)\n󰃉  Color (rgb)") in
  *Screenshot*) show_screenshot_menu ;;
  *Screenrecord*) show_screenrecord_menu ;;
  *Color*hex*) pkill hyprpicker || hyprpicker -a -f hex ;;
  *Color*rgb*) pkill hyprpicker || hyprpicker -a -f rgb ;;
  *) show_main_menu ;;
  esac
}

show_screenshot_menu() {
  case $(menu "Screenshot" "  Region\n  Window\n  Display") in
  *Region*) $BIN_PATH/take-screenshot.sh ;;
  *Window*) $BIN_PATH/take-screenshot.sh window ;;
  *Display*) $BIN_PATH/take-screenshot.sh output ;;
  *) show_capture_menu ;;
  esac
}

show_screenrecord_menu() {
  case $(menu "Screenrecord" "  Region\n  Display") in
  *Region*) $BIN_PATH/omarchy-cmd-screenrecord ;;
  *Display*) $BIN_PATH/omarchy-cmd-screenrecord output ;;
  *) show_capture_menu ;;
  esac
}

show_toggle_menu() {
  case $(menu "Toggle" "󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰍜  Top Bar") in
  *Screensaver*) $BIN_PATH/omarchy-launch-screensaver ;;
  *Nightlight*) $BIN_PATH/omarchy-toggle-nightlight ;;
  *Idle*) $BIN_PATH/omarchy-toggle-idle ;;
  *Bar*) pkill -SIGUSR1 waybar ;;
  *) show_main_menu ;;
  esac
}

show_setup_menu() {
  local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n󰍹  Monitors"
  [ -f ~/.config/hypr/bindings.conf ] && options="$options\n  Keybindings"
  [ -f ~/.config/hypr/input.conf ] && options="$options\n  Input"
  options="$options\n  Config\n󰈷  Fingerprint\n  Fido2"

  case $(menu "Setup" "$options") in
  *Audio*) alacritty --class=Wiremix -e wiremix ;;
  *Wifi*) alacritty --class=Impala -e impala ;;
  *Bluetooth*) blueberry ;;
  *Power*) show_setup_power_menu ;;
  *Monitors*) edit_in_nvim ~/.config/hypr/monitors.conf ;;
  *Keybindings*) edit_in_nvim ~/.config/hypr/bindings.conf ;;
  *Input*) edit_in_nvim ~/.config/hypr/input.conf ;;
  *Config*) show_setup_config_menu ;;
  *Fingerprint*) present_terminal $BIN_PATH/setup-fingerprint.sh ;;
  *Fido2*) present_terminal $BIN_PATH/setup-fido2.sh ;;
  *) show_main_menu ;;
  esac
}

show_setup_power_menu() {
  profile=$(menu "Power Profile" "$($BIN_PATH/omarchy-powerprofiles-list)" "" "$(powerprofilesctl get)")

  if [[ "$profile" == "CNCLD" || -z "$profile" ]]; then
    show_main_menu
  else
    powerprofilesctl set "$profile"
  fi
}

show_setup_config_menu() {
  case $(menu "Setup" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar\n󰞅  XCompose") in
  *Hyprland*) edit_in_nvim ~/.config/hypr/hyprland.conf ;;
  *Hypridle*) edit_in_nvim ~/.config/hypr/hypridle.conf && ~/.local/share/omarchy/bin/omarchy-restart-hypridle ;;
  *Hyprlock*) edit_in_nvim ~/.config/hypr/hyprlock.conf ;;
  *Hyprsunset*) edit_in_nvim ~/.config/hypr/hyprsunset.conf && ~/.local/share/omarchy/bin/omarchy-restart-hyprsunset ;;
  *Swayosd*) edit_in_nvim ~/.config/swayosd/config.toml && ~/.local/share/omarchy/bin/omarchy-restart-swayosd ;;
  *Walker*) edit_in_nvim ~/.config/walker/config.toml && ~/.local/share/omarchy/bin/omarchy-restart-walker ;;
  *Waybar*) edit_in_nvim ~/.config/waybar/config.jsonc && ~/.local/share/omarchy/bin/omarchy-restart-waybar ;;
  *XCompose*) edit_in_nvim ~/.XCompose && ~/.local/share/omarchy/bin/omarchy-restart-xcompose ;;
  *) show_main_menu ;;
  esac
}

show_install_menu() {
  case $(menu "Install" "󰣇  Package\n  Web App\n  Style\n  Editor\n󱚤  AI\n  Dropbox\n  Steam\n  Docker DB") in
  *Package*) terminal $BIN_PATH/pkg-install.sh ;;
  *Web*) present_terminal $BIN_PATH/omarchy-webapp-install ;;
  *Style*) show_install_style_menu ;;
  *Editor*) show_install_editor_menu ;;
  *AI*) show_install_ai_menu ;;
  *Dropbox*) present_terminal $BIN_PATH/omarchy-install-dropbox ;;
  *Steam*) present_terminal $BIN_PATH/omarchy-install-steam ;;
  *Docker*) present_terminal $BIN_PATH/omarchy-install-docker-dbs ;;
  *) show_main_menu ;;
  esac
}

show_install_editor_menu() {
  case $(menu "Install" "  VSCode\n  Cursor\n  Zed") in
  *VSCode*) install_and_launch "VSCode" "visual-studio-code-bin" "code" ;;
  *Cursor*) install_and_launch "Cursor" "cursor-bin" "cursor-cursor" ;;
  *Zed*) install_and_launch "Zed" "zed" "dev.zed.Zed" ;;
  *) show_install_menu ;;
  esac
}

show_install_ai_menu() {
  case $(menu "Install" "󱚤  Claude Code\n󱚤  Gemini\n󱚤  LM Studio\n󱚤  Ollama\n󱚤  Crush\n󱚤  Open Code") in
  *Claude*) install "Claude Code" "claude-code" ;;
  *Gemini*) install "Gemini" "gemini-cli-bin" ;;
  *Studio*) install "LM Studio" "lmstudio" ;;
  *Ollama*) install "Ollama" "ollama" ;;
  *Crush*) install "Crush" "crush-bin" ;;
  *Code*) install "Open Code" "opencode-bin" ;;
  *) show_install_menu ;;
  esac
}

show_install_style_menu() {
  case $(menu "Install" "󰸌  Theme\n  Background\n  Font") in
  *Theme*) present_terminal $BIN_PATH/omarchy-theme-install ;;
  *Background*) nautilus ~/.config/omarchy/current/theme/backgrounds ;;
  *Font*) show_install_font_menu ;;
  *) show_install_menu ;;
  esac
}

show_install_font_menu() {
  case $(menu "Install" "  Meslo LG Mono\n  Fira Code\n  Victor Code\n  Bistream Vera Mono" "-w 350") in
  *Meslo*) install_font "Meslo LG Mono" "ttf-meslo-nerd" "MesloLGL Nerd Font" ;;
  *Fira*) install_font "Fira Code" "ttf-firacode-nerd" "FiraCode Nerd Font" ;;
  *Victor*) install_font "Victor Code" "ttf-victor-mono-nerd" "VictorMono Nerd Font" ;;
  *Bistream*) install_font "Bistream Vera Code" "ttf-bitstream-vera-mono-nerd" "BitstromWera Nerd Font" ;;
  *) show_install_menu ;;
  esac
}

show_remove_menu() {
  case $(menu "Remove" "󰣇  Package\n  Web App\n󰸌  Theme\n󰈷  Fingerprint\n  Fido2") in
  *Package*) terminal $BIN_PATH/pkg-remove.sh ;;
  *Web*) present_terminal $BIN_PATH/omarchy-webapp-remove ;;
  *Theme*) present_terminal $BIN_PATH/omarchy-theme-remove ;;
  *Fingerprint*) present_terminal "$BIN_PATH/omarchy-setup-fingerprint --remove" ;;
  *Fido2*) present_terminal "$BIN_PATH/omarchy-setup-fido2 --remove" ;;
  *) show_main_menu ;;
  esac
}

show_update_menu() {
  case $(menu "Update" "󰣇  Omarchy\n  Config\n  Process\n󰸌  Themes\n  Timezone") in
  *Omarchy*) present_terminal $BIN_PATH/omarchy-update ;;
  *Config*) show_update_config_menu ;;
  *Process*) show_update_process_menu ;;
  *Themes*) present_terminal $BIN_PATH/omarchy-theme-update ;;
  *Timezone*) $BIN_PATH/omarchy-cmd-tzupdate ;;
  *) show_main_menu ;;
  esac
}

show_update_process_menu() {
  case $(menu "Restart" "  Hypridle\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
  *Hypridle*) $BIN_PATH/omarchy-restart-hypridle ;;
  *Hyprsunset*) $BIN_PATH/omarchy-restart-hyprsunset ;;
  *Swayosd*) $BIN_PATH/omarchy-restart-swayosd ;;
  *Walker*) $BIN_PATH/omarchy-restart-walker ;;
  *Waybar*) $BIN_PATH/omarchy-restart-waybar ;;
  *) show_main_menu ;;
  esac
}

show_update_config_menu() {
  case $(menu "Use default config" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n󱣴  Plymouth\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
  *Hyprland*) present_terminal $BIN_PATH/omarchy-refresh-hyprland ;;
  *Hypridle*) present_terminal $BIN_PATH/omarchy-refresh-hypridle ;;
  *Hyprlock*) present_terminal $BIN_PATH/omarchy-refresh-hyprlock ;;
  *Hyprsunset*) present_terminal $BIN_PATH/omarchy-refresh-hyprsunset ;;
  *Plymouth*) present_terminal $BIN_PATH/omarchy-refresh-plymouth ;;
  *Swayosd*) present_terminal $BIN_PATH/omarchy-refresh-swayosd ;;
  *Walker*) present_terminal $BIN_PATH/omarchy-refresh-walker ;;
  *Waybar*) present_terminal $BIN_PATH/omarchy-refresh-waybar ;;
  *) show_main_menu ;;
  esac
}

show_system_menu() {
  case $(menu "System" "  Lock\n󰤄  Suspend\n  Relaunch\n󰜉  Restart\n󰐥  Shutdown") in
  *Lock*) $BIN_PATH/lock-screen.sh ;;
  *Suspend*) systemctl suspend ;;
  *Relaunch*) uwsm stop ;;
  *Restart*) systemctl reboot ;;
  *Shutdown*) systemctl poweroff ;;
  *) show_main_menu ;;
  esac
}

show_main_menu() {
  go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n  Capture\n󰔎  Toggle\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  About\n  System")"
}

go_to_menu() {
  case "${1,,}" in
  *apps*) walker -p "Launch…" ;;
  *learn*) show_learn_menu ;;
  *style*) show_style_menu ;;
  *theme*) show_theme_menu ;;
  *capture*) show_capture_menu ;;
  *screenshot*) show_screenshot_menu ;;
  *screenrecord*) show_screenrecord_menu ;;
  *toggle*) show_toggle_menu ;;
  *setup*) show_setup_menu ;;
  *install*) show_install_menu ;;
  *remove*) show_remove_menu ;;
  *update*) show_update_menu ;;
  *system*) show_system_menu ;;
  *about*) gtk-launch About.desktop ;;
  esac
}

if [[ -n "$1" ]]; then
  go_to_menu "$1"
else
  show_main_menu
fi
