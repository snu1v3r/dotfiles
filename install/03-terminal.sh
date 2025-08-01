#!/usr/bin/env bash

install_packages wget curl unzip fzf ripgrep zoxide bat btop man tldr less whois plocate zsh stow tmux openssh luarocks mc

case "${FLAVOR}" in
    "debian")
        install_packages fd-find

        # Install Yazi
        SUFFIX=x86_64-unknown-linux-musl
        TAGNAME=$(wget -qO- https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r .tag_name | cut -c2-)
        wget -qO- https://github.com/sxyazi/yazi/releases/download/v${TAGNAME}/yazi-${SUFFIX}.zip | unzip -d /tmp
        exit
        sudo mv /tmp/yazi-${SUFFIX}/yazi /tmp/yazi-${SUFFIX}/ya /usr/bin
        sudo apt install -y p7zip jq
        exit
        rm /tmp/yazi.zip
        rm -rf /tmp/yazi-${SUFFIX}
    log_success "Installed Yazi"
        # eza
        # bat-extras
        # nvim
        # yazi
        ;;
    "arch")
        install_packages fd eza zoxide bat bat-extras \
          wl-clipboard fastfetch btop \
          nvim yazi swappy mc
        ;;
esac

# Use stow to create links in the .local directory for dotfiles
mkdir -p ${HOME}/.local/bin
stow --target=${HOME}/.local --dir=${HOME}/.local/share/dotfiles/local .
