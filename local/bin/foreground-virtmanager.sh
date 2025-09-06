#!/usr/bin/env bash
if pgrep -f 'python3 /usr/bin/virt-manager'; then (hyprctl -j clients | jq 'map(select(.title == "Virtual Machine Manager")) [0].workspace.id' | xargs hyprctl dispatch workspace) else (hyprctl dispatch exec virt-manager) fi
