# ~/.config/zsh/prompt.zsh

# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

eval "$(starship init zsh)"

# One blank line under the "Last login" banner. Starship's add_newline would
# add one before every prompt, so do it once per shell instead.
[[ -t 1 ]] && print
