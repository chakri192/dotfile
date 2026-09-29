export ZDOTDIR="$HOME/.config/zsh"
# scripts/ from this repo, wherever it's cloned: this file is a stow symlink,
# so resolve it (:A) and go up from zsh/.zshenv to the repo root.
export PATH="${${(%):-%x}:A:h:h}/scripts:$PATH"
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"
