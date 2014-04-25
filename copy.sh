#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2014 dhilipsiva <dhilipsiva@gmail.com>
#
# Distributed under terms of the MIT license.
#
rsync \
    --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "install.sh" \
    --exclude "README.md" \
    --exclude "LICENSE.txt" \
    -av --no-perms . ~
