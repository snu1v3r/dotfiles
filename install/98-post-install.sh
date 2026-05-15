#!/usr/bin/env bash

# Icons are placed in the correct location using the stow functionality
# This only ensures that the database is updated
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null || true # This catches a possible fail of the command

# Desktop files are placed in the correct location using the stow functionality
# This only ensures that the database is updated
if [ ! "${DISTRO}" = "ubuntu" ]; then
	update-desktop-database ~/.local/share/applications
fi

# This ensures that the font cache is updated
fc-cache
sudo updatedb

# This removes directory's I never use
tee -a ${HOME}/first_boot.sh &>/dev/null <<EOF
cd ~ && rm -rf Desktop Documents Music Pictures Public Templates Videos
systemctl --user disable first_boot.service
echo "Post install" >> ${HOME}/install.log
#rm "${HOME}/first_boot.service
#rm "${HOME}/first_boot.sh"
EOF


# This creates the necessary service file
mkdir -p "${HOME}/.config/systemd/user"
tee "${HOME}/.config/systemd/user/first_boot.service" &>/dev/null <<EOF
[Unit]
Description=First Boot Initialization Script
ConditionPathExists=${HOME}/first_boot.sh
After=default.target

[Service]
Type=oneshot
ExecStart=${HOME}/first_boot.sh

[Install]
WantedBy=default.target
EOF


# This starts the necessary service for first boot

systemctl --user daemon-reload
systemctl --user enable first_boot.service
