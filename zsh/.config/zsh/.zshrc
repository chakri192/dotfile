# Powerful but minimal zsh configuration
# Author: Radley E. Sidwell-Lewis
# GitHub: https://www.github.com/radleylewis/zsh
#
# Uses:
#   Plugins:      fast-syntax-highlighting, zsh-autosuggestions,
#                 zsh-history-substring-search, zsh-vi-mode
#   Prompt:       starship
#   Navigation:   zoxide, fzf, fd
#   CLI tools:    eza, bat, nvim, ripgrep
#   Node:         nvm

# =========================================================
# History
# =========================================================

HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# =========================================================
# Shell behaviour
# =========================================================

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# =========================================================
# Smart directory navigation
# =========================================================

# Initialize zoxide
eval "$(zoxide init zsh)"

# =========================================================
# Completion
# =========================================================

# Load completion system
autoload -Uz compinit

# Initialize completion with cached metadata file
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# Enable interactive completion menu selection
zstyle ':completion:*' menu select

# Make completion case-insensitive
# Example: "doc" can complete to "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # lowercase input matches upper and lower

# =========================================================
# Fuzzy finder
# =========================================================

# macOS / Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# macOS / Homebrew (Intel)
if [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# Arch
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# Ubuntu
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# =========================================================
# Modular Config Files
# =========================================================

# fzf configuration
source "$ZDOTDIR/fzf.zsh"

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Custom keybindings
source "$ZDOTDIR/bindings.zsh"

# Plugins and plugin manager
source "$ZDOTDIR/plugins.zsh"

# Prompt/theme
source "$ZDOTDIR/prompt.zsh"

# =========================================================
# Secrets
# =========================================================
# Credentials live in ~/.secrets.zsh (chmod 600, gitignored). Keeping them
# out of this file is what makes it safe to commit to a public repo.
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh

# =========================================================
# Node / NVM
# =========================================================

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
export PATH="/Applications/OpenSCAD-2021.01.app/Contents/MacOS:$PATH"
export PATH="$PATH:$HOME/.platformio/penv/bin"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
btdl() {
  /Users/chakri/Documents/portfolio/bittorrent-rs/target/release/download "$@"
}

. "$HOME/.local/bin/env"

# Real-ESRGAN upscaler
upscale() {
  "$HOME/.local/share/realesrgan/realesrgan-ncnn-vulkan" \
    -m "$HOME/.local/share/realesrgan/models" \
    -i "$1" -o "$2" -s "${3:-4}" -n "${4:-realesrgan-x4plus}"
}

# Pretty live-UI wrapper for `brew install speedtest` (Ookla CLI).
# Bare `speedtest` runs the nicer UI; any flags (e.g. -L, --json) fall
# through to the real binary so scripting/CLI usage is unaffected.
speedtest() {
  if (( $# )); then
    command speedtest "$@"
  else
    ~/bin/speedtest-ui
  fi
}
export CLAUDE_CONFIG_DIR="$HOME/.claude-omniroute"
export ANTHROPIC_BASE_URL="http://localhost:20128"
export ANTHROPIC_AUTH_TOKEN="$(security find-generic-password -a "$USER" -s omniroute-key -w)"
export ANTHROPIC_API_KEY=""
export ANTHROPIC_MODEL="combo/free-coding"
export CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT=1
export CLAUDE_CODE_MAX_CONTEXT_TOKENS=200000

# =========================================================
# ghost-pipe
# =========================================================
# !! Contents within this block are managed by 'ghost-pipe install-zsh' !!

ghost_pipe_explain_widget() {
  echo ""
  python3 "$HOME/Documents/portfolio/ghost-pipe/ghost-pipe.py" explain latest
  zle reset-prompt
}
zle -N ghost_pipe_explain_widget
bindkey '^E' ghost_pipe_explain_widget

ghost_pipe_insert_fix_widget() {
  local suggestion
  suggestion=$(python3 "$HOME/Documents/portfolio/ghost-pipe/ghost-pipe.py" last-suggestion 2>/dev/null)
  if [ -n "$suggestion" ]; then
    LBUFFER="$suggestion"
  fi
  zle reset-prompt
}
zle -N ghost_pipe_insert_fix_widget
# ^F is already the fzf file picker (see bindings.zsh) — bound to ^G here
# instead of the ghost-pipe installer's default to avoid the collision.
bindkey '^G' ghost_pipe_insert_fix_widget

preexec_ghost_pipe() {
  export GHOST_PIPE_START=$(date +%s)
  export GHOST_PIPE_CMD=$1
}
precmd_ghost_pipe() {
  local exit_code=$?
  if [ -f "$HOME/.ghost-pipe/disabled" ]; then
    unset GHOST_PIPE_CMD
    return
  fi
  if [ -n "$GHOST_PIPE_CMD" ]; then
    python3 "$HOME/Documents/portfolio/ghost-pipe/ghost-pipe.py" _internal_record --cmd "$GHOST_PIPE_CMD" --exit "$exit_code" --start "$GHOST_PIPE_START" &!
    if [ $exit_code -ne 0 ]; then
      echo -e "\033[90m[Ghost-Pipe] Type \033[1mCtrl+E\033[0m\033[90m to analyze this failure.\033[0m"
    fi
  fi
  unset GHOST_PIPE_CMD
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec_ghost_pipe
add-zsh-hook precmd precmd_ghost_pipe
