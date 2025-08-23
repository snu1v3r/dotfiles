#!/usr/bin/env bash
# Printer support is only needed on the main host
if [ "${PROFILE}" = "main" ]; then
    install_packages cups cups-pdf cups-filters system-config-printer
    sudo systemctl enable cups.service
    cd /tmp && tar xzvf ${HOME}/.local/share/dotfiles/assets/Canon\ Printer\ Driver\ cque-en-4.0-12.x86_64.tar.gz
    cd /tmp/cque-en-4.0-12 && sudo ./setup
    cd -
fi
