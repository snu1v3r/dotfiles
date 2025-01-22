#!/usr/bin/env bash

get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | grep "tag_name" | cut -d'"' -f 4 | tr -d v
}

confirm() {
	# Returns true or false
	# Can be called with an optional prompt
    read -r -p "[?] ${1:-Are you sure?} [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

missing_app() {
	# Checks if an application is missing
	# If a second (optional) argument is used, then this argument will be used in the output message
	if command -v $1 > /dev/null; then
	 	if [ -z "$2" ]; then	
			echo "[>] $1 is installed"
		else
			echo "[>] $2 is installed"
		fi
		false
	else
	 	if [ -z "$2" ]; then
			echo "[>] installing $1"
		else 
			echo "[>] installing $2"
		fi
		true
	fi
}

install_with_package_manager() {
	if missing_app $1; then
		echo "[i] Trying to install $1"
		if [ -x "$(command -v apt-get)" ]; then
			sudo apt-get install $1 -y

		elif [ -x "$(command -v brew)" ]; then
			brew install $1

		elif [ -x "$(command -v pkg)" ]; then
			sudo pkg install $1

		elif [ -x "$(command -v pacman)" ]; then
			sudo pacman -S $1

		else
			echo "[!] I'm not sure what your package manager is!"
			echo "[!] Please install $1 on your own and run this deploy script again."
		fi 
	fi
}

install_neovim() {
	if missing_app nvim neovim; then
		curl --silent -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $workdir/nvim
		chmod +x $workdir/nvim
		sudo mv $workdir/nvim /usr/bin/nvim
	fi
}

install_eza() {
	if missing_app eza; then
		curl --silent -L https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -o $workdir/eza.tgz
		tar xzf $workdir/eza.tgz -C $workdir
		sudo mv -f $workdir/eza /usr/bin/eza
	fi
}

install_zoxide() {
	if missing_app zoxide; then
		curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
	fi
}

install_lazygit() {
	if missing_app lazygit; then
		lazygit_repo="jesseduffield/lazygit"
		latest=`get_latest_release $lazygit_repo`
		curl --silent -L "https://github.com/$lazygit_repo/releases/download/v$latest/lazygit_${latest}_Linux_x86_64.tar.gz" -o $workdir/lg.tgz
		tar -xzvf $workdir/lg.tgz -C $workdir
		sudo mv $workdir/lazygit /usr/bin
	fi
}

install_fzf() {
	if missing_app fzf; then
		fzf_repo="junegunn/fzf"
		latest=`get_latest_release $fzf_repo`
		echo "Getting release $latest from $fzf_repo"
		curl --silent -L "https://github.com/$fzf_repo/releases/download/v$latest/fzf-${latest}-linux_amd64.tar.gz" -o $workdir/fzf.tgz
		tar xzf $workdir/fzf.tgz -C $workdir
		sudo mv $workdir/fzf /usr/bin/fzf
	fi 
}

install_bat() {
	if missing_app bat; then
		bat_repo="sharkdp/bat"
		latest=`get_latest_release $bat_repo`
		echo "Getting release $latest from $bat_repo"
		curl --silent -L "https://github.com/$bat_repo/releases/download/v$latest/bat_${latest}_amd64.deb" -o $workdir/bat.deb
		sudo dpkg -i $workdir/bat.deb
	fi
}

install_bat_extras() {
	if missing_app batman bat-extras; then
		bat_extras="eth-p/bat-extras"
		latest=`get_latest_release $bat_extras`
		echo "Getting release $latest from $bat_extras"
		curl -L "https://github.com/$bat_extras/archive/refs/tags/v$latest.tar.gz" -o $workdir/batextras.tgz
		tar xzvf $workdir/batextras.tgz -C $workdir
		sudo $workdir/bat-extras-$latest/build.sh --install --no-verify
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

echo "[*] Manual installation of dotfiles from 'https://github.com/snu1v3r'"

echo 
echo "[i] We're going to do the following:"
echo "      1. Grab dependencies"
echo "      2. Check to make sure you have zsh, neovim, tmux, fzf, bat, bat-extra, lazygit are installed"
echo "      3. Install any missing applications"
echo "      4. Pull relevant configuration files from github"
echo "      5. Create symbolic links to the relevant environment files"
echo "      6. Set 'zsh' as the default"
echo 
echo "[!] sudo privileges are needed to complete the above steps"
echo 

if ! confirm "Shall we get started?"; then
	echo "[*] Nothing is changed"
	exit 1
fi

if  [ "$1" != "--force" ]; then
	if [ -d dotfiles ] || [ `pwd | awk -F / '{print $NF}'` == dotfiles ]; then
		echo "[!] dotfiles directory already exists. Execute with the '--force' to force execution" 
		exit 1
	fi
fi

echo 
echo "[i] First installing applications from the package manager"
echo

for app in git zsh stow
do
	install_with_package_manager $app
done

echo 
echo "[i] Verifying existence of dotfiles repository"
echo 

if [ -d dotfiles ]; then
	cd dotfiles
fi

if ! [ `pwd | awk -F / '{print $NF}'` == dotfiles ]; then
	git clone --recurse-submodules https://github.com/snu1v3r/dotfiles.git
	cd dotfiles
fi

echo
echo "[i] Next installing the specials"
echo

workdir=/tmp/dotfiles
mkdir $workdir

install_neovim
install_zoxide
install_eza
install_bat
install_bat_extras
install_lazygit
install_fzf
install_lazygit

echo 
echo "[i] Using stow for configuration files"
cd stowed_files/config/
stow .
echo "[i] Using stow for local files"
cd ../local/
stow .

check_default_shell

cd ../../
ln -sf dotfiles/zsh/zshrc $HOME/.zshrc

echo
echo "[i] For correct display of the fonts ensure that your prefered Nerd Font is selected."
echo "[i] Please log out and log back in for default shell to be initialized."
echo
echo "[i] Cleaning up"
sudo rm -rf $workdir
echo 
echo "[i] Finished"