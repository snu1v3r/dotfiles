#!/usr/bin/env bash
source "${HOME}/.local/bin/shell-utils.sh"

install_packages imagemagick

case "${DISTRO}" in
    "arch")
        install_packages mariadb-libs postgresql-libs github-cli cargo clang llvm
        ;;
esac
