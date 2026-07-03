# dotfiles

Personal macOS scripts, configs, and automation. Tested on M4 MacBook Air (Apple Silicon).

## contents

- **scripts/** — `clean`, `netinfo`, `git-clean-branches`
- **macos/** — LaunchAgents and Automator workflows
- **services/** — Finder Quick Actions
- **vscode/** — settings and recommended extensions
- **zen/** — Zen Browser `user.js`, chrome CSS, and theme store exports

---

## scripts

| script               | description                                                                                    |
| -------------------- | ------------------------------------------------------------------------------------------------ |
| `clean`               | updates brew/mas/npm/pip, purges caches (system, VS Code, Zen, Xcode DerivedData), clears logs/trash, flushes DNS, reports space freed |
| `netinfo`             | prints local IP, public IP, gateway, DNS servers, and current Wi-Fi network                     |
| `git-clean-branches`  | scans one level deep for git repos and deletes local branches merged into `main`/`master` or with a gone remote-tracking branch; defaults to preview mode |

### install

```zsh
git clone https://github.com/chakri192/dotfile ~/.dotfiles
cd ~/.dotfiles
chmod +x scripts/clean scripts/netinfo scripts/git-clean-branches scripts/send-to-ollama
```

Add to `~/.zshenv`:

```zsh
export PATH="$HOME/.dotfiles/scripts:$PATH"
```

### usage

```zsh
clean                        # full system cleanup + updates
netinfo                      # show network info
git-clean-branches           # preview stale branches in repos under cwd
git-clean-branches ~/dev -y  # actually delete them
git-clean-branches ~/dev -y -f  # force-delete even if unmerged
```

### dependencies

- `zsh` — required shell
- `curl` — used by `netinfo` for public IP lookup
- `brew` — Homebrew (optional, skipped by `clean` if missing)
- `mas` — Mac App Store CLI, `brew install mas` (optional)
- `npm`, `pip3` — optional, skipped if not installed
- `sudo` — `clean` needs it for `periodic` maintenance and DNS flush

---

## macos/

### LaunchAgent — Caps Lock remap

`macos/launchagents/com.user.capslock-remap.plist` remaps Caps Lock to Right Command via native `hidutil`, no Karabiner-Elements required.

```zsh
cp macos/launchagents/com.user.capslock-remap.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.user.capslock-remap.plist
```

### Automator — Send to Gmail

`macos/automator/Send to Gmail.workflow` is a Finder Quick Action that drives Mail.app via AppleScript to send selected files as attachments.

```zsh
cp -R "macos/automator/Send to Gmail.workflow" ~/Library/Services/
```

---

## services/

`services/finder-new-item/New Item.workflow` — Finder Quick Action for creating new empty files (à la Windows' "New > Text Document") directly from the right-click menu.

```zsh
cp -R "services/finder-new-item/New Item.workflow" ~/Library/Services/
```

### Send to Ollama

`services/send-to-ollama/Send to Ollama.workflow` — Finder Quick Action that runs selected files through `scripts/send-to-ollama` (local `llama3.1:8b` via Ollama), writing `<name>-summary.md` next to each original.

```zsh
cp -R "services/send-to-ollama/Send to Ollama.workflow" ~/Library/Services/
```

Requires `scripts/send-to-ollama` on `$PATH` (see [scripts install](#install)) and `bat` for content extraction. Depends on `~/.dotfiles/scripts/send-to-ollama` being at that literal path — the workflow's Run Shell Script step calls it via `$HOME/.dotfiles/scripts/send-to-ollama`.

---

## VS Code configuration

Optimized settings for Python, JavaScript/TypeScript, C/C++, and web development.

### features

- **Performance** — disabled accessibility/telemetry, smooth scrolling, optimized minimap
- **Typography** — JetBrains Mono with ligatures, 13.5px editor font
- **File management** — smart nesting for related files (`.ts` with `.js`, `.h` with `.c`)
- **Formatting** — Prettier (JS/JSON), Ruff (Python) with format-on-save
- **Quality of life** — bracket colorization, sticky scroll, linked editing, bracket guides
- **Language overrides** — Python (Ruff + imports), Markdown (word wrap, no format), JSON

### setup

```zsh
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

Install extensions — open the folder in VS Code and accept the "Install Recommended Extensions" prompt, or:

```zsh
jq -r '.recommendations[]' vscode/extensions.json | xargs -n1 code --install-extension
```

20 total, spanning Python, C/C++, web, git, and AI tooling: `ms-python.python`, `charliermarsh.ruff`, `esbenp.prettier-vscode`, `dbaeumer.vscode-eslint`, `eamodio.gitlens`, `ms-toolsai.jupyter`, `github.copilot-chat`, `google.geminicodeassist`, and more — see `vscode/extensions.json` for the full list.

---

## Zen Browser configuration

Performance and privacy tweaks for [Zen Browser](https://zen-browser.app), tuned for Apple Silicon.

### files

| file                   | location in profile | description                                       |
| ---------------------- | -------------------- | -------------------------------------------------- |
| `zen/user.js`          | `<profile>/`          | `about:config` overrides applied on every launch  |
| `zen/userChrome.css`   | `<profile>/chrome/`   | browser UI customization                          |
| `zen/userContent.css`  | `<profile>/chrome/`   | webpage-level style overrides                     |
| `zen/zen-themes.css`   | `<profile>/chrome/`   | Zen-specific theme overrides                      |
| `zen/zen-themes/`      | `<profile>/chrome/zen-themes/` | exported Zen Theme Store themes (per-theme `chrome.css`, some with `preferences.json`) |

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
cp -R zen/zen-themes "$PROFILE/chrome/"
```

Restart Zen — `user.js` values apply on every launch and override `prefs.js`.

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
<!-- Pull Shark Test 1 -->



<!-- Force Shark Badge -->
