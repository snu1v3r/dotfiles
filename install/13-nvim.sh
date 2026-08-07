#!/usr/bin/env bash

# This file installs neovim, but also all required language servers

case "${DISTRO}" in
    "debian"|"kali"|"ubuntu")
        # Install neovim
        wget -qO- https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar xz -C /tmp
        sudo cp -r /tmp/nvim-linux-x86_64/* /usr
        rm -rf /tmp/nvim-linux-x86_64
		;;

    "arch")
        install_packages nvim \
		  shellcheck-bin bash-language-server \
		  lua-language-server \
		  ruff python-lsp-server python-lsp-ruff \
		  marksman tree-sitter-cli
        ;;
esac

