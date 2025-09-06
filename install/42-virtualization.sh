#!/usr/bin/env bash
if [ ! "${PROFILE}" = "main" ]; then
    # In all cases where it is installed as a vm we will need the agent
    install_packages spice-vdagent
fi
    
