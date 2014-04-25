#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#
set -e
echo "Make sure you have backed up all your existing dot files, if you had any."
echo "Make sure you have added this machine's ssh public key to your GitHub acccount."
mkdir -p ~/WIP
rm -rf ~/WIP/dotfiles
git clone --recursive git@github.com:dhilipsiva/dotfiles.git ~/WIP/dotfiles
cd ~/WIP/dotfiles
./copy.sh
source ~/.bash_profile
