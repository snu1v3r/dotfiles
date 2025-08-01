#!/usr/bin/env bash

install_packages wget curl unzip fzf ripgrep zoxide bat btop man tldr less whois plocate zsh stow tmux luarocks mc

case "${FLAVOR}" in
    "debian")
        install_packages fd-find openssh-client openssh-server p7zip

        # Install Yazi
        SUFFIX=x86_64-unknown-linux-musl
        TAGNAME=$(wget -qO- https://api.github.com/repos/sxyazi/yazi/releases/latest | jq -r .tag_name | cut -c2-)
        if [ ! -z ${TAGNAME} ]; then
            wget -qO /tmp/yazi.zip https://github.com/sxyazi/yazi/releases/download/v${TAGNAME}/yazi-${SUFFIX}.zip
            unzip -od /tmp/yazi /tmp/yazi.zip
            sudo mv /tmp/yazi/yazi-${SUFFIX}/yazi /tmp/yazi/yazi-${SUFFIX}/ya /usr/bin
            rm -rf /tmp/yazi*
        else
            install_warning "Yazi couldn't be installed because a valid tag was not found"
        fi
       
        # Install neovim
        wget -qO- https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar xz -C /tmp
        sudo cp -r /tmp/nvim-linux-x86_64/* /usr
        rm -rf /tmp/nvim-linux-x86_64

        # Install eza
        wget -qO- https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz -C /tmp
        sudo mv -f /tmp/eza /usr/bin/eza
      
        # Intall bat-extras
        BATURL=$(curl -s https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r .assets\[0\].browser_download_url)
        if [ ! -z ${BATMANURL} ]; then
            wget -qO /tmp/batextra.zip ${BATMANURL}
            unzip -od /tmp/bat /tmp/batextra.zip
            sudo mv /tmp/bat/* /usr
            rm -rf /tmp/bat
            rm /tmp/batextra.zip
        else
            install_warning "bat-extras couldn't be installed because a valid url was not found"
        fi
        ;;
    "arch")
        install_packages fd eza zoxide bat bat-extras openssh \
          wl-clipboard fastfetch btop \
          nvim yazi swappy mc
        ;;
esac

