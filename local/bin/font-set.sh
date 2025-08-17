#!/bin/bash

# wofi not used anymor

font_name="$1"

if [[ -n "$font_name" && "$font_name" != "CNCLD" ]]; then
  if fc-list | grep -iq "$font_name"; then
    sed -i "s/family = \".*\"/family = \"$font_name\"/g" ~/.config/alacritty/alacritty.toml
    sed -i "s/font-family: .*/font-family: $font_name;/g" ~/.config/waybar/style.css
    sed -i "s/font-family: .*/font-family: $font_name;/g" ~/.config/swayosd/style.css
    sed -i "s/font=.*/font= $font_name;/g" ~/.config/mako/config
    sed -i "s/font-family: '.*'/font-family: '$font_name'/g" ~/.config/theme/current/wofi.css
    sed -i "s/font-family: '.*'/font-family: '$font_name'/g" ~/.local/share/themes/static/walker/own-default.css
    # xmlstarlet ed -L \
    #   -u '//match[@target="pattern"][test/string="monospace"]/edit[@name="family"]/string' \
    #   -v "$font_name" \
    #   ~/.config/fontconfig/fonts.conf

    ~/.local/bin/restart-waybar.sh
    ~/.local/bin/restart-swayosd.sh
    ~/.local/bin/restart-walker.sh
  else
    echo "Font '$font_name' not found."
    exit 1
  fi
else
  echo "Usage: font-set.sh <font-name>"
fi
