# Set default terminal
if [[ -f ${HOME}/.terminfo/x/xterm-256color-italic ]]; then
  export TERM="xterm-256color-italic"
else
  export TERM="xterm-256color"
fi

# Save dotfiles directories to environment variable if not already set
if [[ -z "${DOTFILES_PATH}" ]]; then
  paths_file="${HOME}/.dotfiles/zsh/.paths.zsh"
  if [[ -f "${paths_file}" ]]; then
    source ${paths_file}
  fi
fi

# @todo Improve Tmux Session Algorithm
# @body Optimize the algorithm so the session starts as fast as possible, and improve reliablity for edge cases like resuming session with multiple clients still connected.
# Automatically use tmux in local sessions
if [ -z ${SSH_CLIENT+x} ]; then
  # Check if current shell session is in a tmux process
  if [ -z "$TMUX" ]; then
    # Create a new session if it does not exist
    base_session=$USER
    tmux has-session -t $base_session"-1" || tmux new-session -d -s $base_session"-1" \; set-window-option -g aggressive-resize

    # Check if clients are connected to session
    client_cnt=$(tmux list-clients | wc -l)
    if [ $client_cnt -ge 1 ]; then
      # Find unused client id
      count=1
      while [[ `tmux list-clients | grep $base_session"-"$count` != "" ]]
      do
        count=$((count+1))
      done
      session_name=$base_session"-"$count

      # Attach to current session as new client
      tmux new-session -d -t $base_session"-1" -s $session_name
      tmux -2 attach-session -t $session_name \; set-option destroy-unattached \; set-window-option -g aggressive-resize \; new-window; exit
    else
      # Attach to pre-existing session as previous client
      tmux -2 attach-session -t $base_session"-1" \; set-window-option -g aggressive-resize; exit
    fi
  fi
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=powerlevel10k/powerlevel10k

# Syntax Highlighter Configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# @todo Revise Oh-My-Zsh Plugins
# @body Speed up shell operation and startup by removing unnecessary plugins. Potentially creating my own aliases.
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  colored-man-pages
  command-not-found
  extract
  forgit
  fzf
  fzf-z
  git-auto-fetch
  git-auto-status
  history-substring-search
  k
  nmap
  per-directory-history
  safe-paste
  thefuck
  vscode
  z
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

[[ -f ${DOTFILES_ALIAS_PATH}/.alias ]] && source ${DOTFILES_ALIAS_PATH}/.alias

# @todo Fix Project-Configs Algorithm
# @body Fix the algorithm so it allows for an empty project-configs folder, and creates it if it does not exist. Potentially eliminate the project-configs folder entirely by dynamically loading unloading per-project configs from the project's directory.
# Source necessary files
for f in ${HOME}/.config/project-configs/.*; do source $f; done

# Enable fuzzy auto-completions
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

# Enable partial auto-completions
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Powerlevel10k Configuration
[[ -f ${DOTFILES_ZSH_PATH}/.p10k.zsh ]] && source ${DOTFILES_ZSH_PATH}/.p10k.zsh

# Brew Configuration
${DOTFILES_SCRIPTS_PATH}/is_installed.sh brew && [[ -f ${DOTFILES_ZSH_PATH}/.brew.zsh ]] && source ${DOTFILES_ZSH_PATH}/.brew.zsh

# Bat Configuration
${DOTFILES_SCRIPTS_PATH}/is_installed.sh bat && [[ -f ${DOTFILES_ZSH_PATH}/.bat.zsh ]] && source ${DOTFILES_ZSH_PATH}/.bat.zsh

# FZF Configuration
${DOTFILES_SCRIPTS_PATH}/is_installed.sh fzf && [[ -f ${DOTFILES_ZSH_PATH}/.fzf.zsh ]] && source ${DOTFILES_ZSH_PATH}/.fzf.zsh

# Forgit Configuration
#[[ -f ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/forgit/forgit.plugin.zsh ]] && [[ -f ${DOTFILES_ZSH_PATH}/.forgit.zsh ]] && source ${DOTFILES_ZSH_PATH}/.forgit.zsh

# History Substring Search Configuration
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Zsh Autosuggest Configuration
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# Zsh Syntax Highlighter Configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
