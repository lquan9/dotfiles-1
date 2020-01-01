#!/bin/bash
# Creates sym-links to dotfiles stored in the repo.
script_name="$(basename "${0}")"
script_path="$(dirname "${0}")"

# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
    paths_file="${HOME}/.dotfiles/zsh/.paths.zsh"
    if [[ -f "${paths_file}" ]]; then
        source ${paths_file}
    else
        echo "Aborting ${script_name}"
        echo "    File ${paths_file} Does Not Exist!"
        exit 1
    fi
fi



if [[ -z "${DOTFILES_ZSH_PATH}" ]]; then
    echo "Skipped ${HOME}/.zshrc"
else
    chmod 644 ${DOTFILES_ZSH_PATH}/.zshrc
    rm -f ${HOME}/.zshrc
    ln -s ${DOTFILES_ZSH_PATH}/.zshrc ${HOME}/.zshrc
    echo "Linked: ${HOME}/.zshrc -> ${DOTFILES_ZSH_PATH}/.zshrc"
fi

if [[ -z "${DOTFILES_TMUX_PATH}" ]]; then
    echo "Skipped ${HOME}/.tmux.conf"
else
    chmod 644 ${DOTFILES_TMUX_PATH}/.tmux.conf
    rm -f ${HOME}/.tmux.conf
    ln -s ${DOTFILES_TMUX_PATH}/.tmux.conf ${HOME}/.tmux.conf
    echo "Linked: ${HOME}/.tmux.conf -> ${DOTFILES_TMUX_PATH}/.tmux.conf"
fi

if [[ -z "${DOTFILES_VIM_PATH}" ]]; then
    echo "Skipped ${HOME}/.vimrc"
else
    chmod 644 ${DOTFILES_VIM_PATH}/.vimrc
    rm -f ${HOME}/.vimrc
    ln -s ${DOTFILES_VIM_PATH}/.vimrc ${HOME}/.vimrc
    echo "Linked: ${HOME}/.vimrc -> ${DOTFILES_VIM_PATH}/.vimrc"
fi

if [[ -z "${DOTFILES_ALACRITTY_PATH}" ]]; then
    echo "Skipped ${HOME}/.config/alacritty/alacritty.yml"
else
    chmod 644 ${DOTFILES_ALACRITTY_PATH}/alacritty.yml
    chmod 644 ${DOTFILES_ALACRITTY_PATH}/alacritty-alt.yml
    mkdir -p ${HOME}/.config/alacritty
    rm -f ${HOME}/.config/alacritty/alacritty.yml
    if [[ -d ${HOME}/.local/share/fonts/OperatorMono ]]; then
        ln -s ${DOTFILES_ALACRITTY_PATH}/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
        echo "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${DOTFILES_ALACRITTY_PATH}/alacritty.yml"
    else
        ln -s ${DOTFILES_ALACRITTY_PATH}/alacritty-alt.yml ${HOME}/.config/alacritty/alacritty.yml
        echo "Linked: ${HOME}/.config/alacritty/alacritty.yml -> ${DOTFILES_ALACRITTY_PATH}/alacritty-alt.yml"
    fi
fi