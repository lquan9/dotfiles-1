#!/bin/bash

rm -f ${PWD}/bat_*_amd64.deb
curl -s https://api.github.com/repos/sharkdp/bat/releases/latest \
| grep browser_download_url \
| grep bat_ \
| grep _amd64.deb \
| cut -d '"' -f 4 \
| wget -qi -
sudo apt install ${PWD}/bat_*_amd64.deb
rm -f ${PWD}/bat_*_amd64.deb