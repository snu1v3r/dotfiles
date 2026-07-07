#!/usr/bin/env bash

install_packages ansible

case "${DISTRO}" in
    "arch")
		install_packages ansible-language-server
        ;;
esac
