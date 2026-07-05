#!/usr/bin/env bash
if [ -f "${HOME}/.local/bin/shell-utils.sh" ]; then
	source "${HOME}/.local/bin/shell-utils.sh"
else
	if [[ -z "${REPO}" ]]; then
		source <(curl -s https://raw.githubusercontent.com/snu1v3r/dotfiles/main/local/bin/shell-utils.sh)
	else
		source <(curl -s https://raw.githubusercontent.com/snu1v3r/dotfiles/${REPO}/local/bin/shell-utils.sh)
	fi
fi
log_info "Cloning Dotfiles..."
if ! command -v git &>/dev/null ; then
    install_info "Installing git..."
    install_packages git
fi
rm -rf ~/.local/share/dotfiles/


if [[ -z "${REPO}" ]]; then
	# This is kept for the final version
	git clone --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null
else
	git clone -b "${REPO}" --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null
fi


install_info "Installation of individual scripts starting..."

install_info "Distribution used is: ${DISTRO}"

# Install everything
for f in ~/.local/share/dotfiles/install/*.sh; do
  install_info "Starting $f"
  # Set trap before sourcing
  trap 'install_error $LINENO $?' ERR
  source "$f"
done

install_info "Installation finished."

gum confirm "Reboot to apply all settings?" && sudo reboot
