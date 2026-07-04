#!/usr/bin/env bash

# Use dark mode for QT apps too (like VLC and kdenlive)
if [ ! "${PROFILE}" = "headless" ]; then
    case "${DISTRO}" in
        "arch")
			if [ ! "${DISPLAYMANAGER}" = "niri" ]; then
				install_packages kvantum-qt5 gnome-themes-extra
			fi
            ;;
        "debian"|"ubuntu")
            install_packages qt5-style-kvantum gnome-themes-extra
            ;;
    esac

	gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
	gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

	# Download Random background
	mkdir -p "${HOME}/.local/share/backgrounds"
	if [ "${DISPLAYMANAGER}" = "niri" ]; then
		case "${PROFILE}" in
			"basevm")
				SHOTID="0076"
				;;
			"main")
				SHOTID="0052"
				;;
			*)
				SHOTID=$(printf "%04d" $((1 + RANDOM % 100)))
				;;
		esac
	fi
	curl "https://raw.githubusercontent.com/snu1v3r/backgrounds/main/${SHOTID}.jpg" --output "${HOME}/.local/share/backgrounds/${SHOTID}.jpg"

	case "${DISPLAYMANAGER}" in
		"gnome")
			gsettings set org.gnome.desktop.background picture-uri "file:///${HOME}/.local/share/backgrounds/${SHOTID}.jpg"
			gsettings set org.gnome.desktop.background picture-uri-dark "file:///${HOME}/.local/share/backgrounds/${SHOTID}.jpg"
			;;
		"niri")
			tee -a "${HOME}/first_boot.sh" &>/dev/null <<- EOF
			dms ipc call wallpaper set "${HOME}/.local/share/backgrounds/${SHOTID}.jpg"
			DMS_PRIVESC=sudo dms greeter sync -t
			EOF
			;;
	esac

fi

# Set initial theme
mkdir -p ~/.config/theme
ln -snf ~/.local/share/themes/dynamic/tokyo-night ~/.config/theme/current
ln -snf $(find ~/.config/theme/current/backgrounds -type f -print -quit) ~/.config/theme/background

# Set specific app links for current theme
ln -snf ~/.config/theme/current/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
mkdir -p ~/.config/btop/themes
ln -snf ~/.config/theme/current/btop.theme ~/.config/btop/themes/current.theme
mkdir -p ~/.config/mako
ln -snf ~/.config/theme/current/mako.ini ~/.config/mako/config
mkdir -p ~/.config/bat/themes
ln -snf ~/.config/theme/current/bat-theme.tmTheme ~/.config/bat/themes/bat-theme.tmTheme
bat cache --build
