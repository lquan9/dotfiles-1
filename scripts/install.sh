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
#   $ wget https://raw.githubusercontent.com/AndrewDaws/user-configs/master/scripts/install.sh
#   $ chmod +x install.sh
#   $ ./install.sh
#

echo '------------------------------------------------------------------------'
echo '   Prepare user-config repo'
echo '------------------------------------------------------------------------'

echo '=> Making .config directory'
mkdir -p ~/.config

echo '=> Installing git'
sudo apt install -y --no-install-recommends git

echo '=> Cloning user-config repo'
cd ~/.config
git clone git@github.com:AndrewDaws/user-configs.git

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Initial configuration'
echo '------------------------------------------------------------------------'

cd ~/.config/user-configs

echo '=> Update repository information'
sudo apt update -qq

echo '=> Perform system upgrade'
sudo apt dist-upgrade -y

echo '=> Installing repository tool'
sudo apt install -y --no-install-recommends software-properties-common

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Configuring system applications'
echo '------------------------------------------------------------------------'

#echo '=> Adding repositories'

echo '=> Installing system applications'
# TODO: Automate fd install via apt or static download link.
sudo apt install -y --no-install-recommends \
    vim zsh htop man curl nano gawk nmap tmux \
    ack openssh-server python3-dev python3-pip \
    cron httpie iputils-ping
sudo pip3 install thefuck
sudo pip3 install tldr
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo '=> Installing system shell'
# TODO: Fix oh-my-zsh install via sub-shell.
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k

echo '=> Installing system application configurations'
chmod 644 ~/.config/user-configs/zsh/.zshrc
chmod 644 ~/.config/user-configs/aliases/.alias
chmod 644 ~/.config/user-configs/tmux/.tmux.conf
rm -f ~/.zshrc
rm -f ~/.tmux.conf
rm -f ~/.fzf.bash
rm -f ~/.fzf.zsh
ln -s ~/.config/user-configs/zsh/.zshrc ~/.zshrc
ln -s ~/.config/user-configs/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/.config/user-configs/fzf/.fzf.zsh ~/.fzf.zsh
rm -f ~/.bash_history
rm -f ~/.bash_logout
rm -f ~/.bashrc
rm -f ~/.zshrc.pre-oh-my-zsh
rm -f ~/.fzf.bash
mkdir -p ~/.config/project-configs
touch ~/.config/project-configs/.default
sudo usermod -s "$(command -v zsh)" "${USER}"

echo -e '=> Install build tools? [Y/N] '
read buildConfirm
buildConfirm=$(echo $buildConfirm | tr '[:lower:]' '[:upper:]')
if [[ $buildConfirm == 'YES' || $buildConfirm == 'Y' ]]; then

    echo '=> Installing desktop applications'
    sudo apt install -y --no-install-recommends \
        make gcc build-essential cmake snapd
fi

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Configuring desktop applications'
echo '------------------------------------------------------------------------'

echo -e '=> Install desktop applications? [Y/N] '
read desktopConfirm
desktopConfirm=$(echo $desktopConfirm | tr '[:lower:]' '[:upper:]')
if [[ $desktopConfirm == 'YES' || $desktopConfirm == 'Y' ]]; then

    #echo '=> Installing desktop applications'
    # TODO: Automate alacritty, chrome-stable, and double commander install via apt or static download link.
    #sudo apt install -y --no-install-recommends \
    #    alacritty

    echo '=> Installing desktop fonts'
    git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1; ./nerd-fonts/install.sh; rm -rf nerd-fonts;
    sudo fc-cache -f -v

    echo '=> Installing desktop configurations'
    chmod 644 ~/.config/user-configs/alacritty/alacritty.yml
    rm -f ~/.config/alacritty/alacritty.yml
    ln -s ~/.config/user-configs/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

    echo -e '=> Install development applications? [Y/N] '
    read developmentConfirm
    developmentConfirm=$(echo $developmentConfirm | tr '[:lower:]' '[:upper:]')
    if [[ $developmentConfirm == 'YES' || $developmentConfirm == 'Y' ]]; then

        echo '=> Installing development applications'
        # TODO: Automate beyond compare install via apt or static download link.
        sudo apt install -y --no-install-recommends \
            wireshark meld
        
        # TODO: Fix Visual Studio Code install with correct static download link.
        #wget https://go.microsoft.com/fwlink/?LinkID=760868
        #sudo dpkg -i code_*.deb
        #rm -f code_*.deb

        rm -f ~/.gitconfig
        cp ~/.config/user-configs/git/.gitconfig ~/.gitconfig
        echo "" >> ~/.gitconfig
        echo "[user]" >> ~/.gitconfig
        echo 'What is your Git name?'
        read gitName
        echo "    name = $gitName" >> ~/.gitconfig
        echo 'What is your Git email?'
        read gitEmail
        echo "    email = $gitEmail" >> ~/.gitconfig
    fi

    echo -e '=> Install gaming applications? [Y/N] '
    read gamingConfirm
    gamingConfirm=$(echo $gamingConfirm | tr '[:lower:]' '[:upper:]')
    if [[ $gamingConfirm == 'YES' || $gamingConfirm == 'Y' ]]; then

        echo '=> Installing gaming applications'
        wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb
        sudo dpkg -i steam.deb
        rm -f steam.deb
    fi

    echo -e '=> Install photography applications? [Y/N] '
    read photographyConfirm
    photographyConfirm=$(echo $photographyConfirm | tr '[:lower:]' '[:upper:]')
    if [[ $photographyConfirm == 'YES' || $photographyConfirm == 'Y' ]]; then

        echo '=> Installing photography applications'
        sudo apt install -y --no-install-recommends \
            darktable
    fi
fi

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   System updates and upgrades'
echo '------------------------------------------------------------------------'

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
