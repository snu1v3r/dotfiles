#!/usr/bin/env bash
if [ -f "${HOME}/.local/bin/helper-functions.sh" ]; then
	source "${HOME}/.local/bin/helper-functions.sh"
else
	if [[ -z "${REPO}" ]]; then
		source <(curl -s https://raw.githubusercontent.com/snu1v3r/dotfiles/main/local/bin/helper-functions.sh)
	else
		source <(curl -s https://raw.githubusercontent.com/snu1v3r/dotfiles/${REPO}/local/bin/helper-functions.sh)
	fi
fi
log_info "Cloning Dotfiles..."
if ! command -v git &>/dev/null ; then
    log_info "Installing git..."
    install_packages git
fi
rm -rf ~/.local/share/dotfiles/


if [[ -z "${REPO}" ]]; then
	# This is kept for the final version
	git clone --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null
else
	git clone -b "${REPO}" --recurse-submodules --shallow-submodules https://github.com/snu1v3r/dotfiles.git ~/.local/share/dotfiles >/dev/null
fi


log_info "Installation of individual scripts starting..."

log_info "Distribution used is: ${DISTRO}"

# Install everything
for f in ~/.local/share/dotfiles/install/*.sh; do
  log_info "Starting $f"
  # Set trap before sourcing
  trap 'log_error $LINENO $?' ERR
  source "$f"
done

log_info "Installation finished."

gum confirm "Reboot to apply all settings?" && sudo reboot
