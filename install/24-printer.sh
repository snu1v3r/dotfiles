#!/usr/bin/env bash

# Printer support is only needed on the main host
if [ "${PROFILE}" = "main" ]; then
    install_packages cups cups-pdf cups-filters system-config-printer
    sudo systemctl enable cups.service
fi
