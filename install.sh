#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install_file {
	if [ $(readlink -f $2) = $DIR/$1 ]; then
		echo "$1 is already installed, skipping..."
		return
	fi
	FILE_DIR=$(dirname $2)
	if [ ! -d $FILE_DIR ]; then
		echo "Creating $FILE_DIR"
		mkdir -p $FILE_DIR
	elif [ -f $2 ]; then
		echo "Moving old $2 to $2.orig"
		mv $2 $2.orig
	fi
	echo "Symlinking $1"
	ln -s $DIR/$1 $2
}

echo "Installing awesome config..."
install_file awesome/rc.lua ~/.config/awesome/rc.lua
install_file awesome/themes/jazzpi ~/.config/awesome/themes/jazzpi

echo "Installing Neovim config..."
install_file nvim/init.vim ~/.config/nvim/init.vim
install_file nvim/ftplugin/markdown.vim ~/.config/nvim/ftplugin/markdown.vim
install_file nvim/ftplugin/tex.vim ~/.config/nvim/ftplugin/tex.vim
echo "Downloading vim-plug"
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Installing plugins"
nvim -c "PlugInstall | qa"

echo "Installing Xresources..."
install_file Xresources ~/.Xresources

echo "Installing tmux config..."
install_file tmux.conf ~/.tmux.conf

echo "Installing ZSH config..."
install_file zsh/zshrc ~/.zshrc
install_file zsh/zshenv ~/.zshenv

echo "Installing Spacemacs config..."
install_file spacemacs ~/.spacemacs
