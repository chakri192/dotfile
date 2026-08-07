# =========================================================
# fzf — source this from .zshrc
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix'

export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
  --bind=ctrl-/:toggle-preview
  --bind=ctrl-u:preview-half-page-up
  --bind=ctrl-d:preview-half-page-down
'

# Ctrl-T: file picker with bat preview
export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# ALT-C: directory picker with eza tree preview
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --icons --color=always --level=3 {}'
  --preview-window=right:55%:border-left
"

# Ctrl-R: history search — show full command, no truncation
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window=down:3:wrap:border-top
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header='CTRL-Y: copy to clipboard'
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
bindkey '^F' _fzf_file_no_hidden

# fd-based _fzf_compgen for ** completion
_fzf_compgen_path() { fd --hidden --follow --exclude .git . "$1"; }
_fzf_compgen_dir()  { fd --type d --hidden --follow --exclude .git . "$1"; }
