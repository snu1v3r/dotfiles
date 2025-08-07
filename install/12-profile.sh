#!/usr/bin/env bash
# This enables auto creation of modelines within X11
tee ${HOME}/.profile &>/dev/null <<EOF
COMPOSITOR=\$(loginctl show-session -p Type \$(loginctl list-sessions -o json | jq '.[0].session|tonumber') |cut -d= -f2)
if [ "\${COMPOSITOR}" = "x11" ] && [ -f "\${HOME}/.setresolution.sh" ]; then
    \${HOME}/.setresolution.sh ${RESOLUTION}
fi
EOF



# This enables loading an ssh-agent and hyprland
tee ${HOME}/.zshenv &>/dev/null <<EOF
# Loading the agent in the .zshenv makes it available during all sessions

if [ -z "\$SSH_AUTH_SOCK" ] ; then
    eval \$(ssh-agent -s) &>/dev/null
fi

# Putting zsh in the .config directory
export ZDOTDIR=\${HOME}/.config/zsh

# Loading Hyprland on boot
if [ -f "/usr/bin/Hyprland" ]; then
    [[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland &>/dev/null
fi
EOF
