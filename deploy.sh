#!/usr/bin/bash

initialize(){
	BLACK=$'\033[0;30m'
	RED=$'\033[0;31m'
	GREEN=$'\033[0;32m'
	ORANGE=$'\033[0;33m'
	BLUE=$'\033[0;34m'
	PURPLE=$'\033[0;35m'
	CYAN=$'\033[0;36m'
	WHITE=$'\033[1;37m'
	CLEAR=$'\033[0m'

	DST=~/opt/bin
	if [ ! -d $DST ]; then
		mkdir -p $DST
	fi
}

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

log_yes_no(){
	echo
	read -p "${ORANGE}[?]${CLEAR} $1 (y/n) " -r -n 1
}


pm_install(){

		if [ -x "$(command -v apt-get)" ]; then
			sudo apt-get install $1 -y
		elif [ -x "$(command -v brew)" ]; then
			brew install $1
		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install $1
		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S $1
		else
			log_warning "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again." 
		fi 
}

pm_remove(){

		if [ -x "$(command -v apt-get)" ]; then
			sudo apt-get purge $1 -y

		elif [ -x "$(command -v brew)" ]; then
			brew uninstall $1

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg remove $1

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -R $1

		else
			echo "I'm not sure what your package manager is! Please install $1 on your own and run this deploy script again. Tests for package managers are in the deploy script you just ran starting at line 13. Feel free to make a pull request at https://github.com/parth/dotfiles :)" 
		fi 


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

print_usage() {
	echo
	log_info "Usage: $0 [-c|--clear] [-h|--help] [-f|--force]"
	echo

}

print_help() {
	print_usage
	log_info "Options:"
	log_spaced "  ${BLUE}-c, --clear ${CLEAR} Clear packages that might be installed by the package manager "
	log_spaced "  ${BLUE}-h, --help ${CLEAR} Show help for this script"
	log_spaced "  ${BLUE}-f, --force ${CLEAR} Force (re)installation of all applications"
	echo
}


install_with_package_manager() {
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
}

install_kitty() {
	if need_install "kitty" ; then
		curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
		ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten $DST
		cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
		cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
		sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
		sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
		echo 'kitty.desktop' > ~/.config/xdg-terminals.list
	fi
}

install_yazi() {
	if need_install "yazi" ; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
		rustup update
		cargo install --locked --git https://github.com/sxyazi/yazi.git yazi-fm yazi-cli
		sudo cp ~/.cargo/bin/ya ~/.cargo/bin/yazi ~/.local/bin
		sudo apt install -y ffmpeg p7zip jq
		log_success "Installed Yazi"
	fi
}
clean_kitty() {
	rm -rf ~/.local/kitty.app
	rm ~/.local/bin/kitt*
	rm ~/.local/share/applications/kitty*.desktop
}
install_neovim() {
	if need_install "nvim" "Neovim" ; then
		curl -sS -L --output /tmp/nvim https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
		chmod +x /tmp/nvim
		mv -f /tmp/nvim $DST
		log_success "Installed Neovim"
	fi

}

install_eza() {
	if need_install "eza" ; then
		curl -sS -L --output - https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz -C /tmp
		sudo mv -f /tmp/eza /usr/bin/eza
		cd -
		log_success "Installed Eza"
	fi
}

install_zoxide() {
	if need_install "zoxide" ; then
		curl -sS -L --output - https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
		log_success "Installed Zoxide"
	fi
}

install_lazygit() {
	if need_install "lazygit" ; then
		SUFFIX=Linux_x86_64
		TAGNAME=`curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r .name | cut -c2`
		curl -sS -L --output - "https://github.com/jesseduffield/lazygit/releases/download/v${TAGNAME}/lazygit_${TAGNAME}_${SUFFIX}.tar.gz" | tar xz -C /tmp
		sudo mv /tmp/lazygit /usr/bin/lazygit
		cd -
		log_success "Installed Lazygit"
	fi
}

install_ripgrep() {
	if need_install "rg" "Ripgrep" ; then
		SUFFIX=x86_64-unknown-linux-musl
		TAGNAME=`curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r .name` 
		curl -sS -L --output - "https://github.com/BurntSushi/ripgrep/releases/download/${TAGNAME}/ripgrep-${TAGNAME}-${SUFFIX}.tar.gz" | tar xz -C /tmp
		sudo mv /tmp/ripgrep-${TAGNAME}-${SUFFIX}/rg /usr/bin/rg
		rm -rf /tmp/ripgrep-${TAGNAME}-${SUFFIX}
		cd -
		log_success "Installed Ripgrep"
	fi
}

install_fzf() {
	if need_install "fzf" ; then
		SUFFIX=linux_amd64
		TAGNAME=`curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | jq -r .name`
		curl -sS -L --output - "https://github.com/junegunn/fzf/releases/download/v${TAGNAME}/fzf-${TAGNAME}-${SUFFIX}.tar.gz" | tar xz -C /tmp
		sudo mv /tmp/fzf /usr/bin
		cd -
		log_success "Installed FZF"
	fi
}

install_bat() {
	if need_install "bat" ; then
		BATSUFFIX=i686-unknown-linux-musl
		BATTAG=`curl -sS -L https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r .tag_name|cut -c2-`
		curl -sS -L --output - https://github.com/sharkdp/bat/releases/download/v${BATTAG}/bat-v${BATTAG}-${BATSUFFIX}.tar.gz | tar xz -C /tmp
		sudo mv /tmp/bat-v${BATTAG}-${BATSUFFIX}/bat /usr/bin
		log_success "Installed Bat"
	fi
}

install_batman() {
	if need_install "batman" ; then
		BATMANURL=`curl -s https://api.github.com/repos/eth-p/bat-extras/releases/latest | jq -r .assets\[0\].browser_download_url`
		curl -sS -L --output /tmp/batman.zip ${BATMANURL} 
		unzip /tmp/batman.zip -d /tmp
		sudo mv /tmp/bin/* /usr/bin/
		rm -rf /tmp/bin
		rm -rf /tmp/doc
		rm -rf /tmp/man
		cd -
		log_success "Installed bat-extras"
	fi
}

install_ghostty() {
	if need_install "ghostty"; then
		SUFFIX="amd64_bookworm"
		GHOSTTY_DEB_URL=$(
		   curl -s https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest | \
		   grep -oP "https://github.com/mkasberg/ghostty-ubuntu/releases/download/[^\s/]+/ghostty_[^\s/_]+_${SUFFIX}.deb")
		curl -L $GHOSTTY_DEB_URL -o /tmp/ghostty
		sudo dpkg -i /tmp/ghostty
		ln -s /usr/bin/ghostty $DST
		log_success "Installed Ghostty"
	fi
}

need_install() {
	if [ $# -gt 1 ]; then
		app=$2
	else
		app=$1
	fi
	if [ "$FORCE" = "true" ]; then
		log_warning "$app will be (re)installed"
		true
	else
		log_info "Checking to see if $app is installed"
		if ! command -v $1 2>&1 >/dev/null; then
			log_warning "$app is not installed"
			true
		else
			log_success "$app is already installed"
			false
		fi
	fi
}

check_for_software() {
	if [ "$1" = "neovim" ]; then
        install_neovim
	elif [ "$1" = "zoxide" ]; then
		install_zoxide
	elif [ "$1" = "fzf" ]; then
		install_fzf
	elif [ "$1" = "batman" ]; then
		install_batman
	elif [ "$1" = "bat" ]; then
		install_bat
	elif [ "$1" = "yazi" ]; then
		install_yazi
	elif [ "$1" = "kitty" ]; then
		install_kitty
	elif [ "$1" = "eza" ]; then
		install_eza
	elif [ "$1" = "lazygit" ]; then
		install_lazygit
	elif [ "$1" = "ripgrep" ]; then
		install_ripgrep
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
		log_yes_no "Default shell is not zsh. Do you want to chsh -s \$(which zsh)?"
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
	print_splash
	log_yes_no "Let's get started?"
	case "$REPLY" in 
		y|Y ) 
			echo
			echo $TE

			;;
		* ) 
			echo
			log_info "Quitting, nothing was changed."
			exit;;
	esac

	for app in build-essential curl jq zsh stow man unzip ripgrep neovim lazygit eza fzf zoxide bat batman yazi 
	do
		check_for_software $app
	done
	
	echo
	log_info "Using stow for configurations"
	mkdir ~/.local
	mkdir ~/.config
	cd ~/dotfiles/stowed_files/config/
	stow .
	cd ~/dotfiles/stowed_files/local/
	stow .

	check_default_shell

	ln -sf $HOME/dotfiles/zsh/zshrc $HOME/.zshrc


	echo

	log_yes_no "Do I need to install GUI applications?"
	case "$REPLY" in
		y|Y )
			check_for_software kitty
	 		check_for_software ghostty
			check_for_software poppler-utils
			check_for_software xclip
			;;
		* )
			echo
			log_info "No GUI applications are installed."
			;;
	esac

	log_warning "For correct display of the fonts ensure that your prefered Nerd Font is selected."
	log_warning "Please log out and log back in for default shell to be initialized."


}

initialize
print_title

case $1 in
	"")
		full_install
		;;
	-c|--clean)
		echo clean
		exit 0
		;;
	-f|--force)
		log_warning "Forcing (re)installation of all applications"
		echo
		FORCE=true
		full_install
		;;
	"")
		;;
	-h|--help)
		print_help
		;;
	*)	
		print_usage
		;;
esac



# TODO: add clean installation
# TODO: add ghostty to the configuration
# TODO: make difference between gui and non gui applications 
