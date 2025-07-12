# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history         # share command history data between terminals

# enable completion features and sest menu selection and case insensitive as default completion options
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'



# Various settings for supporting VI mode in ZSH
# Enable vi-mode and set keytimeout
bindkey -v
export KEYTIMEOUT=1


# Set VIM as the default console editor
export VISUAL=nvim
export EDITOR="$VISUAL"


# Change cursor based on the mode 
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} == '' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}
bindkey "^R" history-incremental-search-backward




# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then 
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)" 
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions 
 
 
    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink 
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold 
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink 
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video 
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video 
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline 
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline 
 
    # Take advantage of $LS_COLORS for completion as well 
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" 
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31' 
fi

