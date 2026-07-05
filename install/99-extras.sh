#!/usr/bin/env bash
declare -a EXTRAS
if gum confirm "Install extra's?" --default="no";  then
	for FILE in ~/.local/share/dotfiles/install/extras/*; do
		TMP="${FILE%.*}"
		EXTRAS+=("${TMP##*/}")
	done;
	mapfile -t RESULT < <(gum choose "${EXTRAS[@]}" --no-limit --header="Choose the desired extras")
	for EXTRA in "${RESULT[@]}"; do
	    log_info "Starting ${EXTRA}.sh"
		source "${HOME}/.local/share/dotfiles/install/extras/${EXTRA}.sh"
	done;
fi
