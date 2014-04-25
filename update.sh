#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Stop on first error
set -e

# Update brew stuff
{
    brew update
    brew upgrade
    brew cleanup
    brew prune

} || {
echo "Brew is not installed"
}

# Copy the required files to `dotfiles`
cd ~/WIP/dotfiles
cp -f ~/{.bash_profile,.gitignore_global,.vimrc,Brewfile,Caskfile,aliases.sh,exports.sh,functions.sh} .
git add -A .

{
    git commit -m "Updating dotfiles..."
} || {
echo "Noting to commit..."
}

# Update the dependencies
git pull origin master
git submodule init
git submodule update
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull
git add -A .

{
    git commit -m "Updating dependencies..."
} || {
echo "Noting to commit..."
}

# Copy the updated stuff into home path
./copy.sh

# Push the updated dotfiles
git push origin master
