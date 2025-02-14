#!/bin/bash
set -e

sudo apt-get -y update
sudo apt-get -y install --no-install-recommends \
     ruby-html-proofer 
