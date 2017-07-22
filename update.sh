#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Stop on first error
set -e
if [ "$(uname)" == "Darwin" ]; then
	# Update brew stuff
	{
		brew update
		brew upgrade
		brew cleanup
		brew prune
		brew cask cleanup
	} || {
	echo "$BOLD $GREEN Brew is not installed $RESET"
}
fi

function gcommit() {
	{
		git add -A .
		git commit -m "Updating dotfiles..."
	} || {
	echo "$BOLD $GREEN Noting to commit... $RESET"
}
}

# Copy the required files to `dotfiles`
cd ~/Projects/dotfiles
gcommit
cp -f ~/{.bash_profile,.gitignore_global,.gitconfig,.vimrc,Brewfile,Caskfile,aliases.sh,exports.sh,functions.sh,update.sh,.osx,.tmux.conf} .
cp -f ~/.vim/templates/* .vim/templates/
cp -f ~/.tmuxinator/* .tmuxinator/
gcommit

# Update the dependencies
git pull origin master
git submodule init
git submodule update
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull
gcommit

# Copy the updated stuff into home path
./copy.sh

# Push the updated dotfiles
{
	git push origin master
} || {
echo "$BOLD $GREEN Sorry buddy, you dont have permisson fo push to my repo :( $RESET"
}
