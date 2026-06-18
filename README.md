# dotfiles

Personal dotfiles and configuration for macOS development environment.

## contents

- **scripts/** — shell automation scripts
- **vscode/** — VS Code settings and recommended extensions
- **macos/** — launchd agents and Automator workflows

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

#### Step 1: Copy settings to VS Code

The `vscode/settings.json` file should be copied to VS Code's user settings directory:

```sh
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

**Or manually in VS Code:**
1. Open `vscode/settings.json` from this repo
2. Copy all contents
3. In VS Code: `Code` → `Preferences` → `Settings` → click `{}` (JSON tab)
4. Paste the contents

#### Step 2: Install recommended extensions

Open VS Code and navigate to **Extensions** → **Recommended** to see all extensions at once, then install.

**Or install via terminal:**
```sh
code --install-extension ms-python.python
code --install-extension charliermarsh.ruff
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension eamodio.gitlens
code --install-extension vscode-icons-team.vscode-icons
```

See `vscode/extensions.json` for the complete list of 20+ recommended extensions:

**Categories:**
- **Python**: Python, Ruff, Pylance, Jupyter
- **Web**: ESLint, Prettier, CSS Peek, Path Intellisense
- **Version Control**: GitLens, GitHub Pull Requests
- **AI**: GitHub Copilot Chat, Gemini Code Assist, Continue
- **Utilities**: Error Lens, Hex Editor, YAML, EditorConfig

#### Notes

- Files in `vscode/` map to VS Code's hidden `.vscode/User/` directory
- The `vscode/extensions.json` format is standard for VS Code workspace recommendations
- All settings are commented and organized by feature for easy customization

## macOS automation

launchd agents and Automator Services for system-level automation.

| item | type | description |
|------|------|-------------|
| `com.user.capslock-remap.plist` | launchd agent | remaps Caps Lock key |
| `Send to Gmail.workflow` | Automator Service | sends selection to Gmail |

### install

```sh
cp macos/launchagents/com.user.capslock-remap.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.user.capslock-remap.plist

cp -R "macos/automator/Send to Gmail.workflow" ~/Library/Services/
```

> **Note:** `Send to Gmail.workflow` ships with a placeholder recipient (`your-email@gmail.com`). Edit `Contents/document.wflow` and replace it with your own address before use.

## environment

macOS (Apple Silicon) · zsh · VS Code · tested on M4 MacBook Air

### AI tooling

Documentation assisted by local LLMs via [Ollama](https://ollama.com):

| Model | Used for |
|-------|----------|
| `qwen2.5-coder:7b` | Code suggestions, refactoring |
| `llama3.1:8b` | Prose, documentation, commit messages |
