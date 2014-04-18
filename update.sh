#! /bin/bash
#
# update.sh
# Copyright (C) 2013 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#
gem update
brew update
brew upgrade
brew cleanup
brew prune
git pull origin master
git submodule init
git submodule update
git submodule foreach --recursive git checkout master
git submodule foreach --recursive git pull
git add .
git commit -m "Updating..."
git push origin master
