# Include command suggestions in the prompt
if [ -f $HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . $HOME/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

