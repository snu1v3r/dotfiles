#!/usr/bin/env bash

install_packages wget curl unzip fzf ripgrep zoxide bat btop man tldr less whois plocate zsh stow tmux luarocks mc

case "${FLAVOR}" in
    "debian")
        install_packages fd-find openssh-client openssh-server p7zip

        # Install Yazi
        SUFFIX=x86_64-unknown-linux-musl
        TAGNAME=$(wget -qO- https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r .tag_name | cut -c2-)
        wget -qO yazi.zip https://github.com/sxyazi/yazi/releases/download/v${TAGNAME}/yazi-${SUFFIX}.zip
        unzip /tmp/yazi.zip -d /tmp
        sudo mv /tmp/yazi-${SUFFIX}/yazi /tmp/yazi-${SUFFIX}/ya /usr/bin
        rm -rf /tmp/yazi*

        # Install neovim
        wget -qO- https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar xz -C /tmp
        sudo cp -r /tmp/nvim-linux-x86_64/* /usr
        rm -rf /tmp/nvim-linux-x86_64

        # Install eza
        wget -qO- https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz -C /tmp
        sudo mv -f /tmp/eza /usr/bin/eza
      
        # Intall bat-extras
        BATURL=$(curl -s https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r .assets\[0\].browser_download_url)
        wget -qO /tmp/batextra.zip ${BATMANURL}
        unzip /tmp/batextra.zip -d /tmp/bat
        sudo mv /tmp/bat/* /usr
        rm -rf /tmp/bat
        rm /tmp/batextra.zip
        ;;
    "arch")
        install_packages fd eza zoxide bat bat-extras openssh \
          wl-clipboard fastfetch btop \
          nvim yazi swappy mc
        ;;
esac

# Use stow to create links in the .local directory for dotfiles
mkdir -p ${HOME}/.local/bin
stow --target=${HOME}/.local --dir=${HOME}/.local/share/dotfiles/local .
