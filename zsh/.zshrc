# ==============================================================
# .zshrc — chakri's shell config
# ==============================================================

# ==========================================
# HOMEBREW & COMPLETIONS
# ==========================================
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Cache compinit — only re-init once per day for faster startup
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
autoload -Uz bashcompinit && bashcompinit

# Case-insensitive completion — type `desk<tab>` and get `Desktop`.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ==========================================
# CONDA
# ==========================================
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
elif [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
  . "/opt/miniconda3/etc/profile.d/conda.sh"
else
  export PATH="/opt/miniconda3/bin:$PATH"
fi
unset __conda_setup

# ==========================================
# PATH (consolidated, no duplicates)
# ==========================================
export PATH="$HOME/scripts:$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Library/Frameworks/Python.framework/Versions/3.13/bin:$HOME/Library/Python/3.9/bin:$PATH"

# ==========================================
# EDITOR
# ==========================================
export EDITOR="nvim"

# ==========================================
# SECRETS
# ==========================================
# Credentials live in ~/.secrets.zsh (chmod 600, gitignored). Keeping them
# out of this file is what makes .zshrc safe to commit to a public repo.
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh

# ==========================================
# CORE TOOL INTEGRATIONS
# ==========================================
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Starship. This was missing — ~/.config/starship.toml existed but was never
# being loaded, so you were running the default zsh prompt the whole time.
eval "$(starship init zsh)"

# Ghosted-grey suggestions from history as you type (omerxx/dotfiles).
# Right-arrow / End accepts, as shipped. ctrl+space accepts too, for when
# your hand is already on the home row.
#
# omerxx binds ^e / ^w / ^u to accept / accept-and-run / toggle. Not copied:
# in emacs mode those are end-of-line, backward-kill-word and kill-whole-line,
# and losing ctrl+w especially would hurt. Uncomment if you disagree.
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  bindkey '^ ' autosuggest-accept
  # bindkey '^e' autosuggest-accept
  # bindkey '^w' autosuggest-execute
  # bindkey '^u' autosuggest-toggle
fi

# Atuin — SQLite-backed shell history. ctrl+R searches everything you've ever
# run, filterable by directory and git repo, instead of the 1000-command
# window macOS /etc/zshrc leaves you with.
#
# Loaded AFTER `fzf --zsh` on purpose: both want ctrl+R and last binding wins.
# That makes the FZF_CTRL_R_OPTS block in ~/.config/fzf/fzf.zsh inert — it's
# harmless, and moving this line above fzf's hands ctrl+R back.
#
# --disable-up-arrow keeps plain up-arrow as ordinary zsh history, so your
# muscle memory and the autosuggestions above still behave normally.
eval "$(atuin init zsh --disable-up-arrow)"

# ==========================================
# MODERN ALIASES
# ==========================================
alias ls="eza --icons --group-directories-first"
alias ll="eza -alF --icons --group-directories-first"
alias la="eza -lah --icons --git --group-directories-first"
alias tree="eza --tree --icons"
alias cat="bat --style=plain --paging=never"
alias grep="rg"
alias vim="nvim"
alias diff="diff --color=auto"
alias df="df -h"
alias -- -="cd -"

# Climb out of deep trees (omerxx/dotfiles)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ==========================================
# GIT ALIASES
# ==========================================
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# ==========================================
# UTILITY ALIASES
# ==========================================
alias checkspace="du -hd 1 ~ 2>/dev/null | sort -rh | head -n 10"
alias checkapps="du -hd 1 ~/Library/Application\ Support 2>/dev/null | sort -rh | head -n 10"
alias weather="curl wttr.in"
alias unimatrix='unimatrix -s 95'
alias markitdown="/opt/homebrew/bin/python3.12 -m markitdown"
alias cq='/Users/chakri/Downloads/Copy_manager/venv/bin/python /Users/chakri/Downloads/Copy_manager/clipq.py'
alias clearai="curl -s -X POST http://localhost:11434/api/generate -d '{\"model\": \"qwen2.5:7b\", \"keep_alive\": 0}' > /dev/null && echo '🧠 Local AI flushed from RAM'"

# ==========================================
# RCLONE MOUNT
# ==========================================
alias mountmusic='rclone cmount mycloud:Music ~/Desktop/Music \
  --volname "MusicCloud" \
  --vfs-cache-mode full \
  --vfs-cache-max-size 20G \
  --vfs-read-ahead 256M \
  --buffer-size 128M \
  --dir-cache-time 1000h \
  --drive-pacer-min-sleep 10ms \
  --network-mode \
  --daemon'

# ==========================================
# YT-DLP MUSIC (flags now live in ~/.config/yt-dlp/config)
# ==========================================
alias music='yt-dlp --cookies-from-browser firefox \
  --download-archive ~/Library/CloudStorage/GoogleDrive-v.chakradhar.ps.2326@gmail.com/"My Drive"/music_history.txt \
  --output "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s"'

# ==========================================
# MAINTENANCE
# ==========================================
brewup() {
  brew upgrade --greedy
  mas upgrade
  brew cleanup -s
}
alias clean='brewup && ~/cleanup.sh'

# ==========================================
# SUFFIX ALIASES (open by extension)
# ==========================================
alias -s md=bat
alias -s json=jq
alias -s go=nvim
alias -s py=nvim
alias -s js=nvim

# ==========================================
# GLOBAL ALIASES
# ==========================================
alias -g ne="2>/dev/null"
alias -g G="| rg -i"
alias -g C="| pbcopy"

# ==========================================
# NAMED DIRECTORY BOOKMARKS
# ==========================================
hash -d proj=~/Projects

# ==========================================
# ZSH WIDGETS & HACKS
# ==========================================
# Edit current command in nvim (Ctrl+X Ctrl+E)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Expand history tokens (e.g. !!) on space
bindkey ' ' magic-space

# Batch file renaming
autoload -U zmv

# Git commit shortcut: Ctrl+X g c
bindkey -s '^xgc' 'git commit -m ""\C-b'

# Safe paste
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Suppress virtualenv prompt pollution
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Config paths
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Source custom FZF bindings and layout config
source ~/.config/fzf/fzf.zsh

export PATH="/Applications/OpenSCAD-2021.01.app/Contents/MacOS:$PATH"
export PATH="$HOME/bin:$PATH"
alias gclean="~/bin/git-clean-branches.sh"
alias neofetch='fastfetch --logo arch'

# ==========================================
# FZF NAVIGATION (omerxx/dotfiles)
# ==========================================
# Ported to fd so they respect .gitignore and skip .git, and to list with
# your eza alias on arrival.
cx()  { cd "$@" && la; }                                        # cd + list
fcd() { local d; d=$(fd --type d --hidden --exclude .git | fzf) && cd "$d" && la; }
f()   { fd --type f --hidden --exclude .git | fzf | tr -d '\n' | pbcopy; }  # copy a path
fv()  { local file; file=$(fd --type f --hidden --exclude .git | fzf) && nvim "$file"; }







# ==========================================
# SYNTAX HIGHLIGHTING
# ==========================================
# Must be sourced LAST — it wraps every ZLE widget defined before it, so
# anything that adds widgets after this line won't get highlighted.
# Valid commands turn green as you type, unknown ones stay red.
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
