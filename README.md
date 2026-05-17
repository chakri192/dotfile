# scripts

Personal shell scripts for macOS — automation, maintenance, and terminal quality of life.

## scripts

| script | description |
|--------|-------------|
| `clean` | updates homebrew, mas, npm, pip and clears system caches, logs, browser data, and junk files |
| `netinfo` | displays local ip, public ip, gateway, dns, and wifi network name |

## install

```sh
git clone https://github.com/chakri192/scripts ~/.scripts
cd ~/.scripts
chmod +x clean netinfo
```

Add to your PATH in `~/.zshenv`:

```sh
export PATH="$HOME/.scripts:$PATH"
```

## usage

```sh
clean       # run full system cleanup + updates
netinfo     # show network info
```

## dependencies

- `zsh` — required shell
- `curl` — used by netinfo for public ip lookup
- `brew` — homebrew package manager
- `mas` — mac app store cli (`brew install mas`)
- `npm`, `pip3` — optional, skipped if not installed

## environment

macOS (Apple Silicon) · zsh · tested on M4 MacBook Air
