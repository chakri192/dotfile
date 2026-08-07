# Nushell config — chakri
#
# Lives at ~/Library/Application Support/nushell/ (nu's macOS default);
# reachable at ~/.config/nushell via symlink.
#
# starship lives in ./autoload/, which nu sources for you at startup.
# zoxide and atuin are wired up explicitly instead — zoxide because its init
# exports a module (`source` would leave `z` in a namespace, so it needs
# `use`), atuin because its keybindings must be applied after the settings
# below or they get clobbered. Regenerate after upgrading any of them:
#   starship init nu      | save -f ($nu.default-config-dir | path join autoload starship.nu)
#   zoxide   init nushell | save -f ($nu.default-config-dir | path join zoxide.nu)
#   atuin    init nu      | save -f ($nu.default-config-dir | path join atuin.nu)

const zoxide_path = ($nu.default-config-dir | path join "zoxide.nu")
use $zoxide_path *                        # gives you `z` and `zi`

# ─── Shell behaviour ───────────────────────────────────────────────────────
$env.config.show_banner = false
$env.config.edit_mode = "emacs"          # matches your zsh bindings
$env.config.buffer_editor = "nvim"       # ctrl+o opens the current line in nvim
$env.config.rm.always_trash = true       # `rm` goes to Trash, recoverable
$env.config.table.index_mode = "auto"    # hide the # column on plain lists
$env.config.footer_mode = 25             # repeat headers on long tables

# SQLite history: unlimited, queryable, and per-session isolated so two tabs
# don't interleave. Old plaintext history stays readable either way.
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 1_000_000
$env.config.history.isolation = true

# Fuzzy completion — `cnf` matches `config.nu`. zsh side does the same thing
# via its matcher-list.
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.sort = "smart"
$env.config.completions.case_sensitive = false

# ─── Aliases ───────────────────────────────────────────────────────────────
# Deliberately NOT aliasing `ls` to eza. Nu's builtin ls returns a real table
# you can filter and sort — `ls | where size > 10mb` — and eza would flatten
# that back into text, which throws away the entire point of being in here.
# eza is still one keystroke away as `lt` when you want the tree view.
alias ll = ls -l
alias la = ls -la
alias lt = eza --tree --icons --level=2
alias cat = bat --style=plain --paging=never
alias vim = nvim
alias v = nvim

alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# Git — mirrors the handful you actually use in zsh
alias gst = git status
alias glog = git log --oneline --graph --decorate
alias gadog = git log --all --decorate --oneline --graph
# a def, not an alias: aliases can't expand $nu.home-path
def gclean [] { ^($nu.home-path | path join bin git-clean-branches.sh) }

# ─── Custom commands ───────────────────────────────────────────────────────
# `def --env` is how a command is allowed to change your working directory.

# cd + list, the nu port of your zsh `cx`
def --env cx [dir: path] { cd $dir; ls }

# fzf pickers. fzf has no native nu integration, so these call it directly.
def --env fcd [] {
  let dir = (fd --type d --hidden --exclude .git | fzf)
  if ($dir | is-not-empty) { cd ($dir | str trim); ls }
}

def fv [] {
  let file = (fd --type f --hidden --exclude .git | fzf)
  if ($file | is-not-empty) { nvim ($file | str trim) }
}

def f [] {
  fd --type f --hidden --exclude .git | fzf | str trim | pbcopy
}

# Homebrew maintenance, ported from your zsh brewup
def brewup [] {
  brew upgrade --greedy
  mas upgrade
  brew cleanup -s
}

# ─── Things worth knowing you have ─────────────────────────────────────────
# These are builtins, not config — listed here because they're the reason
# to be in nushell at all and they're easy to forget:
#
#   ls | where size > 10mb | sort-by modified | reverse
#   open pkg.json | get dependencies | transpose name version
#   ps | where cpu > 10 | select pid name cpu
#   sys mem | get used
#   ls **/*.py | get name | length
#   git log --oneline | lines | length
#
# `help commands | where name =~ str` searches the builtins.
# `explore` opens any table in a scrollable pager.

# ─── Atuin ─────────────────────────────────────────────────────────────────
# Last, on purpose: it upserts into $env.config.keybindings, so it has to run
# after the settings above. ctrl+R searches the same SQLite history your zsh
# uses — one history across both shells.
source ($nu.default-config-dir | path join "atuin.nu")
