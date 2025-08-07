#!/usr/bin/env bash

if [ ! "${PROFILE}" = "main" ]; then
    case "${FLAVOR}" in
        "arch")
            install_packages docker docker-compose
            ;;
        "debian")
            install_packages docker.io docker-compose
            ;;
    esac
    #
    # Limit log size to avoid running out of disk
    echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

    # Start Docker automatically
    sudo systemctl enable docker

    # Give this user privileged Docker access
    sudo usermod -aG docker ${USER}
fi
