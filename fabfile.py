#! /usr/bin/env python
# -*- coding: utf-8 -*-
#
# vim: fenc=utf-8
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4
#
#

"""
File name: fabfile.py
Author: dhilipsiva <dhilipsiva@gmail.com>
Date created: 2016-10-05
"""

import os

from fabric.api import env

from fabtools import deb

env.user = 'dhilipsiva'
host = os.environ['PERSONAL_SERVER_IP']
env.hosts = [host, ]  # Also change this IP in recreate_cluster.sh


def setup_personal_server():
    # deb.update_index()
    # deb.upgrade()
    deb.install([
        "vim",
        "tmux",
    ])
