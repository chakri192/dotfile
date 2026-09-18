# =========================================================
# fzf — ~/.config/zsh/fzf.zsh
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'

# Catppuccin Mocha colors
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt='  '
  --pointer='  '
  --marker=' '
  --preview-window=right:65%:wrap:border-left
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --bind='ctrl-/:toggle-preview'
  --bind='ctrl-u:preview-half-page-up'
  --bind='ctrl-d:preview-half-page-down'
"

# Ctrl-T: file picker with bat preview
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="
  --preview '$_FZF_PREVIEW_CMD'
  --header 'Ctrl-/ to toggle preview'
"

# Alt-C: directory picker with eza tree preview
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --icons --color=always --level=2 {}'
  --header 'Alt-C: cd into directory'
"

# Ctrl-R: history search — show full command, no sort (preserve recency)
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window=down:3:wrap:border-top
  --bind 'ctrl-/:toggle-preview'
  --header 'Ctrl-R: history | Ctrl-/ toggle preview'
  --no-sort
"

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
