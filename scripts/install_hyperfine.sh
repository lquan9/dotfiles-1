#!/bin/bash

rm -f ${PWD}/hyperfine_*_amd64.deb
curl -s https://api.github.com/repos/sharkdp/hyperfine/releases/latest \
| grep browser_download_url \
| grep hyperfine_ \
| grep _amd64.deb \
| cut -d '"' -f 4 \
| wget -qi -
sudo apt install ${PWD}/hyperfine_*_amd64.deb
rm -f ${PWD}/hyperfine_*_amd64.deb