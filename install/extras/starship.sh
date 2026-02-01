#!/usr/bin/env zsh
source "${HOME}/.local/bin/shell-utils.sh"

case "${DISTRO}" in
    "debian"|"ubuntu")
        # Install starship
        TAGNAME=$(wget -qO- https://api.github.com/repos/starship/starship/releases/latest | jq -r .name | cut -c2-)
        wget -qO- "https://github.com/starship/starship/releases/download/v${TAGNAME}/starship-x86_64-unknown-linux-musl.tar.gz" | tar xz -C /tmp
        sudo mv /tmp/starship /usr/bin/starship
        ;;
    "arch")
        install_packages starship
        ;;
esac
