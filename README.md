# dotfiles

Personal dotfiles and configuration for macOS development environment.

## ⚠️ hidden files note

Files and directories starting with a dot (`.vscode`, `.env`, etc.) are **hidden by default** in macOS Finder. To view them:

**Finder:**
```sh
Cmd + Shift + .
```

**Terminal:**
```sh
ls -la                    # show all files including hidden
open -a Finder .vscode    # open hidden folder in Finder
```

## contents

- **scripts/** — shell automation scripts
- **.vscode/** — VS Code settings and recommended extensions (hidden folder)

## scripts

| script | description |
|--------|-------------|
| `clean` | updates homebrew, mas, npm, pip and clears system caches, logs, browser data, and junk files |
| `netinfo` | displays local ip, public ip, gateway, dns, and wifi network name |

### install scripts

```sh
git clone https://github.com/chakri192/dotfile ~/.dotfiles
cd ~/.dotfiles
chmod +x clean netinfo
```

Add to your PATH in `~/.zshenv`:

```sh
export PATH="$HOME/.dotfiles:$PATH"
```

### usage

```sh
clean       # run full system cleanup + updates
netinfo     # show network info
```

### dependencies

- `zsh` — required shell
- `curl` — used by netinfo for public ip lookup
- `brew` — homebrew package manager
- `mas` — mac app store cli (`brew install mas`)
- `npm`, `pip3` — optional, skipped if not installed

## VS Code configuration

Optimized settings for Python, JavaScript/TypeScript, C/C++, and web development.

### features

- **Performance**: Disabled accessibility/telemetry, smooth scrolling, optimized minimap
- **Typography**: JetBrains Mono with ligatures, 13.5px editor font
- **File management**: Smart nesting for related files (e.g., `.ts` with `.js`, `.h` with `.c`)
- **Formatting**: Prettier (JS/JSON), Ruff (Python) with format-on-save
- **Quality of life**: Bracket colorization, sticky scroll, linked editing, bracket guides
- **Language overrides**: Python (Ruff + imports), Markdown (word wrap, no format), JSON

### setup

#### Step 1: View hidden `.vscode` folder

The `.vscode` directory is hidden by default. To see it in Finder:
```sh
# In Finder, press Cmd + Shift + . (dot)
# Or use terminal to open it:
open -a Finder .vscode
```

#### Step 2: Copy settings to VS Code

```sh
cp .vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

Or manually:
1. Open `.vscode/settings.json` in this repo
2. Copy its contents
3. Paste into VS Code: `Code` → `Preferences` → `Settings` (JSON tab)

#### Step 3: Install recommended extensions

Open VS Code and go to **Extensions** → **Recommended** to see and install all extensions at once.

Or install individually:
```sh
code --install-extension ms-python.python
code --install-extension charliermarsh.ruff
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
code --install-extension vscode-icons-team.vscode-icons
```

See `.vscode/extensions.json` for the full list:

- **Python**: Python, Ruff, Pylance, Jupyter
- **Web**: ESLint, Prettier, CSS Peek, Path Intellisense
- **Version Control**: GitLens, GitHub Pull Requests
- **AI**: GitHub Copilot Chat, Gemini Code Assist, Continue
- **Utilities**: Error Lens, Hex Editor, YAML, EditorConfig

## environment

macOS (Apple Silicon) · zsh · VS Code · tested on M4 MacBook Air
