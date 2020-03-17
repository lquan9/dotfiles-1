#!/bin/bash
# Creates or updates gitconfig based off template settings stored in the repo.
script_name="$(basename "${0}")"

argument_flag="false"
force_mode="disabled"
username_passed=""
email_passed=""

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
    echo "      --force  force create new gitconfig"
    exit 0
  elif [[ "${argument}" == "--force" ]]; then
    force_mode="enabled"
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

# @todo Preserve Git Config
# @body Preserve an existing .gitconfig and update with new settings.

rm -f "${HOME}/.gitconfig"
find "${DOTFILES_GIT_PATH}" -type f -exec chmod 664 {} \;
{
  echo "[include]";
  echo "  path = ${DOTFILES_GIT_PATH}/.gitconfig_global";
  echo "";
  echo "[core]";
  echo "  excludesfile = ${DOTFILES_GIT_PATH}/.gitignore_global";
  echo "  attributesfile = ${DOTFILES_GIT_PATH}/.gitattributes_global";
  echo "";
  echo "[user]";
} >> "${HOME}/.gitconfig"
echo 'What is your Git name?';
read gitName;
echo "  name = ${gitName}" >> "${HOME}/.gitconfig"
echo 'What is your Git email?';
read gitEmail;
echo "  email = ${gitEmail}" >> "${HOME}/.gitconfig"
chmod 664 "${HOME}/.gitconfig"
