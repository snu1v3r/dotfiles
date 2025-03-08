#!/usr/bin/bash

BLACK=$'\033[0;30m'
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
ORANGE=$'\033[0;33m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[1;37m'
CLEAR=$'\033[0m'

log_info(){
	echo -e "$BLUE[i]$CLEAR $1"
}

log_warning(){
	echo -e "$ORANGE[!]$CLEAR $1"
}

log_success(){
	echo -e "$GREEN[*]$CLEAR $1"
}


log_spaced(){
	echo "    $1"
}


print_title(){
	echo -e "${PURPLE}================================================${CLEAR}"
	echo -e "${PURPLE}=====  USER ENVIRONMENT DEPLOYMENT SCRIPT  =====${CLEAR}"
	echo -e "${PURPLE}================================================${CLEAR}"
	echo

}
print_splash(){
	log_info "We're going to do the following:"
	echo
	log_spaced "1. Grab dependencies"
	log_spaced "2. Check to make sure you have zsh, neovim, and tmux installed"
	log_spaced "3. We'll help you install them if you don't"
	log_spaced "4. We're going to check to see if your default shell is zsh"
	log_spaced "5. We'll try to change it if it's not" 
}

print_help() {
	print_title
	echo -e "Usage: $0 [-c|--clear]"
	echo
	print_splash
	echo
	echo -e "Options:"
	echo -e "  ${BLUE}-c, --clear ${CLEAR} Clear packages that might be installed by the package manager "
	echo
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

install_kitty() {
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
	cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
	cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
	sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
	echo 'kitty.desktop' > ~/.config/xdg-terminals.list
}

install_yazi() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup update
	cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli
	sudo cp ~/.cargo/bin/ya ~/.cargo/bin/yazi /usr/bin
	sudo apt install ffmpeg p7zip jq poppler-utils xclip
}
clean_kitty() {
	rm -rf ~/.local/kitty.app
	rm ~/.local/bin/kitt*
	rm ~/.local/share/applications/kitty*.desktop
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
	log_info "Checking to see if $1 is installed"
	if [ "$1" = "neovim" ]; then
		if ! command -v nvim 2>&1 >/dev/null; then
			install_neovim
		else
		  VER=`nvim -v | grep -nE 'NVIM'|cut -d'.' -f2`
		  if [ $VER -lt 10 ]; then
			  install_neovim
		  else
			  log_success "Neovim is installed"
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
	elif [ "$1" = "yazi" ]; then
		if ! command -v yazi 2>&1 >/dev/null; then
			install_yazi
		fi
	elif [ "$1" = "kitty" ]; then
		if ! command -v kitty 2>&1 >/dev/null; then
			install_kitty
		fi
	elif [ "$1" = "ripgrep" ]; then
		if ! command -v rg 2>&1 >/dev/null; then
			install_with_package_manager rg
		else
			log_success "Ripgrep is installed"
		fi
	elif ! [ -x "$(command -v $1)" ]; then
		install_with_package_manager $1
	else
		log_success "$1 is installed."
	fi
}

check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ] ;then
			echo 
			log_info "Default shell is zsh."
	else
		echo
		read -p "${ORANGE}[?]${CLEAR} Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/n) " -r -n 1
		case "$REPLY" in
			y|Y )
				sudo chsh -s $(which zsh) $USER;;
			* ) echo
				log_warning "Your configuration won't work properly. If you exec zsh, it'll exec tmux which will exec your default shell which isn't zsh."
				exit;;
		esac
	fi
}

full_install() {
	print_title
	print_splash

	echo
	read -p "${ORANGE}[?]${CLEAR} Let's get started? (y/n) " -r -n 1
	case "$REPLY" in 
		y|Y ) 
			echo ;;
		* ) 
			echo
			log_info "Quitting, nothing was changed."
			exit;;
	esac




	for app in zsh stow ripgrep neovim lazygit eza fzf zoxide bat batman kitty yazi
	do
		check_for_software $app
	done
	
	echo
	log_info "Using stow for configurations"
	cd ~/dotfiles/stowed_files/config/
	stow .
	cd ~/dotfiles/stowed_files/local/
	stow .

	check_default_shell

	ln -sf $HOME/dotfiles/zsh/zshrc $HOME/.zshrc


	echo
	log_warning "For correct display of the fonts ensure that your prefered Nerd Font is selected."
	log_warning "Please log out and log back in for default shell to be initialized."


}


if [ $# -eq 0 ]; then
	full_install
	exit 0 
fi

case $1 in
	-c|--clean)
		echo clean
		exit 0
		;;
	*)	
		print_help
esac


# TODO: add clean installation
