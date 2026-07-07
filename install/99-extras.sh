#!/usr/bin/env bash
if gum confirm "Install extra's?" --default="no";  then
	install-extras
fi
