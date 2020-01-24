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
#   $ wget https://raw.githubusercontent.com/AndrewDaws/dotfiles/master/scripts/install.sh
#   $ chmod +x install.sh
#   $ ./install.sh
#

# @todo Create Launch Arguments
# @body Add launch arguments to override default execution of the install script.

# @todo Improve Printed Text and Prompts
# @body Clean up printed text with better separation of stages and description of what is happening. Better define what the prompts are actually asking.

script_name="$(basename "${0}")"
script_path="$(dirname "${0}")"

DOTFILES_PATH="${HOME}/.dotfiles"

echo '------------------------------------------------------------------------'
echo '   Prepare dotfiles repo'
echo '------------------------------------------------------------------------'

# @todo Single Sudo Prompt
# @body Automate sudo password prompt so it is only asked for once.
echo '=> Installing git'
sudo apt install -y --no-install-recommends git

if [[ -d "${DOTFILES_PATH}" ]]; then
    echo '=> Updating dotfiles repo'
    git -C "${DOTFILES_PATH}" pull
else
    echo '=> Cloning dotfiles repo'
    git clone https://github.com/AndrewDaws/dotfiles.git "${DOTFILES_PATH}"
fi

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Initial configuration'
echo '------------------------------------------------------------------------'

# Save dotfiles directories to environment variable if not already set
paths_file="${HOME}/.dotfiles/zsh/.paths.zsh"
if [[ -f "${paths_file}" ]]; then
    source "${paths_file}"
fi

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
sudo apt install -y --no-install-recommends \
    vim zsh htop man curl sed nano gawk nmap tmux xclip \
    ack openssh-server cron httpie iputils-ping file \
    python3-dev python3-pip python3-setuptools thefuck

# Install Pip Applications
sudo pip3 install setuptools --upgrade
sudo pip3 install thefuck --upgrade

# Install Fd
"${DOTFILES_SCRIPTS_PATH}/is_installed.sh" fd || "${DOTFILES_SCRIPTS_PATH}/install_fd.sh"

# Install Tmux Plugin Manager
if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    echo '=> Updating Tmux Plugin Manager repo'
    git -C "${HOME}/.tmux/plugins/tpm" pull
else
    echo '=> Cloning Tmux Plugin Manager repo'
    mkdir -p "${HOME}/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
fi


# Install Fzf
if [[ -d "${HOME}/.fzf" ]]; then
    echo '=> Updating fzf repo'
    git -C "${HOME}/.fzf" pull
else
    echo '=> Cloning fzf repo'
    git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
fi
"${HOME}/.fzf/install" --bin

echo '=> Installing system shell'
# Install Oh-My-Zsh Framework
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    echo '=> Updating Oh-My-Zsh repo'
    git -C "${HOME}/.oh-my-zsh" pull
else
    echo '=> Installing Oh-My-Zsh'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

# Install Oh-My-Zsh Theme
if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    echo '=> Updating Powerlevel10k repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k" pull
else
    echo '=> Cloning Powerlevel10k repo'
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Install Oh-My-Zsh Plugins
if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/bd" ]]; then
    echo '=> Updating bd repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/bd" pull
else
    echo '=> Cloning bd repo'
    git clone https://github.com/Tarrasch/zsh-bd.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/bd"
fi

if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
    echo '=> Updating fast-syntax-highlighting repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" pull
else
    echo '=> Cloning fast-syntax-highlighting repo'
    git clone https://github.com/zdharma/fast-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
fi

if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit" ]]; then
    echo '=> Updating forgit repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit" pull
else
    echo '=> Cloning forgit repo'
    git clone https://github.com/wfxr/forgit.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit"
fi

if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z" ]]; then
    echo '=> Updating fzf-z repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z" pull
else
    echo '=> Cloning fzf-z repo'
    git clone https://github.com/andrewferrier/fzf-z.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fzf-z"
fi

if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    echo '=> Updating zsh-autosuggestions repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" pull
else
    echo '=> Cloning zsh-autosuggestions repo'
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions" ]]; then
    echo '=> Updating zsh-completions repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions" pull
else
    echo '=> Cloning zsh-completions repo'
    git clone https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
fi

echo '=> Installing system application configurations'
find "${DOTFILES_ALIAS_PATH}" -type f -exec chmod 664 {} \;
find "${DOTFILES_SCRIPTS_PATH}" -type f -exec chmod 755 {} \;
find "${DOTFILES_TMUX_PATH}" -type f -exec chmod 644 {} \;
find "${DOTFILES_VIM_PATH}" -type f -exec chmod 644 {} \;
find "${DOTFILES_ZSH_PATH}" -type f -exec chmod 644 {} \;

rm -f "${HOME}/.bash_history"
rm -f "${HOME}/.bash_logout"
rm -f "${HOME}/.bashrc"
rm -f "${HOME}/.zshrc"
rm -f "${HOME}/.zshrc.pre-oh-my-zsh"
ln -s "${DOTFILES_ZSH_PATH}/.zshrc" "${HOME}/.zshrc"

rm -f "${HOME}/.tmux.conf"
ln -s "${DOTFILES_TMUX_PATH}/.tmux.conf" "${HOME}/.tmux.conf"

rm -f "${HOME}/.vimrc"
ln -s "${DOTFILES_VIM_PATH}/.vimrc" "${HOME}/.vimrc"

rm -f "${HOME}/.fzf.bash"
rm -f "${HOME}/.fzf.zsh"

mkdir -p "${HOME}/.config/project-configs"
touch "${HOME}/.config/project-configs/.default"

echo 'Done.'



if [[ -z "${SSH_CLIENT}" ]]; then

    echo '------------------------------------------------------------------------'
    echo '   Configuring desktop applications'
    echo '------------------------------------------------------------------------'

    echo '=> Installing desktop applications'
    sudo apt install -y --no-install-recommends \
        libegl1-mesa-dev snapd cargo make cmake \
        gcc build-essential meld

    # Install Alacritty
    "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" alacritty || "${DOTFILES_SCRIPTS_PATH}/install_alacritty.sh"

    # Install Chrome
    "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" google-chrome || "${DOTFILES_SCRIPTS_PATH}/install_chrome.sh"

    # Install Delta
    "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" delta || "${DOTFILES_SCRIPTS_PATH}/install_delta.sh"

    # @todo Improve Cargo Package Updating
    # @body Find a way to only update cargo packages if outdated, rather than full reinstall.
    # Install Cargo applications
    cargo install --force exa
    cargo install --force tealdeer

    # Update tldr Cache
    tldr --update

    # @todo File Manager Installation
    # @body Determine and automate a file manager (like Double Commander) installation.

    # @todo Hub Installation
    # @body Determine a non-brew method to install Hub.

    # @todo VS Code Installation
    # @body Automate the VS Code installation.

    # @todo VS Code Config and Extensions
    # @body Export VS Code settings and installation of extensions.

    echo '=> Installing desktop fonts'

    # Install FiraCode
    "${DOTFILES_SCRIPTS_PATH}/install_firacode.sh"

    # Install FiraMono
    "${DOTFILES_SCRIPTS_PATH}/install_firamono.sh"

    # @todo Move Encrypted Fonts Logic
    # @body Move the encrypted fonts installation logic to a separate script.
    echo -e '=> Do you have the key for the locked fonts? [Y/N] '
    read fontConfirm
    fontConfirm="$(echo "${fontConfirm}" | tr '[:lower:]' '[:upper:]')"
    if [[ "${fontConfirm}" == 'YES' || "${fontConfirm}" == 'Y' ]]; then

        sudo apt install -y --no-install-recommends \
            git-crypt

        mkdir -p "${HOME}/.git-crypt"
        chmod 700 "${HOME}/.git-crypt"

        echo -e '=> Decrypt locked fonts with ${HOME}/.git-crypt/dotfiles.key? [Y/N] '
        read decryptConfirm
        decryptConfirm="$(echo "${decryptConfirm}" | tr '[:lower:]' '[:upper:]')"
        if [[ "${decryptConfirm}" == 'YES' || "${decryptConfirm}" == 'Y' ]]; then

            if [[ -f "${HOME}/.git-crypt/dotfiles.key" ]]; then

                echo "=> Decrypting with key"
                $(cd "${DOTFILES_PATH}"; git-crypt unlock "${HOME}/.git-crypt/dotfiles.key")

                tar -xvf "${DOTFILES_FONTS_PATH}/DankMono.tar" -C "${HOME}/.local/share/fonts"
                tar -xvf "${DOTFILES_FONTS_PATH}/OperatorMono.tar" -C "${HOME}/.local/share/fonts"

                sudo fc-cache -f -v
            else
                echo "=> Key does not exist, skipping"
            fi
        fi
    fi

    echo '=> Installing desktop configurations'
    rm -f "${HOME}/.config/alacritty/alacritty.yml"
    mkdir -p "${HOME}/.config/alacritty"
    find "${DOTFILES_ALACRITTY_PATH}" -type f -exec chmod 644 {} \;

    if [[ -d "${HOME}/.local/share/fonts/OperatorMono" ]]; then
        ln -s "${DOTFILES_ALACRITTY_PATH}/alacritty-operatormono.yml" "${HOME}/.config/alacritty/alacritty.yml"
    else
        ln -s "${DOTFILES_ALACRITTY_PATH}/alacritty-firamono.yml" "${HOME}/.config/alacritty/alacritty.yml"
    fi

    find "${DOTFILES_TERM_PATH}" -type f -exec chmod 644 {} \;
    tic "${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"

    # Create Global Git Config
    "${DOTFILES_SCRIPTS_PATH}/create_gitconfig.sh"
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

# @todo Fix Self-Deletion
# @body Fix the logic to delete the install script if not executed from dotfiles path.
#if [[ "${script_path}" != "${DOTFILES_SCRIPTS_PATH}" ]]; then
#    echo '=> Deleting temporary install script'
#    rm -f "${script_path}/${script_name}"
#fi

echo '=> Changing shell'
sudo usermod -s "$(which zsh)" "${USER}"
env zsh -l

echo 'Done.'
