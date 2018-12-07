#!/bin/bash
#
# Unix post-install script
#
# Author:
#   Andrew Daws
#
# Description:
#   A post-installation bash script for Unix systems
#
# Usage:
#   $ cd /tmp
#   $ wget http://gist.github.com/raw/8108714/ubuntu-post-install.sh
#   $ chmod +x ubuntu-post-install.sh
#   $ ./ubuntu-post-install.sh
#

echo '------------------------------------------------------------------------'
echo '=> Unix post-install script'
echo '------------------------------------------------------------------------'

install_directory=`pwd`
cd

# -----------------------------------------------------------------------------
# => Add PPAs (Personal Package Archives)
# -----------------------------------------------------------------------------
#echo '=> Add PPAs'
#sudo add-apt-repository -y ppa:ehoover/compholio          # Netflix
#echo 'Done.'

# -----------------------------------------------------------------------------
# => System update/upgrade
# -----------------------------------------------------------------------------
echo '=> Update repository information'
sudo apt update -qq
echo '=> Perform system upgrade'
sudo apt dist-upgrade -y
echo 'Done.'

# -----------------------------------------------------------------------------
# => Install system applications
# -----------------------------------------------------------------------------
echo '=> Install system applications'
sudo apt install -y --no-install-recommends git neovim \
    fonts-powerline ruby ruby-dev mosh openssh-server \
    python3-dev python3-pip tmux zsh htop man \
    rclone curl nano gawk httpie iputils-ping wget fuse openvpn \
    cron ack-grep nmap knockd iptables iptables-persistent \
    make gcc screen terminator
sudo pip3 install thefuck
sudo pip3 install tldr
sudo pip3 install ntfy
sudo gem install gist
git clone https://github.com/powerline/fonts.git --depth=1; ./fonts/install.sh; rm -rf fonts;
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
chmod 644 ~/.user-configs/.zshrc
chmod 644 ~/.user-configs/.alias
chmod 644 ~/.user-configs/.tmux.conf
rm -f ~/.zshrc
#rm -f ~/.alias
rm -f ~/.tmux.conf
rm -f ~/.fzf.bash
rm -f ~/.fzf.zsh
ln -s ~/.user-configs/.zshrc ~/.zshrc
#ln -s $install_directory/.alias ~/.alias
ln -s ~/.user-configs/.tmux.conf ~/.tmux.conf
ln -s ~/.user-configs/.fzf.zsh ~/.fzf.zsh
git config --global user.email "andrewrdaws@gmail.com"
git config --global user.name "AndrewDaws"
sudo usermod -s "$(command -v zsh)" "${USER}"

echo 'Done.'


# -----------------------------------------------------------------------------
# => Install desktop applications
# -----------------------------------------------------------------------------
echo '=> Install desktop applications'
echo -e '=> Are you sure? [Y/n] '
read confirmation
confirmation=$(echo $confirmation | tr '[:lower:]' '[:upper:]')
if [[ $confirmation == 'YES' || $confirmation == 'Y' ]]; then
    sudo apt install -y --no-install-recommends \
        vlc wireshark darktable snapd
    wget https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg -i code_*.deb
    echo 'Done.'
fi

#todo:
#double-commander
#vs code
#beyond compare
#wireguard
#chrome-stable
#steam


# -----------------------------------------------------------------------------
# => System update/upgrade
# -----------------------------------------------------------------------------
echo '=> Update repository information'
sudo apt update -qq
echo '=> Perform system upgrade'
sudo apt dist-upgrade -y
echo '=> Install dependencies'
sudo apt install -f
echo '=> clean packages'
sudo apt clean
echo '=> autoclean packages'
sudo apt autoclean
echo '=> Autoremoving & purging packages'
sudo apt autoremove --purge
echo 'Done.'
