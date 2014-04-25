#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#

# Copy the required files into home folder
rsync \
    --exclude ".git/" \
    --exclude ".ssh/" \
    --exclude ".DS_Store" \
    --exclude "install.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    -av --no-perms . ~
{
    source ~/.bash_profile
} || {
echo "Some error during reading bash_profile..."
}
