alias saveclip='xclip -selection clipboard -t image/png -o > '
alias mount_shares='sudo vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other'
alias mc="mc --nosubshell"
alias ls='ls --color'
alias ll='ls -l'
alias la='ls -A'
alias lc='ls -CF'
alias vim="echo -ne '\e[1 q' ;vim" # Ensures that the cursor is a block cursor when intering vim (given the normal mode in which you enter vim)
alias vi='vim'

alias history="history 0" # force zsh to show the complete history

alias grep='grep -nH --color=auto' # Changes the grep command to enable colors and print linenumbers and filenames for the hits

alias force_dvorak='setxkbmap dvorak' # Changes keyboard setcting in X to dvorak. Needed to make VS code aware of layout
alias force_us='setxkbmap us' # Changes keyboard layout in X to US-International. Needed to make VS code aware of layout
