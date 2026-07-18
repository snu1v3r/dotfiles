#!/usr/bin/env bash
install_packages wireshark-qt ida-free ghidra gobuster netexec \
	nmap nmap-netcat python-pwntools pwncat pwndbg checksec ropper wordlists \
	dirbuster-wordlists hashcat hashcat-utils john metasploit \
	rz-cutter

# Needed to ensure interface for ghidra is working
echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> "${HOME}/.config/zsh/environment_overrides.sh"
