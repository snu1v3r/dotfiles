#!/usr/bin/env zsh

if [ $# -eq 1 ]; then
    PROMPT_APP=$1
else
    PROMPT_APP=$(gum choose --header "Please select the required prompt application:" Starship P10k Oh-my-posh | tr '[:upper:]' '[:lower:]')
fi


if [ -f "$HOME/.config/zsh/environment_overrides.zsh" ]; then
    if grep -q PROMPT_APP "$HOME/.config/zsh/environment_overrides.zsh"; then
        sed -i "s/PROMPT_APP=\(.*\)$/PROMPT_APP=$PROMPT_APP/g" $HOME/.config/zsh/environment_overrides.zsh
    else
        echo "export PROMPT_APP=$PROMPT_APP" >> $HOME/.config/zsh/environment_overrides.zsh
    fi
else
        echo "#!/usr/bin/env zsh\nexport PROMPT_APP=$PROMPT_APP" >> $HOME/.config/zsh/environment_overrides.zsh
fi

echo -e "\e[32m\n Prompt application is updated to: $PROMPT_APP\e[0m"
echo -e "\e[32m\n New setting will be available for each new shell.\e[0m"
