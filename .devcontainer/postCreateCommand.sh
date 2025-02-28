#!/bin/sh

set -e

sudo apt update
sudo apt install -y --no-install-recommends \
  jupyter \
  python3-matplotlib \
  python3-numpy \
  python3-yaml \
  python3-nbclient