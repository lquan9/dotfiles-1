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
#   $ wget https://raw.githubusercontent.com/AndrewDaws/user-configs/master/install.sh
#   $ chmod +x install.sh
#   $ ./install.sh
#

echo '------------------------------------------------------------------------'
echo '=> Download user-config repo'
echo '------------------------------------------------------------------------'

mkdir -p ~/.config
sudo apt install -y --no-install-recommends git
cd .config
git clone git@github.com:AndrewDaws/user-configs.git

echo '------------------------------------------------------------------------'
echo '=> Unix post-install script'
echo '------------------------------------------------------------------------'

cd ~/.config/user-configs

# -----------------------------------------------------------------------------
# => System update/upgrade
# -----------------------------------------------------------------------------

echo '=> Update repository information'
sudo apt update -qq

echo '=> Perform system upgrade'
sudo apt dist-upgrade -y

echo '=> Installing repository tool'
sudo apt install -y --no-install-recommends software-properties-common

echo 'Done.'



# -----------------------------------------------------------------------------
# => Configure default system configurations and applications
# -----------------------------------------------------------------------------

#echo '=> Adding repositories'
curl -sL https://deb.nodesource.com/setup_11.x | sudo bash -
#sudo add-apt-repository -y ppa:ehoover/compholio          # Netflix

echo '=> Installing system applications'
sudo apt install -y --no-install-recommends neovim \
    ruby ruby-dev mosh openssh-server \
    python3-dev python3-pip tmux zsh htop man \
    rclone curl nano gawk httpie iputils-ping wget fuse openvpn \
    cron ack-grep nmap knockd iptables iptables-persistent \
    make gcc screen meld build-essential cmake \
    silversearcher-ag nodejs tmuxinator
sudo pip3 install thefuck
sudo pip3 install tldr
sudo pip3 install ntfy
sudo gem install gist
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo '=> Installing system shell'
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k

echo '=> Installing system configurations'
chmod 644 ~/.config/user-configs/zsh/.zshrc
chmod 644 ~/.config/user-configs/aliases/.alias
chmod 644 ~/.config/user-configs/alacritty/alacritty.yml
chmod 644 ~/.config/user-configs/tmux/.tmux.conf
rm -f ~/.zshrc
rm -f ~/.tmux.conf
rm -f ~/.config/alacritty/alacritty.yml
rm -f ~/.fzf.bash
rm -f ~/.fzf.zsh
//rm -f ~/.gitconfig
ln -s ~/.config/user-configs/zsh/.zshrc ~/.zshrc
ln -s ~/.config/user-configs/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
ln -s ~/.config/user-configs/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.config/user-configs/fzf/.fzf.zsh ~/.fzf.zsh
//ln -s ~/.config/user-configs/git/.gitconfig ~/.gitconfig
rm -f ~/.bash_history
rm -f ~/.bash_logout
rm -f ~/.bashrc
rm -f ~/.zshrc.pre-oh-my-zsh
rm -f ~/.fzf.bash
mkdir -p ~/.config/project-configs
touch ~/.config/project-configs/.default
sudo usermod -s "$(command -v zsh)" "${USER}"

echo 'Done.'


ln -s ~/.config/user-configs/.gitconfig ~/.gitconfig

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
        vlc wireshark darktable snapd fonts-powerline \
        terminator

    #wget https://go.microsoft.com/fwlink/?LinkID=760868
    #sudo dpkg -i code_*.deb
    #rm -f code_*.deb

    wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
    sudo dpkg -i steam.deb
    rm -f steam.deb

    echo '=> Installing desktop fonts'
    git clone https://github.com/powerline/fonts.git --depth=1; ./fonts/install.sh; rm -rf fonts;
    git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1; ./nerd-fonts/install.sh; rm -rf nerd-fonts;
    sudo fc-cache -f -v

    echo '=> Installing desktop configurations'
    rm -f ~/.config/terminator/config
    ln -s ~/.config/user-configs/config ~/.config/terminator/config

    echo 'Done.'
fi

#todo:
#double-commander
#vs code
#beyond compare
#wireguard
#chrome-stable



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
