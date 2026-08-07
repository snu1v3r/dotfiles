#!/usr/bin/env bash
install_packages wireshark-qt ida-free ghidra gobuster netexec \
	nmap nmap-netcat python-pwntools pwncat pwndbg checksec ropper wordlists \
	dirbuster-wordlists hashcat hashcat-utils pocl john metasploit \
	rz-cutter wxhexeditor feroxbuster-bin hydra ffuf-bin tcpdump \
	wfuzz nfs-utils


# Desktop file has environment variable to enable proper scaling
# Desktop file has environment variable to fix empty interface
sudo tee "/usr/share/applications/ghidra.desktop" &>/dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Ghidra
Comment=A software reverse engineering framework
Exec=env _JAVA_OPTIONS='-Dsun.java2d.uiScale=2',_JAVA_AWT_WM_NONREPARENTING=1 ghidra %F
Icon=ghidra
Categories=Development;Debugger;
Terminal=False
MimeType=application/x-ghidra-project;
StartupNotify=true
StartupWMClass=ghidra-Ghidra
Keywords=ghidra,reverse,development,debugger,decompiler,disassembler,gdb,binary,analysis,engineering,security
EOF


# Desktop file has environment variable to enable proper scaling
sudo tee "/usr/share/applications/burpsuite.desktop" &>/dev/null <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Burp Suite Free Edition
Exec=env _JAVA_OPTIONS='-Dsun.java2d.uiScale=1.5' burpsuite
Icon=burpsuite
Comment=Burp Suite is an integrated platform for attacking web applications (free edition)
Categories=Development;Security
Terminal=false
MimeType=application/x-extension-iml;
EOF

OVERRIDES="${HOME}/.config/zsh/environment_overrides.zsh"
# Needed to ensure interface for ghidra is working
if ! grep -Eq '^export _JAVA_AWT_WM_NONREPARENTING' ${OVERRIDES}; then
	echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> "${OVERRIDES}"
fi
# Needed to ensure scaling of the interface works
if ! grep -Eq '^export _JAVA_OPTIONS' ${OVERRIDES}; then
	echo "export _JAVA_OPTIONS=\"-Dsun.java2d.uiScale=2\"" >> "${OVERRIDES}"
fi

if ! grep -Eq '^export HACKING' ${OVERRIDES}; then
	echo 'export HACKING_TOOLS=${HOME}/tools' >> ${OVERRIDES}
fi
if ! grep -Eq '^source \$\{HACKING' ${OVERRIDES}; then
	echo 'source ${HACKING_TOOLS}/helper-functions.sh' >> ${OVERRIDES}
fi


