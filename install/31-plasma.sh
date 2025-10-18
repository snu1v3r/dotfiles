if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "plasma" ] && [ ! "${PROFILE}" = "headless" ]; then
	install_packages plasma-meta plasma-x11-session
fi

