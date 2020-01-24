# Setup fzf
# ---------
if [[ ! "${PATH}" == *"${HOME}/.fzf/bin"* ]]; then
  export PATH="${PATH}:${HOME}/.fzf/bin"
fi

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_T_OPTS="--select-1 --exit-0"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude proc'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/.fzf/shell/key-bindings.zsh"
