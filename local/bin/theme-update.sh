#!/bin/bash

for dir in ~/.local/share/themes/dynamic/*/; do
  [ -d "$dir" ] && [ ! -L "${dir%/}" ] && echo "Updating: $(basename "$dir")" && git -C "$dir" pull
done
