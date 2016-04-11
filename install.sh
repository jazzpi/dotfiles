#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function install_file {
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

echo "Installing Neovim config..."
install_file nvim/init.vim ~/.config/nvim/init.vim
install_file nvim/ftplugin/markdown.vim ~/.config/nvim/ftplugin/markdown.vim

echo "Installing Xresources..."
install_file Xresources ~/.Xresources
