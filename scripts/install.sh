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

initialPath=${PWD}

echo '------------------------------------------------------------------------'
echo '   Prepare user-config repo'
echo '------------------------------------------------------------------------'

echo '=> Making .config directory'
mkdir -p ~/.config

echo '=> Installing git'
sudo apt install -y --no-install-recommends git

echo '=> Cloning user-config repo'
cd ~/.config
#git clone git@github.com:AndrewDaws/user-configs.git
git clone https://github.com/AndrewDaws/user-configs.git

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
    vim zsh htop man curl sed nano gawk nmap tmux \
    ack openssh-server cron httpie iputils-ping autojump \
    python3-dev python3-pip python3-setuptools thefuck
sudo pip3 install setuptools --upgrade
sudo pip3 install thefuck --upgrade
mkdir -p ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo '=> Installing system shell'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
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
    # TODO: Automate chrome-stable, and double commander install via apt or static download link.
    sudo apt install -y --no-install-recommends \
        libegl1-mesa-dev
    
    cd
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    git clone https://github.com/jwilm/alacritty.git
    cd alacritty
    cargo install cargo-deb
    cargo deb --install --manifest-path alacritty/Cargo.toml

    echo '=> Installing desktop fonts'
    cd
    git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1; ./nerd-fonts/install.sh; rm -rf nerd-fonts;

    echo -e '=> Do you have the key for the locked fonts? [Y/N] '
    read fontConfirm
    fontConfirm=$(echo $fontConfirm | tr '[:lower:]' '[:upper:]')
    if [[ $fontConfirm == 'YES' || $fontConfirm == 'Y' ]]; then

        sudo apt install -y --no-install-recommends \
            git-crypt

        mkdir -p ~/.git-crypt

        echo -e '=> Decrypt locked fonts with ~/.git-crypt/user-configs.key? [Y/N] '
        read decryptConfirm
        decryptConfirm=$(echo $decryptConfirm | tr '[:lower:]' '[:upper:]')
        if [[ $decryptConfirm == 'YES' || $decryptConfirm == 'Y' ]]; then

            if [ -f "~/.git-crypt/user-configs.key" ]; then

                echo "=> Decrypting with key"
                git-crypt unlock ~/.git-crypt/user-configs.key

                tar -xvf DankMono.tar
                mv DankMono ~/.local/share/fonts

                tar -xvf OperatorMono.tar
                mv OperatorMono ~/.local/share/fonts
            else
                echo "=> Key does not exist, skipping"
            fi
        fi
    fi
    sudo fc-cache -f -v

    echo '=> Installing desktop configurations'
    rm -f ~/.config/alacritty/alacritty.yml
    mkdir -p ~/.config/alacritty

    if [ -d ~/.local/share/fonts/OperatorMono ]; then
        chmod 644 ~/.config/user-configs/alacritty/alacritty.yml
        ln -s ~/.config/user-configs/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
    else
        chmod 644 ~/.config/user-configs/alacritty/alacritty-alt.yml
        ln -s ~/.config/user-configs/alacritty/alacritty-alt.yml ~/.config/alacritty/alacritty.yml
    fi

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

echo '=> Performing system upgrade'
sudo apt dist-upgrade -y

echo '=> Installing dependencies'
sudo apt install -f

echo '=> Cleaning packages'
sudo apt clean

echo '=> Autocleaning packages'
sudo apt autoclean

echo '=> Autoremoving & purging packages'
sudo apt autoremove --purge -y

if [[ $initialPath != ~/.config/user-configs/scripts ]]; then
    echo '=> Deleting temporary install script'
    rm -f $initialPath/`basename "$0"`
fi

echo '=> Changing shell'
sudo usermod -s "$(which zsh)" "${USER}"
env zsh -l

echo 'Done.'
