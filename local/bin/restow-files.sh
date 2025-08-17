#!/bin/bash
stow --target=${HOME}/.local --dir=${HOME}/.local/share/dotfiles/local .
stow --target=${HOME}/.config --dir=${HOME}/.local/share/dotfiles/config .
