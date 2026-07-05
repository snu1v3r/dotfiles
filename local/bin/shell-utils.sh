#!/usr/bin/env bash
# First we determine some general settings
BLACK=$'\033[0;30m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
ORANGE=$'\033[0;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[1;37m'
CLEAR=$'\033[0m'

if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO=${ID}
fi


log_info() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${BLUE}[i]${CLEAR} $1" | tee -a "${HOME}/install.log"
    else
        echo -e "${BLUE}[i]${CLEAR} $1"
    fi
}

log_warning() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${ORANGE}[!]${CLEAR} $1" | tee -a "${HOME}/install.log"
    else
        echo -e "${ORANGE}[!]${CLEAR} $1"
    fi
}

log_success() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${GREEN}[*]${CLEAR} $1" | tee -a "${HOME}/install.log"
    else
        echo -e "${GREEN}[*]${CLEAR} $1"
    fi
}

log_error() {
    if [[ "${BASH_SOURCE[1]}" =~ "/dev/fd" ]] || [[ "${BASH_SOURCE[1]}" =~ "install.sh" ]]; then 
        echo -e "$(date +%T) ${RED}[E]${CLEAR} $1" | tee -a "${HOME}/install.log"
    else
        echo -e "${RED}[E]${CLEAR} $1"
    fi
}

install_packages() {
    case "${DISTRO}" in 
        "debian"|"ubuntu"|"kali")
            sudo apt-get install -y $@
            ;;
        "macos")
            brew install $@
            ;;
        "alpine")
            sudo pkg install $@
            ;;
        "arch")
            if [ -x "$(command -v yay)" ]; then
                yay --noconfirm --needed -S $@
            else
                sudo pacman --noconfirm --needed -S $@
            fi
            ;;
        *)
            install_warning "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again."
    esac
}

