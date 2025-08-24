#!/usr/bin/env zsh
source "${HOME}/.local/bin/shell-utils.sh"

case "${DISTRO}" in
    "arch")
        install_packages docker docker-compose lazydocker
        ;;
    "debian")
        install_packages docker.io docker-compose
        SUFFIX=Linux_x86_64
        TAGNAME=$(wget -qO- https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | jq -r .name | cut -c2-)
        if [ ! -z "${TAGNAME}" ]; then
            wget -qO- "https://github.com/jesseduffield/lazydocker/releases/download/v${TAGNAME}/lazydocker_${TAGNAME}_${SUFFIX}.tar.gz" | tar xz -C /tmp
            sudo mv /tmp/lazydocker /usr/bin/lazydocker
        fi
        ;;
esac
#
# Limit log size to avoid running out of disk
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json

# Start Docker automatically
sudo systemctl enable docker

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}
