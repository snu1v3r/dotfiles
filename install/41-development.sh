#!/usr/bin/env bash

install_packages imagemagick

case "${DISTRO}" in
    "arch")
        install_packages lazygit
        ;;
    "debian"|"kali"|"ubuntu")
        SUFFIX=Linux_x86_64
        TAGNAME=$(wget -qO- https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .name | cut -c2-)
        if [ ! -z "${TAGNAME}" ]; then
            wget -qO- "https://github.com/jesseduffield/lazygit/releases/download/v${TAGNAME}/lazygit_${TAGNAME}_${SUFFIX}.tar.gz" | tar xz -C /tmp
            sudo mv /tmp/lazygit /usr/bin/lazygit
        fi
        ;;
esac
