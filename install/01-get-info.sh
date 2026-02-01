#!/usr/bin/env bash
if ! command -v gum &>/dev/null ; then
    install_info "Installing gum..."
	if [[ "${DISTRO}" =~ ^(debian|ubuntu) ]]; then
        install_packages jq
        GUMTAG=$(wget -qO- https://api.github.com/repos/charmbracelet/gum/releases/latest | jq -r .tag_name | cut -c2-)
        wget -q -O /tmp/gum.deb https://github.com/charmbracelet/gum/releases/download/v${GUMTAG}/gum_${GUMTAG}_amd64.deb
        sudo dpkg -i /tmp/gum.deb
        rm /tmp/gum.deb
    else
        install_packages jq gum
    fi
fi

if [ -f "${HOME}/install.conf" ]; then
    install_info "Continueing from previous install taking settings form install.conf"
    source "${HOME}/install.conf"
else
    # Configure identification
    echo -e "\nEnter identification for git and autocomplete..."
    USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
    USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

    install_info "Installing for user: $USER_NAME"
    install_info "Using e-mail: $USER_EMAIL"

    # Select profile
    if [ "$PROFILE" = "" ]; then
      RESULT=$(gum choose Main BaseVM Headless --header="Select the target profile:")
      if [ "$RESULT" = "" ]; then
        PROFILE="main"
      else
        PROFILE=${RESULT,,} # This lowercases the argument
      fi
    fi
    install_info "The following profile is used: $PROFILE"

	# Select DM
	if [ "${DISTRO}" = "arch" ] && [ ! "${PROFILE}" = "headless" ]; then
		RESULT=$(gum choose Hyprland Plasma Gnome --header="Select Displaymanager:")
		if [ "${RESULT}" = "" ]; then
			DISPLAYMANAGER="hyprland"
		else
			DISPLAYMANAGER=${RESULT,,}
		fi
		install_info "The following displaymanager is used: $DISPLAYMANAGER"
	fi

    if [ ! "${PROFILE}" = "headless" ]; then
        # Select target resolution
        RESOLUTION=$(gum choose "3440x1440" "2880x1800" "2560x1440" "1920x1080" "MULTI" --header="Select the target resolution:")
        install_info "The following resolution is used: $RESOLUTION"
    fi
    tee ${HOME}/install.conf &>/dev/null <<- EOF
	USER_NAME=${USER_NAME}
	USER_EMAIL=${USER_EMAIL}
	PROFILE=${PROFILE}
	RESOLUTION=${RESOLUTION}
	DISPLAYMANAGER=${DISPLAYMANAGER}
	EOF
fi
