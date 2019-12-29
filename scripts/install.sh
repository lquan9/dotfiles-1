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

# @todo Create Update Script
# @body Create and update script or add an update flag to the installation script.

# @todo Improve Printed Text and Prompts
# @body Clean up printed text with better separation of stages and description of what is happening. Better define what the prompts are actually asking.

INITIAL_PATH=${pwd}
INSTALL_PATH="${HOME}/.config/user-configs"

echo '------------------------------------------------------------------------'
echo '   Prepare user-config repo'
echo '------------------------------------------------------------------------'

# @todo Single Sudo Prompt
# @body Automate sudo password prompt so it is only asked for once.
echo '=> Installing git'
sudo apt install -y --no-install-recommends git

if [[ -d ${INSTALL_PATH} ]]; then
    echo '=> Updating user-config repo'
    (cd ${INSTALL_PATH}; git pull)
else
    echo '=> Making .config directory'
    mkdir -p ${HOME}/.config

    echo '=> Cloning user-config repo'
    cd ${HOME}/.config
    git clone https://github.com/AndrewDaws/user-configs.git
fi

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Initial configuration'
echo '------------------------------------------------------------------------'

cd ${INSTALL_PATH}

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
# @todo Fd-find Installation
# @body Automate the Fd installation.
sudo apt install -y --no-install-recommends \
    vim zsh htop man curl sed nano gawk nmap tmux xclip \
    ack openssh-server cron httpie iputils-ping autojump \
    python3-dev python3-pip python3-setuptools thefuck file
sudo pip3 install setuptools --upgrade
sudo pip3 install thefuck --upgrade
mkdir -p ${HOME}/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
${HOME}/.fzf/install --all
git clone https://github.com/andrewferrier/fzf-z.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z

echo '=> Installing system shell'
# Install Oh-My-Zsh Framework
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

# Install Oh-My-Zsh Theme
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k

# Install Oh-My-Zsh Plugins
git clone https://github.com/wfxr/forgit.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit
git clone https://github.com/supercrabtree/k.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/k
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
mkdir -p ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/git-auto-status
wget -O ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/git-auto-status/git-auto-status.plugin.zsh https://gist.githubusercontent.com/oshybystyi/475ee7768efc03727f21/raw/4bfd57ef277f5166f3070f11800548b95a501a19/git-auto-status.plugin.zsh

echo '=> Installing system application configurations'
rm -f ${HOME}/.bash_history
rm -f ${HOME}/.bash_logout
rm -f ${HOME}/.bashrc
rm -f ${HOME}/.zshrc
rm -f ${HOME}/.zshrc.pre-oh-my-zsh
chmod 644 ${INSTALL_PATH}/zsh/.zshrc
ln -s ${INSTALL_PATH}/zsh/.zshrc ${HOME}/.zshrc

rm -f ${HOME}/.tmux.conf
chmod 644 ${INSTALL_PATH}/tmux/.tmux.conf
ln -s ${INSTALL_PATH}/tmux/.tmux.conf ${HOME}/.tmux.conf

rm -f ${HOME}/.fzf.bash
rm -f ${HOME}/.fzf.zsh

chmod 644 ${INSTALL_PATH}/aliases/.alias

mkdir -p ${HOME}/.config/project-configs
touch ${HOME}/.config/project-configs/.default

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Configuring desktop applications'
echo '------------------------------------------------------------------------'

echo -e '=> Install desktop applications? [Y/N] '
read desktopConfirm
desktopConfirm=$(echo $desktopConfirm | tr '[:lower:]' '[:upper:]')
if [[ $desktopConfirm == 'YES' || $desktopConfirm == 'Y' ]]; then

    echo '=> Installing desktop applications'
    sudo apt install -y --no-install-recommends \
        libegl1-mesa-dev

    # @todo Chrome Installation
    # @body Automate the Chrome-Stable installation.

    # @todo File Manager Installation
    # @body Determine and automate a file manager (like Double Commander) installation.

    cd ${HOME}
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ${HOME}/.cargo/env
    git clone https://github.com/jwilm/alacritty.git
    cd alacritty
    cargo install cargo-deb
    cargo deb --install --manifest-path alacritty/Cargo.toml

    # @todo Trim Nerd-Fonts Installation
    # @body Cut down the Nerd-Fonts installation to just specific fonts so it isn't installing several GB worth.
    echo '=> Installing desktop fonts'
    cd ${HOME}
    git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1; ./nerd-fonts/install.sh; rm -rf nerd-fonts;

    # @todo Skip Nerd-Fonts Installation
    # @body Poentially skip the Nerd-Fonts installation entirely if the user does have access to the encrypted fonts.
    echo -e '=> Do you have the key for the locked fonts? [Y/N] '
    read fontConfirm
    fontConfirm=$(echo $fontConfirm | tr '[:lower:]' '[:upper:]')
    if [[ $fontConfirm == 'YES' || $fontConfirm == 'Y' ]]; then

        sudo apt install -y --no-install-recommends \
            git-crypt

        mkdir -p ${HOME}/.git-crypt
        chmod 700 ${HOME}/.git-crypt

        echo -e '=> Decrypt locked fonts with ${HOME}/.git-crypt/user-configs.key? [Y/N] '
        read decryptConfirm
        decryptConfirm=$(echo $decryptConfirm | tr '[:lower:]' '[:upper:]')
        if [[ $decryptConfirm == 'YES' || $decryptConfirm == 'Y' ]]; then

            if [ -f "${HOME}/.git-crypt/user-configs.key" ]; then

                echo "=> Decrypting with key"
                git-crypt unlock ${HOME}/.git-crypt/user-configs.key

                tar -xvf ${INSTALL_PATH}/fonts/DankMono.tar -C ${HOME}/.local/share/fonts
                tar -xvf ${INSTALL_PATH}/fonts/OperatorMono.tar -C ${HOME}/.local/share/fonts
            else
                echo "=> Key does not exist, skipping"
            fi
        fi
    fi
    sudo fc-cache -f -v

    echo '=> Installing desktop configurations'
    rm -f ${HOME}/.config/alacritty/alacritty.yml
    mkdir -p ${HOME}/.config/alacritty

    if [ -d ${HOME}/.local/share/fonts/OperatorMono ]; then
        chmod 644 ${INSTALL_PATH}/alacritty/alacritty.yml
        ln -s ${INSTALL_PATH}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
    else
        chmod 644 ${INSTALL_PATH}/alacritty/alacritty-alt.yml
        ln -s ${INSTALL_PATH}/alacritty/alacritty-alt.yml ${HOME}/.config/alacritty/alacritty.yml
    fi

    echo -e '=> Install development applications? [Y/N] '
    read developmentConfirm
    developmentConfirm=$(echo $developmentConfirm | tr '[:lower:]' '[:upper:]')
    if [[ $developmentConfirm == 'YES' || $developmentConfirm == 'Y' ]]; then

        echo '=> Installing development applications'
        sudo apt install -y --no-install-recommends \
            wireshark meld make gcc build-essential \
            cmake snapd

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
        echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile
        eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        brew install gcc
        brew install git-delta

        # @todo VS Code Installation
        # @body Automate the VS Code installation.

        rm -f ${HOME}/.gitconfig
        cp ${INSTALL_PATH}/git/.gitconfig ${HOME}/.gitconfig
        echo "" >> ${HOME}/.gitconfig
        echo "[user]" >> ${HOME}/.gitconfig
        echo 'What is your Git name?'
        read gitName
        echo "    name = $gitName" >> ${HOME}/.gitconfig
        echo 'What is your Git email?'
        read gitEmail
        echo "    email = $gitEmail" >> ${HOME}/.gitconfig

        rm -f ${HOME}/.gitignore
        ln -s ${INSTALL_PATH}/git/.gitignore ${HOME}/.gitignore
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

if [[ $INITIAL_PATH != ${INSTALL_PATH}/scripts ]]; then
    echo '=> Deleting temporary install script'
    rm -f $INITIAL_PATH/`basename "$0"`
fi

echo '=> Changing shell'
sudo usermod -s "$(which zsh)" "${USER}"
env zsh -l

echo 'Done.'
