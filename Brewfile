# Brewfile — dependencies for what's actually configured in this repo.
#
# This is deliberately NOT `brew bundle dump` of the whole machine — it's
# trimmed to what README.md documents as required or referenced. Install
# with: brew bundle install
#
# VS Code extensions are managed separately via vscode/extensions.json
# (see README's "VS Code" section), not listed here.

# ---------- Core shell tooling (zsh/ package) ----------
brew "zsh"
brew "stow"
brew "starship"
brew "atuin"
brew "zoxide"
brew "fzf"
brew "eza"
brew "bat"
brew "fd"
brew "ripgrep"
brew "jq"          # used by install.sh to read vscode/extensions.json
brew "mas"          # used by scripts/clean

# ---------- Git (git/ package) ----------
brew "git-delta"    # ~/.gitconfig sets `pager = delta`

# ---------- Terminal / prompt ----------
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"   # icons for starship, nvim statusline, completion menu

# ---------- Neovim (nvim/ package) ----------
brew "neovim"
brew "tree-sitter"  # CLI invoked by Treesitter's `main` branch to compile parsers

# ---------- Structured-data shell (nushell/ package) ----------
brew "nushell"

# ---------- Used by scripts/ ----------
brew "ollama"       # scripts/send-to-ollama, services/send-to-ollama

# ---------- Optional per-language toolchains ----------
# Only needed if you use the corresponding LSP servers/formatters in nvim/.
# brew "go"
# brew "node"
# brew "rustup"
