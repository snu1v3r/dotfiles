#!/usr/bin/env bash
source "${HOME}/.local/bin/shell-utils.sh"

# If it is a main machine it is likely that we will use it as a virtualization host
install_packages virt-manager passt
# Notes with respect to Qemu
# Qemu can be use with a qemu:///system connection string or a qemu:///session
# connection string qemu:///system has full networking capabilities, but has to be started with system user privileges.
# qemu:///session can be started as a regular user. Only downside is limited networking capabilities. This doesn't directly affect outgoing connections, but limits incoming connections. To enable incomming connection within a qemu:///session
# connection string the passt application together with portforwarding is used. 
# passt is installed in the section above.
# Furthermore the .xml file for the NIC in the virt-manager needs to be modified
# to setup port forwarding. An example is given below. The two relevant elements are <portForward...> and <backend...>
#
# ```xml
# <interface type="user">
#   <mac address="52:54:00:a4:85:7d"/>
#   <portForward proto="tcp">
#     <range start="4022" to="22"/>
#   </portForward>
#   <model type="rtl8139"/>
#   <backend type="passt"/>
#   <alias name="net0"/>
#   <address type="pci" domain="0x0000" bus="0x10" slot="0x01" function="0x0"/>
# </interface>
# ```
case "${DISTRO}" in
    "arch")
        install_packages qemu-base qemu-desktop dnsmasq
        ;;
    "debian"|"ubuntu")
        install_packages qemu-system-gui qemu-system-q86 dnsmasq \
            qemu-user qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
        ;;
esac
sudo systemctl enable libvirtd.service
