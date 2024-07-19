prompt_install() {
	echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg && echo
	if echo "$answer" | grep -iq "^y" ;then
		# This could def use community support
		if [ "$1" = "neovim" ]; then
			wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /tmp/nvim
			sudo chmod +x /tmp/nvim
			sudo mv -f /tmp/nvim /usr/bin/nvim
		elif [ -x "$(command -v apt-get)" ]; then
			sudo apt-get install $1 -y

		elif [ -x "$(command -v brew)" ]; then
			brew install $1

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install $1

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S $1

		else
			echo "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again. Tests for package managers are in the deploy script you just ran starting at line 13. Feel free to make a pull request at https://github.com/parth/dotfiles :)" 
		fi 
	fi
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if ! [ -x "$(command -v $1)" ]; then
		prompt_install $1
	else
		echo "$1 is installed."
	fi
}

check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ] ;then
			echo "Default shell is zsh."
	else
		echo -n "Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/n)"
		old_stty_cfg=$(stty -g)
		stty raw -echo
		answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
		stty $old_stty_cfg && echo
		if echo "$answer" | grep -iq "^y" ;then
			sudo chsh -s $(which zsh) $USER
		else
			echo "Warning: Your configuration won't work properly. If you exec zsh, it'll exec tmux which will exec your default shell which isn't zsh."
		fi
	fi
}

echo "We're going to do the following:"
echo "1. Grab dependencies"
echo "2. Check to make sure you have zsh, neovim, and tmux installed"
echo "3. We'll help you install them if you don't"
echo "4. We're going to check to see if your default shell is zsh"
echo "5. We'll try to change it if it's not" 

echo "Let's get started? (y/n)"
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	echo 
else
	echo "Quitting, nothing was changed."
	exit 0
fi

check_for_software zsh
echo
echo neovim is always reinstalled to make sure it is current 
prompt_install neovim
echo
check_for_software tmux
echo
check_for_software stow

check_default_shell


echo
echo -n "Would you like to backup your current dotfiles? (y/n) "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
	if [ -f "~/.zshrc" ]; then
		mv ~/.zshrc ~/.zshrc.old
	fi
	if [ -f "~/.tmux.conf" ]; then
		mv ~/.tmux.conf ~/.tmux.conf.old
	fi
	if [ -f "~/.vimrc" ]; then
		mv ~/.vimrc ~/.vimrc.old
	fi
else
	echo -e "\nNot backing up old dotfiles."
fi

echo Cloning the tmux setup
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo Cloning the NvChad repo for neovim
git clone https://github.com/NvChad/starter /tmp/nvchad
mkdir -p ~/.config/nvim
cp -R /tmp/nvchad/* ~/.config/nvim
rm -rf /tmp/nvchad



ln -sf $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/dotfiles/tmux/tmux.conf $HOME/.tmux.conf 
#ln -s $HOME/dotfiles/vim/vimrc.vim $HOME/.config/nvim/init.vim
printf "source-file $HOME/dotfiles/tmux/tmux.conf" > ~/.tmux.conf

echo Using stow for configurations
stow -t ~ -d ~/dotfiles/stowed_files .

echo
echo "For correct display of the fonts ensure that 'MesloLGS NF Regular' is selected."
echo "Please log out and log back in for default shell to be initialized."

# TODO: Iets doen
