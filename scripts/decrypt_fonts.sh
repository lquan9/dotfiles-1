#!/bin/bash
# Decrypts and installs the encrypted fonts
script_name="$(basename "${0}")"

# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
  if [[ -f "${HOME}/.dotfiles/zsh/.paths.zsh" ]]; then
    source "${HOME}/.dotfiles/zsh/.paths.zsh"
  else
    echo "Aborting ${HOME}/.dotfiles/zsh/.paths.zsh"
    echo "  File ${HOME}/.dotfiles/zsh/.paths.zsh Does Not Exist!"
    exit 1
  fi
fi



# Install decryption application
if [[ -f "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" ]]; then
  if ! "${DOTFILES_SCRIPTS_PATH}/is_installed.sh" git-crypt; then
    sudo apt install -y --no-install-recommends \
      git-crypt
  fi
else
  echo "Aborting ${script_name}"
  echo "  File ${DOTFILES_SCRIPTS_PATH}/is_installed.sh Does Not Exist!"
  exit 1
fi

# Create key directory
if [[ -d "${HOME}/.git-crypt" ]]; then
  mkdir -p "${HOME}/.git-crypt"
  chmod 700 "${HOME}/.git-crypt"
fi

# Attempt to decrypt
echo "=> Decrypting with key"
if [[ -f "${HOME}/.git-crypt/dotfiles.key" ]]; then
  if ! (cd "${DOTFILES_PATH}"; git-crypt unlock "${HOME}/.git-crypt/dotfiles.key"); then
    echo "Aborting ${script_name}"
    echo "  Decrypting ${DOTFILES_PATH} Failed!"
    exit 1
  else
    if [[ -d "${HOME}/.local/share/fonts/DankMono" ]]; then
      echo "Skipped: ${DOTFILES_FONTS_PATH}/DankMono.tar"
    else
      tar -xvf "${DOTFILES_FONTS_PATH}/DankMono.tar" -C "${HOME}/.local/share/fonts"
      sudo fc-cache -f -v
    fi
    if [[ -d "${HOME}/.local/share/fonts/OperatorMono" ]]; then
      echo "Skipped: ${DOTFILES_FONTS_PATH}/OperatorMono.tar"
    else
      tar -xvf "${DOTFILES_FONTS_PATH}/OperatorMono.tar" -C "${HOME}/.local/share/fonts"
      sudo fc-cache -f -v
    fi
  fi
else
  echo "Aborting ${script_name}"
  echo "  File ${HOME}/.git-crypt/dotfiles.key Does Not Exist!"
  exit 1
fi
echo "Done."

exit 0
