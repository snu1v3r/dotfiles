# This file is used to include git status in the prompt
# We start with this file, in order to be able to override stuff
source ~/dotfiles/zsh/utils/git_prompt.sh

# First we define several color code macro's

THEME_COLOR_GREEN="%F{green}"
THEME_COLOR_RED="%F{red}"
THEME_COLOR_BLUE="%F{blue}"
THEME_COLOR_ORANGE="%F{208%}"
THEME_COLOR_WHITE="%F{white}"
THEME_BOLD="%B"
THEME_NORMAL="%b"
USER_AT=㉿ # '\U327F'
ROOT_AT=💀 # '\U1F480'
ERROR=✗
NO_ERROR=✔
PROMPT_ICON="$"
NEW_LINE=$'\n'

# Select the various color's for the various items
COLOR_LINES="$THEME_NORMAL%(#.$THEME_COLOR_BLUE.$THEME_COLOR_GREEN)" # Line color changes for root
COLOR_USER="$THEME_BOLD%(#.$THEME_COLOR_RED.$THEME_COLOR_BLUE)" # User prompt color changer for root
COLOR_TIME="$THEME_NORMAL$THEME_COLOR_ORANGE"
COLOR_VPN="$THEME_NORMAL$THEME_COLOR_ORANGE"
COLOR_NORMAL="$THEME_COLOR_WHITE"
NORMAL="$THEME_NORMAL$COLOR_NORMAL"

# Create the various context dependent prompt parts

USER_AT_HOST="$COLOR_USER%n%(#.$ROOT_AT.$USER_AT)%m$COLOR_LINES"
TIME="$ZSH_COLOR_TIME%D{%T}$COLOR_LINES"
EXIT="%(?.$THEME_BOLD$THEME_COLOR_GREEN$NO_ERROR.$THEME_BOLD$THEME_COLOR_RED$ERROR:%?)$COLOR_LINES"
GIT_PROMPT='$(git_super_status)'$COLOR_LINES
FORMATTED_PATH="$THEME_BOLD$COLOR_NORMAL%(6~.%-1~/…/%4~.%5~)$COLOR_LINES"
if [[ ! -z $(ip a show tun0 up 2>/dev/null) ]]
then
    TUN0=[$COLOR_VPN'$(ip addr show dev tun0 2>/dev/null | /usr/bin/grep -oP "inet [^/]+" | cut -d" " -f2)'$COLOR_LINES]
else
    TUN0=''
fi
# Disable standard virtual env in prompt and put in custom


venv_status () {
    if [ ! -z $VIRTUAL_ENV ]
    then 
        echo -n '<'; basename -z $VIRTUAL_ENV; echo -n '>'
    fi
}
export VIRTUAL_ENV_DISABLE_PROMPT=true
VENV=$COLOR_NORMAL'$(venv_status)'$COLOR_LINES
# Create the final prompt
PROMPT="$COLOR_LINES┌─[$USER_AT_HOST]─[$TIME]─[$EXIT]─$TUN0$GIT_PROMPT$VENV─[$FORMATTED_PATH]$NEW_LINE$PROMPT_ICON$NORMAL "
