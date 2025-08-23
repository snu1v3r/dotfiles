#!/usr/bin/env bash

# Use stow to create links in the .local directory for dotfiles
mkdir -p ${HOME}/.local/bin
stow --target=${HOME}/.local --dir=${HOME}/.local/share/dotfiles/local .

# Use stow to create links to config of dotfiles
mkdir -p ${HOME}/.config
stow --target=${HOME}/.config --dir=${HOME}/.local/share/dotfiles/config .


if [ ! "${PROFILE}" = "headless" ] && [ ! "${RESOLUTION}" = "MULTI" ]; then
    tee ${HOME}/.setresolution.sh &>/dev/null <<EOF
#!/usr/bin/env bash
RESOLUTION=\$1
declare -a Res=(\$(/usr/bin/cvt \$(echo \${RESOLUTION}|/usr/bin/awk -Fx '{print \$1 " " \$2 " " 60}')|/usr/bin/tail -n 1| /usr/bin/tr -d \\"))
/usr/bin/xrandr --newmode \${Res[@]/Modeline/}
MONITOR=\`/usr/bin/xrandr --listmonitors | /usr/bin/grep -v 'Monitor'\`
MONITOR=\${MONITOR##* }
/usr/bin/xrandr --addmode \${MONITOR} \${RESOLUTION}_60.00
EOF
fi

install_packages zsh

# Set zsh as default shell
sudo chsh -s $(which zsh) $USER


##### TODO 
# These configuration originate from omarchy,
# they might be relevant on other distros/flavors
# but no real decission has been made

# Login directly as user, rely on hyprlock for security only used on the basevm, main machine uses SDDM
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
if [ ! "${PROFILE}" = "basevm" ]; then
    sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF
fi

# Set identification from install inputs
if [[ -n "${USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$USER_NAME"
fi

if [[ -n "${USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$USER_EMAIL"
fi

# Set default XCompose that is triggered with CapsLock
tee ${HOME}/.XCompose >/dev/null <<EOF
include "%L"

# Emoji
<Multi_key> <m> <s> : "😄" # smile
<Multi_key> <m> <c> : "😂" # cry
<Multi_key> <m> <l> : "😍" # love
<Multi_key> <m> <v> : "✌️"  # victory
<Multi_key> <m> <h> : "❤️"  # heart
<Multi_key> <m> <y> : "👍" # yes
<Multi_key> <m> <n> : "👎" # no
<Multi_key> <m> <f> : "🖕" # fuck
<Multi_key> <m> <w> : "🤞" # wish
<Multi_key> <m> <r> : "🤘" # rock
<Multi_key> <m> <k> : "😘" # kiss
<Multi_key> <m> <e> : "🙄" # eyeroll
<Multi_key> <m> <d> : "🤤" # droll
<Multi_key> <m> <m> : "💰" # money
<Multi_key> <m> <x> : "🎉" # xellebrate
<Multi_key> <m> <1> : "💯" # 100%
<Multi_key> <m> <t> : "🥂" # toast
<Multi_key> <m> <p> : "🙏" # pray
<Multi_key> <m> <i> : "😉" # wink
<Multi_key> <m> <o> : "👌" # OK
<Multi_key> <m> <g> : "👋" # greeting
<Multi_key> <m> <a> : "💪" # arm
<Multi_key> <m> <b> : "🤯" # blowing

# Typography
<Multi_key> <space> <space> : "—"

# Identification
<Multi_key> <space> <n> : "$USER_NAME"
<Multi_key> <space> <e> : "$USER_EMAIL"
EOF
