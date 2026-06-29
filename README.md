# dotfiles

Personal dotfiles and configuration for macOS development environment.

## contents

- **scripts/** — shell automation scripts
- **vscode/** — VS Code settings and recommended extensions
- **zen/** — Zen Browser `about:config` tweaks and chrome CSS

---

## scripts

| script    | description                                                                                   |
| --------- | --------------------------------------------------------------------------------------------- |
| `clean`   | updates homebrew, mas, npm, pip and clears system caches, logs, browser data, and junk files |
| `netinfo` | displays local ip, public ip, gateway, dns, and wifi network name                             |

### install

```zsh
git clone https://github.com/chakri192/dotfile ~/.dotfiles
cd ~/.dotfiles
chmod +x clean netinfo
```

Add to `~/.zshenv`:

```zsh
export PATH="$HOME/.dotfiles:$PATH"
```

### usage

```zsh
clean      # full system cleanup + updates
netinfo    # show network info
```

### dependencies

- `zsh` — required shell
- `curl` — used by netinfo for public ip lookup
- `brew` — homebrew package manager
- `mas` — mac app store cli (`brew install mas`)
- `npm`, `pip3` — optional, skipped if not installed

---

## VS Code configuration

Optimized settings for Python, JavaScript/TypeScript, C/C++, and web development.

### features

- **Performance**: disabled accessibility/telemetry, smooth scrolling, optimized minimap
- **Typography**: JetBrains Mono with ligatures, 13.5px editor font
- **File management**: smart nesting for related files (`.ts` with `.js`, `.h` with `.c`)
- **Formatting**: Prettier (JS/JSON), Ruff (Python) with format-on-save
- **Quality of life**: bracket colorization, sticky scroll, linked editing, bracket guides
- **Language overrides**: Python (Ruff + imports), Markdown (word wrap, no format), JSON

### setup

```zsh
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

Install extensions:

```zsh
code --install-extension ms-python.python
code --install-extension charliermarsh.ruff
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
code --install-extension vscode-icons-team.vscode-icons
```

See `vscode/extensions.json` for the full list of 20+ extensions across Python, web, git, AI, and utilities.

---

## Zen Browser configuration

Performance and privacy tweaks for [Zen Browser](https://zen-browser.app), tuned for Apple Silicon / macOS.

### files

| file               | location in profile  | description                                      |
| ------------------ | -------------------- | ------------------------------------------------ |
| `zen/user.js`      | `<profile>/`         | `about:config` overrides applied on every launch |
| `zen/userChrome.css`  | `<profile>/chrome/`  | browser UI customization                         |
| `zen/userContent.css` | `<profile>/chrome/`  | webpage-level style overrides                    |
| `zen/zen-themes.css`  | `<profile>/chrome/`  | Zen-specific theme overrides                     |

### what user.js covers

- **Performance** — WebRender/Metal compositor, 60fps frame rate, HTTP/3, DNS prefetch, larger disk/memory cache
- **Memory** — incremental GC, background tab unloading after 3 min, reduced session I/O
- **Privacy** — social/fingerprint/cryptomining tracking blocked, all Mozilla telemetry disabled
- **Apple Silicon** — Metal GPU API, hardware video decode, async APZ scrolling, zero paint delay

### install

```zsh
# Find your profile folder: open Zen → about:support → Profile Folder
PROFILE="$HOME/Library/Application Support/zen/Profiles/<your-profile>"

cp zen/user.js "$PROFILE/"
cp zen/userChrome.css zen/userContent.css zen/zen-themes.css "$PROFILE/chrome/"
```

Restart Zen — `user.js` values are applied on every launch and override `prefs.js`.

> To permanently apply a setting without `user.js`, set it in `about:config` directly.

---

## environment

macOS (Apple Silicon) · zsh · VS Code · Zen Browser · tested on M4 MacBook Air

### AI tooling

Documentation assisted by local LLMs via [Ollama](https://ollama.com):

| model              | used for                              |
| ------------------ | ------------------------------------- |
| `qwen2.5-coder:7b` | code suggestions, refactoring         |
| `llama3.1:8b`      | prose, documentation, commit messages |
