#!/usr/bin/env bash

install_packages imagemagick

case "${DISTRO}" in
    "arch")
        install_packages mariadb-libs postgresql-libs github-cli cargo clang llvm
        ;;
esac
