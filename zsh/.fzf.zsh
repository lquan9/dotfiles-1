# Setup fzf
# ---------
if [[ ! "${PATH}" == *"${HOME}/.fzf/bin"* ]]; then
  export PATH="${PATH}:${HOME}/.fzf/bin"
fi

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="\
  --height 70% \
  --layout reverse \
  --border \
  --color 'fg:#d3d0c8,fg+:#f2f0ec,bg:#2d2d2d,bg+:#2d2d2d,border:#747369'"

export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_CTRL_T_OPTS="\
  --layout reverse \
  --border \
  --height 70% \
  --info inline \
  --preview 'bat --style=numbers --color=always {} | head -500' \
  --preview-window right:60%:border \
  --color 'fg:#d3d0c8,fg+:#f2f0ec,bg:#2d2d2d,bg+:#2d2d2d,preview-bg:#2d2d2d,border:#747369' \
  --select-1 \
  --exit-0"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOME}/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOME}/.fzf/shell/key-bindings.zsh"
