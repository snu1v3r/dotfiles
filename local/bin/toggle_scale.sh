#!/usr/bin/env bash

scales=(1.0 1.5 2.0)
scale=$(niri msg -j outputs | jq .'["Virtual-1"]'.logical.scale)
for i in "${!scales[@]}"; do
	if [[ "${scales[i]}" == "${scale}" ]]; then
		echo "Found at index: $i" # Zero-based
		((i += 1 ))
		if [ $i -eq ${#scales[@]} ]; then
			i=0
		fi
		break
	fi
done
niri msg output Virtual-1 scale ${scales[$i]}
