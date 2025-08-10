#!/bin/bash

pkill slurp || hyprshot -m ${1:-region} --raw |
  satty --filename - \
    --early-exit \
    --copy-command 'wl-copy'

