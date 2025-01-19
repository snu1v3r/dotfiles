#!/usr/bin/env bash

get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | grep "tag_name" | cut -d'"' -f 4 | tr -d v
}

install_with_package_manager() {
	echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg && echo
	if echo "$answer" | grep -iq "^y" ;then

		if [ -x "$(command -v apt-get)" ]; then
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

install_neovim() {
	wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -O /tmp/nvim
	sudo chmod +x /tmp/nvim
	sudo mv -f /tmp/nvim /usr/bin/nvim

}

install_eza() {
	src=`pwd`
	cd /tmp
	wget https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O /tmp/eza.tgz
	tar xzvf /tmp/eza.tgz
	sudo chmod +x /tmp/eza
	sudo mv -f /tmp/eza /usr/bin/eza
	rm /tmp/eza.tgz
}

install_zoxide() {
	curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
}
install_lazygit() {
	src=`pwd`
	git clone https://github.com/jesseduffield/lazygit.git /tmp/lazygit --depth=1
	cd /tmp/lazygit
	make build
	sudo mv lazygit /usr/bin/lazygit
	cd $src
	rm -rf /tmp/lazygit
}

install_fzf() {
	src=`pwd`
	git clone https://github.com/junegunn/fzf.git /tmp/fzf
	cd /tmp/fzf
	make install
	sudo cp /tmp/fzf/bin/fzf /usr/bin/fzf
	cd $src
	rm -rf /tmp/fzf
}

install_batman() {
	src=`pwd`
	git clone https://github.com/eth-p/bat-extras.git /tmp/bat-extras
	cd /tmp/bat-extras
	./build.sh
	cd bin
	sudo cp * /usr/bin
	cd $src
	rm -rf /tmp/bat-extras
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if [ "$1" = "neovim" ]; then
		if ! command -v nvim 2>&1 >/dev/null; then
			install_neovim
		else
		  VER=`nvim -v | grep -nE 'NVIM'|cut -d'.' -f2`
		  if [ $VER -lt 10 ]; then
			  install_neovim
		  else
			  echo "Neovim is installed"
		  fi
		fi
	elif [ "$1" = "zoxide" ]; then
		if ! command -v zoxide 2>&1 >/dev/null; then
			install_zoxide
		fi
	elif [ "$1" = "fzf" ]; then
		if ! command -v fzf 2>&1 >/dev/null; then
			install_fzf
		fi
	elif [ "$1" = "batman" ]; then
		if ! command -v batman 2>&1 >/dev/null; then
			install_batman
		fi
	elif [ "$1" = "ripgrep" ]; then
		if ! command -v rg 2>&1 >/dev/null; then
			install_with_package_manager rg
		else
			echo "Ripgrep is installed"
		fi
	elif ! [ -x "$(command -v $1)" ]; then
		install_with_package_manager $1
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

echo Using stow for configurations
cd ~/dotfiles/stowed_files/config/
stow .
cd ~/dotfiles/stowed_files/local/
stow .

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

for app in zsh stow ripgrep neovim lazygit eza fzf zoxide bat batman
do
	check_for_software $app
done

check_default_shell

ln -sf $HOME/dotfiles/zsh/zshrc $HOME/.zshrc


echo
echo "For correct display of the fonts ensure that your prefered Nerd Font is selected."
echo "Please log out and log back in for default shell to be initialized."

