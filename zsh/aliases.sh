alias saveclip='xclip -selection clipboard -t image/png -o > '
alias mount_shares='sudo vmhgfs-fuse .host:/ /mnt/hgfs -o allow_other'
alias mc="mc --nosubshell"
alias ls='ls --color'
alias ll='ls -l'
alias la='ls -A'
alias lc='ls -CF'
alias vi='nvim'
alias vim='nvim'
alias history="history 0" # force zsh to show the complete history

alias grep='grep -nH --color=auto' # Changes the grep command to enable colors and print linenumbers and filenames for the hits

alias force_dvorak='setxkbmap dvorak' # Changes keyboard setting in X to dvorak. Needed to make VS code aware of layout
alias force_us='setxkbmap us' # Changes keyboard layout in X to US-International. Needed to make VS code aware of layout

alias toggle_keyboard='test_keyboard=`setxkbmap -print | grep dvorak` ; if [[ $test_keyboard ]]; then setxkbmap us; else setxkbmap dvorak; fi' # This can be used to toggle the keyboard setting

# This function enables a tail for a file with a specific search string. Time is printed when the string is found
# Usage:    follow <file name to follow> <string to search for>
myfunction() {
	tail -f $1 | grep --colour --line-buffered $2 | awk '{print strftime("%c") " " $0}'
	}

alias follow=myfunction

alias clean_codes='sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"'

alias convert-markdown='python3 ~/dotfiles/markdown/convert_markdown.py'
