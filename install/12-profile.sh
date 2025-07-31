tee ${HOME}/.zshenv &>/dev/null <<EOF
# Loading the agent in the .zshenv makes it available during all sessions

if [ -z "\$SSH_AUTH_SOCK" ] ; then
    eval \$(ssh-agent -s) &>/dev/null
fi

# Putting zsh in the .config directory
export ZDOTDIR=\${HOME}/.config/zsh

# Loading Hyprland on boot
[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland &>/dev/null
EOF

