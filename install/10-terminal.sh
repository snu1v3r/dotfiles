#!/usr/bin/env bash

install_packages wget curl unzip ripgrep zoxide bat \
    btop man tldr less whois plocate zsh \
    tmux luarocks mc npm openvpn

case "${DISTRO}" in
    "debian")
        install_packages fd-find openssh-client openssh-server p7zip python3-venv \
            network-manager-openvpn-gnome network-manager-openvpn
        
        # Sometimes bat is named batcat. if batcat exists we make a symbolic link to bat
        if [ -f /usr/bin/batcat ]; then
            sudo ln -snf /usr/bin/batcat /usr/bin/bat
        fi

        # Some off the packages below are available in the repo, but those are too old and
        # lacking functionality
        #
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
        
        # Install fzf
        SUFFIX=linux_amd64
        TAGNAME=$(wget -qO- https://api.github.com/repos/junegunn/fzf/releases/latest | jq -r .name)
        wget -qO- "https://github.com/junegunn/fzf/releases/download/v${TAGNAME}/fzf-${TAGNAME}-${SUFFIX}.tar.gz" | tar xz -C /tmp
        sudo mv /tmp/fzf /usr/bin
      
        # Intall bat-extras
        BATEXTRAURL=$(wget -qO- https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r .assets\[0\].browser_download_url)
        if [ ! -z ${BATEXTRAURL} ]; then
            wget -qO /tmp/batextra.zip ${BATEXTRAURL}
            unzip -od /tmp/bat /tmp/batextra.zip
            sudo cp -r /tmp/bat/* /usr
            rm -rf /tmp/bat
            rm /tmp/batextra.zip
        else
            install_warning "bat-extras couldn't be installed because a valid url was not found"
        fi
        ;;
    "arch")
        install_packages fd eza zoxide bat bat-extras openssh \
          wl-clipboard fastfetch btop \
          nvim yazi swappy fzf \
          networkmanager-openvpn \
          oh-my-posh-bin starship
        ;;
esac

