
# Power control settings are not usefull in a headless environment, because this will be a container

if [ "${PROFILE}" = "main" ];then
# Setting the performance profile can make a big difference. By default, most systems seem to start in balanced mode,
# even if they're not running off a battery. So let's make sure that's changed to performance.
    install_packages power-profiles-daemon
    powerprofilesctl set balanced
fi

