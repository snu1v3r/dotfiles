if [ "${DISTRO}" = "arch" ] && [ "${DISPLAYMANAGER}" = "kde" ] && [ ! "${PROFILE}" = "headless" ]; then
	install_packages plasma-meta plasma-x11-session
fi

