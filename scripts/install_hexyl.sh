#!/bin/bash

rm -f ${PWD}/hexyl_*_amd64.deb
curl -s https://api.github.com/repos/sharkdp/hexyl/releases/latest \
| grep browser_download_url \
| grep hexyl_ \
| grep _amd64.deb \
| cut -d '"' -f 4 \
| wget -qi -
sudo apt install ${PWD}/hexyl_*_amd64.deb
rm -f ${PWD}/hexyl_*_amd64.deb