#!/usr/bin/env bash
declare -a EXTRAS
if gum confirm "Install extra's?" --default="no";  then
	for FILE in ~/.local/share/dotfiles/install/extras/*; do
		TMP="${FILE%.*}"
		EXTRAS+=("${TMP##*/}")
	done;
	RESULT=$(gum choose "${EXTRAS[@]}" --no-limit --header="Choose the desired extras")
	for EXTRA in "${RESULT}"; do
		source ~/.local/share/dotfiles/install/extra${EXTRA}.sh
	done;
fi
