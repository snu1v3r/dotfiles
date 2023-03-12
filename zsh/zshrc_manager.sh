# First check if tmux is installed
# Next check if tmux is not disabled
# Next check that we are not sourcing .zshrc as part of tmux initialization
# Last check that we are not a vscode terminal
# Otherwise attach to existing tmux session


# export DISABLE_TMUX=true
export LANG=en_US.UTF-8

if command -v tmux>/dev/null; then
	if [ "$DISABLE_TMUX" = "true" ]; then
		echo "TMUX is disabled through the environment"
	else
        if [[ -z "$TMUX" ]]; then
		    if [[ "$TERM_PROGRAM" != "vscode" ]]; then
                if [ `tmux ls 2>&1 | wc -l` -gt 1 ]; then
                    tmux choose-session
                    tmux attach
                else
                    tmux new-session -A -s main
                fi
            fi
        fi
    fi
else 
	echo "tmux not installed. Run ./deploy to configure dependencies"
fi

source ~/dotfiles/zsh/zshrc.sh
source ~/dotfiles/zsh/syntax.sh
source ~/dotfiles/zsh/prompt.sh
source ~/dotfiles/zsh/aliases.sh
#source ~/dotfiles/zsh/utils/zsh-vi-mode.plugin.zsh
