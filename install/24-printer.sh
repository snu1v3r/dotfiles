#!/usr/bin/env bash
# Printer support is only needed on the main host
if [ "${PROFILE}" = "main" ]; then
    install_packages cups cups-pdf cups-filters system-config-printer
    sudo systemctl enable cups.service
    tar ${HOME}/.local/share/dotfiles/additional/Canon\ Printer\ Driver\ cque-en-4.0-12.x86_64.tar.gz /tmp
    cd /tmp/cque-en-4.0-12 && sudo ./setup
    cd -
fi
