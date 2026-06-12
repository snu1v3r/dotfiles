#!/usr/bin/env bash
source "${HOME}/.local/bin/shell-utils.sh"

install_packages ansible

case "${DISTRO}" in
    "arch")
		install_packages ansible-language-server
        ;;
esac
