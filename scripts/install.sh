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

# @todo Improve Printed Text and Prompts
# @body Clean up printed text with better separation of stages and description of what is happening. Better define what the prompts are actually asking.

script_name="$(basename "${0}")"
script_path="$(dirname "${0}")"

argument_flag="false"
headless_mode="disabled"
desktop_mode="disabled"

# Process arguments
for argument in "${@}"
do
  argument_flag="true"
  if [[ "${argument}" == "-?" || "${argument}" == "--help" ]]; then
    echo "Usage:"
    echo "  ${script_name} [options]"
    echo "  -?, --help      show list of command-line options"
    echo ""
    echo "OPTIONS"
    echo "  -h, --headless  force enable headless mode"
    echo "  -d, --desktop   force enable desktop mode"
    exit 0
  elif [[ "${argument}" == "-h" || "${argument}" == "--headless" ]]; then
    headless_mode="enabled"
  elif [[ "${argument}" == "-d" || "${argument}" == "--desktop" ]]; then
    desktop_mode="enabled"
  else
    echo "Aborting ${script_name}"
    echo "  Invalid Argument!"
    echo ""
    echo "Usage:"
    echo "  ${script_name} [options]"
    echo "  -?, --help      show list of command-line options"
    exit 1
  fi
done





echo '------------------------------------------------------------------------'
echo '   Preparing dotfiles repo'
echo '------------------------------------------------------------------------'

# @todo Single Sudo Prompt
# @body Automate sudo password prompt so it is only asked for once.
echo '=> Installing git'
sudo apt install -y --no-install-recommends git

if [[ -d "${HOME}/.dotfiles" ]]; then
  echo '=> Updating dotfiles repo'
  git -C "${HOME}/.dotfiles" pull
else
  echo '=> Cloning dotfiles repo'
  if ! git clone https://github.com/AndrewDaws/dotfiles.git "${HOME}/.dotfiles"; then
    echo "Aborting ${script_name}"
    echo "  Command git clone https://github.com/AndrewDaws/dotfiles.git ${HOME}/.dotfiles Failed!"
    exit 1
  fi
fi

# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
  if [[ -f "${HOME}/.dotfiles/zsh/.paths.zsh" ]]; then
    source "${HOME}/.dotfiles/zsh/.paths.zsh"
  else
    echo "Aborting ${script_name}"
    echo "  File ${HOME}/.dotfiles/zsh/.paths.zsh Does Not Exist!"
    exit 1
  fi
fi

# Set file permissions
if [[ -f "${DOTFILES_SCRIPTS_PATH}/set_permissions.sh" ]]; then
  if ! "${DOTFILES_SCRIPTS_PATH}/set_permissions.sh"; then
    echo "Aborting ${script_name}"
    echo "  Script ${DOTFILES_SCRIPTS_PATH}/set_permissions.sh Failed!"
    exit 1
  fi
else
  echo "Aborting ${script_name}"
  echo "  File ${DOTFILES_SCRIPTS_PATH}/set_permissions.sh Does Not Exist!"
  exit 1
fi

# Determine system type if no arguments given
if [[ "${argument_flag}" == "false" ]]; then
  if [[ -f "${DOTFILES_SCRIPTS_PATH}/is_desktop.sh" ]]; then
    "${DOTFILES_SCRIPTS_PATH}/is_desktop.sh" > /dev/null \
      && desktop_mode="enabled" \
      || headless_mode="enabled"
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_SCRIPTS_PATH}/is_desktop.sh Does Not Exist!"
    exit 1
  fi
fi

echo 'Done.'





echo '------------------------------------------------------------------------'
echo '   Initial configuration'
echo '------------------------------------------------------------------------'

echo '=> Update repository information'
sudo apt update -qq

echo '=> Perform system upgrade'
sudo apt dist-upgrade -y

echo '=> Installing dependencies'
sudo apt install -f

echo '=> Cleaning packages'
sudo apt clean

echo '=> Autocleaning packages'
sudo apt autoclean

echo '=> Autoremoving & purging packages'
sudo apt autoremove --purge -y

echo '=> Installing repository tool'
sudo apt install -y --no-install-recommends software-properties-common

echo 'Done.'





if [[ "${argument_flag}" == "false" || "${headless_mode}" == "enabled" ]]; then
  echo '------------------------------------------------------------------------'
  echo '   Configuring headless applications'
  echo '------------------------------------------------------------------------'

  #echo '=> Adding repositories'

  echo '=> Installing headless applications'
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

  echo '=> Installing headless shell'
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

  if [[ -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate" ]]; then
    echo '=> Updating autoupdate repo'
    git -C "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate" pull
  else
    echo '=> Cloning autoupdate repo'
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/autoupdate"
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

  echo '=> Installing headless application configurations'
  rm -f "${HOME}/.bash_history"
  rm -f "${HOME}/.bash_logout"
  rm -f "${HOME}/.bashrc"
  rm -f "${HOME}/.zshrc.pre-oh-my-zsh"

  # Create links
  if [[ -f "${DOTFILES_SCRIPTS_PATH}/create_links.sh" ]]; then
    if ! "${DOTFILES_SCRIPTS_PATH}/create_links.sh" --headless; then
      echo "Aborting ${script_name}"
      echo "  Script ${DOTFILES_SCRIPTS_PATH}/create_links.sh Failed!"
      exit 1
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_SCRIPTS_PATH}/create_links.sh Does Not Exist!"
    exit 1
  fi

  echo 'Done.'
fi





if [[ "${desktop_mode}" == "enabled" ]]; then
  echo '------------------------------------------------------------------------'
  echo '   Configuring desktop applications'
  echo '------------------------------------------------------------------------'

  echo '=> Installing desktop applications'
  sudo apt install -y --no-install-recommends \
    libegl1-mesa-dev snapd make cmake \
    gcc build-essential meld pkg-config \
    libssl-dev

  # Install Alacritty
  "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" alacritty || "${DOTFILES_SCRIPTS_PATH}/install_alacritty.sh"

  # Install Bat
  "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" bat || "${DOTFILES_SCRIPTS_PATH}/install_bat.sh"

  # Install Chrome
  "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" google-chrome || "${DOTFILES_SCRIPTS_PATH}/install_chrome.sh"

  # Install Delta
  "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" delta || "${DOTFILES_SCRIPTS_PATH}/install_delta.sh"

  # Install Rustup
  if ! "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "${HOME}/.cargo/env"
  else
    rustup update
  fi

  # @todo Improve Cargo Package Updating
  # @body Find a way to only update cargo packages if outdated, rather than full reinstall.
  # Install Cargo Applications
  # Install Exa
  if ! "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" exa; then
    cargo install exa
  else
    echo "Skipped: exa"
  fi

  # Install tldr
  if ! "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" tldr; then
    cargo install tealdeer
  else
    echo "Skipped: tldr"
  fi

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
  if ! find "${HOME}/.local/share/fonts/NerdFonts/Fura Code"* > /dev/null; then
    "${DOTFILES_SCRIPTS_PATH}/install_firacode.sh"
  else
    echo "Skipped: ${DOTFILES_SCRIPTS_PATH}/install_firacode.sh"
  fi

  # Install FiraMono
  if ! find "${HOME}/.local/share/fonts/NerdFonts/Fura Mono"* > /dev/null; then
    "${DOTFILES_SCRIPTS_PATH}/install_firamono.sh"
  else
    echo "Skipped: ${DOTFILES_SCRIPTS_PATH}/install_firamono.sh"
  fi

  echo '=> Installing desktop configurations'

  # Create links
  if [[ -f "${DOTFILES_SCRIPTS_PATH}/create_links.sh" ]]; then
    if ! "${DOTFILES_SCRIPTS_PATH}/create_links.sh" --desktop; then
      echo "Aborting ${script_name}"
      echo "  Script ${DOTFILES_SCRIPTS_PATH}/create_links.sh Failed!"
      exit 1
    fi
  else
    echo "Aborting ${script_name}"
    echo "  File ${DOTFILES_SCRIPTS_PATH}/create_links.sh Does Not Exist!"
    exit 1
  fi
  
  # Install term environment
  if [[ -f "${HOME}/.terminfo/x/xterm-256color-italic" ]]; then
    echo "Skipped: ${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
  else
    tic "${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
    echo "Installed ${DOTFILES_TERM_PATH}/xterm-256color-italic.terminfo"
  fi

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
#  echo '=> Deleting temporary install script'
#  rm -f "${script_path}/${script_name}"
#fi

echo '=> Changing shell'
sudo usermod -s "$(which zsh)" "${USER}"
env zsh -l

echo 'Done.'

exit 0
