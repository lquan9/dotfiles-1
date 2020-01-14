#!/bin/bash

rm -f ${HOME}/.gitconfig
find ${DOTFILES_GIT_PATH} -type f -exec chmod 664 {} \;
cp ${DOTFILES_GIT_PATH}/.gitconfig ${HOME}/.gitconfig
echo "" >> ${HOME}/.gitconfig
echo "  excludesfile = ${DOTFILES_GIT_PATH}/.gitignore_global" >> ${HOME}/.gitconfig
echo "  attributesfile = ${DOTFILES_GIT_PATH}/.gitattributes_global" >> ${HOME}/.gitconfig
echo "" >> ${HOME}/.gitconfig
echo "[user]" >> ${HOME}/.gitconfig
echo 'What is your Git name?'
read gitName
echo "  name = $gitName" >> ${HOME}/.gitconfig
echo 'What is your Git email?'
read gitEmail
echo "  email = $gitEmail" >> ${HOME}/.gitconfig
chmod 664 ${HOME}/.gitconfig
