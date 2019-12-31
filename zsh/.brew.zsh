# fix brew autocompletions
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
rm -f ~/.zcompdump; compinit
