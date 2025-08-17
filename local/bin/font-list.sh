#!/bin/bash

# fc-list generates a list of all fonts with spacing 100
# It only lists the first level (0 indexed) family name
# It preventes emoji and signwriting fonts
# Sorts the result and only returns unique items

fc-list :spacing=100 -f "%{family[0]}\n" | grep -v -i -E 'emoji|signwriting' | sort -u
