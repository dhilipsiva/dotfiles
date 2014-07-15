#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Stop on first error
set -e

# Just some warning for someone who is reading this script file.
echo "Make sure you have backed up all your existing dot files, if you had any."
echo "Make sure you have added this machine's ssh public key to your GitHub acccount."

# I guess pretty much everything else is self-explantory
mkdir -p ~/Projects
rm -rf ~/Projects/dotfiles
git clone --recursive git@github.com:dhilipsiva/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./copy.sh
