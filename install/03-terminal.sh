#!/usr/bin/env bash
yay -S --noconfirm --needed \
  wget curl unzip inetutils \
  fd eza fzf ripgrep zoxide bat bat-extras \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate \
  alacritty zsh stow \
  tmux openssh \
  nvim luarocks tree-sitter-cli \
  yazi swappy mc

# Use stow to create links in the .local directory for dotfiles
mkdir -p ${HOME}/.local/bin
stow --target=${HOME}/.local --dir=${HOME}/.local/share/dotfiles/local .
