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
#   $ wget https://raw.githubusercontent.com/AndrewDaws/.user-configs/master/install.sh
#   $ chmod +x install.sh
#   $ ./install.sh
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
# => Configure default system configurations and applications
# -----------------------------------------------------------------------------

echo '=> Installing system applications'
sudo apt install -y --no-install-recommends git neovim \
    fonts-powerline ruby ruby-dev mosh openssh-server \
    python3-dev python3-pip tmux zsh htop man \
    rclone curl nano gawk httpie iputils-ping wget fuse openvpn \
    cron ack-grep nmap knockd iptables iptables-persistent \
    make gcc screen terminator meld build-essential cmake \
    silversearcher-ag
sudo pip3 install thefuck
sudo pip3 install tldr
sudo pip3 install ntfy
sudo gem install gist
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo '=> Installing system fonts'
git clone https://github.com/powerline/fonts.git --depth=1; ./fonts/install.sh; rm -rf fonts;
git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1; ./nerd-fonts/install.sh; rm -rf nerd-fonts;
sudo fc-cache -f -v

echo '=> Installing system shell'
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo '=> Installing system configurations'
chmod 644 ~/.user-configs/.zshrc
chmod 644 ~/.user-configs/.alias
chmod 644 ~/.user-configs/.tmux.conf
rm -f ~/.zshrc
rm -f ~/.tmux.conf
rm -f ~/.fzf.bash
rm -f ~/.fzf.zsh
rm -f ~/.gitconfig
ln -s ~/.user-configs/.zshrc ~/.zshrc
ln -s ~/.user-configs/.tmux.conf ~/.tmux.conf
ln -s ~/.user-configs/.fzf.zsh ~/.fzf.zsh
ln -s ~/.user-configs/.gitconfig ~/.gitconfig
rm -f ~/.bash_history
rm -f ~/.bash_logout
rm -f ~/.bashrc
rm -f ~/.zshrc.pre-oh-my-zsh
rm -f ~/.fzf.bash
mkdir ~/.project-configs
touch ~/.project-configs/.default
sudo usermod -s "$(command -v zsh)" "${USER}"

echo 'Done.'



# -----------------------------------------------------------------------------
# => Install desktop applications
# -----------------------------------------------------------------------------

echo '=> Install desktop applications?'
echo -e '=> Are you sure? [Y/n] '
read confirmation
confirmation=$(echo $confirmation | tr '[:lower:]' '[:upper:]')
if [[ $confirmation == 'YES' || $confirmation == 'Y' ]]; then

    echo '=> Installing desktop applications'
    sudo apt install -y --no-install-recommends \
        vlc wireshark darktable snapd
    wget https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg -i code_*.deb

    echo '=> Installing desktop configurations'
    rm -f ~/.config/terminator/config
    ln -s ~/.user-configs/config ~/.config/terminator/config

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
sudo apt autoremove --purge -y

echo 'Done.'
