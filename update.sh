#! /bin/bash
#
# update.sh
# Copyright (C) 2013 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#
set -e

# gem update

# if [ "$(uname)" == "Darwin" ]; then
    # brew update
    # brew upgrade
    # brew cleanup
    # brew prune
# fi

cd ~/WIP/dotfiles
cp -f ~/{.bash_profile,.gitignore_global,.vimrc,Brewfile,Caskfile,aliases.sh,exports.sh,functions.sh} .
git add -A .
git commit -m "Updating dotfiles..."

git pull origin master
git submodule init
git submodule update
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull

./copy.sh

git add - A .
git commit -m "Updating dependencies..."

git push origin master
