#!/bin/sh
set -e

# Instalar Chrome porque la versión instalada por Quarto no incluye todas las dependencias.
sudo apt update
sudo apt install -y wget gnupg
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install -y google-chrome-stable --no-install-recommends
sudo rm -rf /var/lib/apt/lists/*