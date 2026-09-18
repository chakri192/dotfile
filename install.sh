#!/usr/bin/env zsh
#
# install.sh — one-shot setup for this dotfiles repo on a new macOS machine.
#
# Runs the same steps documented in README.md: stows the packages that can be
# symlinked, copies the ones that can't (VS Code, macOS LaunchAgent, Finder
# quick actions), and makes the scripts/ utilities executable.
#
# Zen Browser is intentionally NOT handled here — its profile directory name
# is a random per-install UUID, so see the "Zen Browser" section of the
# README and copy those files in by hand.
#
# Usage: ./install.sh [--dry-run]

set -euo pipefail

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

REPO_DIR="$(cd "$(dirname "${0}")" && pwd)"
cd "$REPO_DIR"

run() {
  if (( DRY_RUN )); then
    echo "+ $*"
  else
    echo "+ $*"
    "$@"
  fi
}

echo "==> Homebrew bundle"
if command -v brew >/dev/null 2>&1 && [[ -f "$REPO_DIR/Brewfile" ]]; then
  run brew bundle install --file="$REPO_DIR/Brewfile"
else
  echo "    skipped (brew not found or no Brewfile)"
fi

echo "==> Stow packages"
if command -v stow >/dev/null 2>&1; then
  run mkdir -p "$HOME/.ssh"
  run chmod 700 "$HOME/.ssh"
  run mkdir -p "$HOME/.ssh/sockets"
  run chmod 700 "$HOME/.ssh/sockets"
  run stow --no-folding -t "$HOME" zsh ghostty atuin nushell nvim git tmux ssh
else
  echo "    ERROR: GNU Stow not found. Install it (brew install stow) and re-run." >&2
  exit 1
fi

echo "==> VS Code settings"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [[ -d "$VSCODE_USER_DIR" ]]; then
  run cp "$REPO_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
  if command -v code >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    while IFS= read -r ext; do
      run code --install-extension "$ext"
    done < <(jq -r '.recommendations[]' "$REPO_DIR/vscode/extensions.json")
  else
    echo "    skipped extension install (code or jq not found)"
  fi
else
  echo "    skipped (VS Code not installed)"
fi

echo "==> macOS LaunchAgent (Caps Lock remap)"
run cp "$REPO_DIR/macos/launchagents/com.user.capslock-remap.plist" "$HOME/Library/LaunchAgents/"
run launchctl load "$HOME/Library/LaunchAgents/com.user.capslock-remap.plist"

echo "==> Finder quick actions"
run cp -R "$REPO_DIR/services/finder-new-item/New Item.workflow" "$HOME/Library/Services/"
run cp -R "$REPO_DIR/macos/automator/Send to Gmail.workflow" "$HOME/Library/Services/"
run cp -R "$REPO_DIR/services/send-to-ollama/Send to Ollama.workflow" "$HOME/Library/Services/"

echo "==> scripts/"
run chmod +x "$REPO_DIR"/scripts/*

cat <<'EOF'

Done. Remaining manual steps (see README.md):
  - Zen Browser: locate the profile (about:support) and copy zen/* in by hand.
  - Secrets: cp zsh/secrets.zsh.example ~/.secrets.zsh && chmod 600 ~/.secrets.zsh
  - SSH hosts: cp ssh/.ssh/config.local.example ~/.ssh/config.local, fill in real hosts.
  - Neovim: launch `nvim` once to let lazy.nvim bootstrap, then :MasonInstall
    the formatter/linter/debugger binaries listed in the README.
  - nushell: regenerate the starship/zoxide/atuin init files (README has the commands).
  - macOS system settings: scripts/macos-defaults --dry-run, then run for real
    if the output looks right.
  - Run scripts/doctor to confirm everything above actually took.
EOF
