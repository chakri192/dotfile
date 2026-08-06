<div align="center">

# dotfiles

**Configuration and automation for a single macOS machine.**

Shell utilities, a modular Neovim configuration, editor and browser settings, and Finder quick actions.

<p>
  <img alt="Platform" src="https://img.shields.io/badge/macOS-Apple%20Silicon-1c1c1e?style=flat-square&logo=apple&logoColor=white" />
  <img alt="Shell" src="https://img.shields.io/badge/zsh-5%20tools-1c1c1e?style=flat-square&logo=gnubash&logoColor=4EAA25" />
  <img alt="Neovim" src="https://img.shields.io/badge/Neovim-0.11%2B-1c1c1e?style=flat-square&logo=neovim&logoColor=57A143" />
  <img alt="Editor" src="https://img.shields.io/badge/VS%20Code-20%20extensions-1c1c1e?style=flat-square&logo=visualstudiocode&logoColor=007ACC" />
  <img alt="License" src="https://img.shields.io/badge/license-MIT-1c1c1e?style=flat-square" />
</p>

<sub>Tested on an M4 MacBook Air. Each directory is independent and can be adopted separately.</sub>

</div>

---

## Contents

| Directory | Contents | Installs to |
|---|---|---|
| `scripts/` | Five zsh utilities | `$PATH`, via `~/.zshenv` |
| `nvim/` | Modular configuration — native LSP, Treesitter, lazy.nvim | `~/.config/nvim` (symlink) |
| `vscode/` | Settings and 20 recommended extensions | `~/Library/Application Support/Code/User/` |
| `zen/` | Zen Browser `user.js`, chrome CSS, theme exports | Profile root and `chrome/` |
| `macos/` | A LaunchAgent and an Automator workflow | `~/Library/LaunchAgents/`, `~/Library/Services/` |
| `services/` | Finder quick actions | `~/Library/Services/` |

**Only `nvim/` is symlinked.** Every other directory is copied into place, so updating this repository does not update the machine; the relevant files must be copied again after a pull.

---

## Scripts

| Script | Description |
|---|---|
| `clean` | Updates brew, mas, npm, and pip; purges system, VS Code, Zen, and Xcode DerivedData caches; clears logs and trash; flushes DNS; and reports space recovered. `--dry-run` previews without modifying anything. `--node` additionally prunes `node_modules` — opt-in, and destructive |
| `netinfo` | Reports local IP, public IP, gateway, DNS servers, and the current Wi-Fi network |
| `git-clean-branches` | Scans one level deep for repositories and deletes local branches merged into `main` or `master`, or whose remote-tracking branch is gone. Defaults to preview mode |
| `repo-sync` | Scans one level deep for repositories under a base directory and fast-forward pulls those behind their upstream. Repositories that are ahead, diverged, or without an upstream are reported and skipped |
| `send-to-ollama` | Summarises a file through a local Ollama model, writing `<name>-summary.md` alongside the original |

### Installation

```zsh
git clone https://github.com/chakri192/dotfile ~/Documents/portfolio/dotfile
cd ~/Documents/portfolio/dotfile
chmod +x scripts/*
```

Add to `~/.zshenv`:

```zsh
export PATH="$HOME/Documents/portfolio/dotfile/scripts:$PATH"
```

### Usage

```zsh
clean                           # full cleanup and updates
clean --dry-run                 # report what would be removed
clean --node                    # additionally prune node_modules
netinfo                         # network summary
git-clean-branches              # preview stale branches under the current directory
git-clean-branches ~/dev -y     # delete them
repo-sync                       # fast-forward pull repositories under the base directory
```

### Dependencies

`zsh` is required. `curl` is used by `netinfo` for public IP lookup. Homebrew, `mas`, `npm`, and `pip3` are each optional and skipped by `clean` when absent. `clean` requires `sudo` for periodic maintenance and DNS flushing.

---

## macOS integration

### Caps Lock remapping

`macos/launchagents/com.user.capslock-remap.plist` remaps Caps Lock to Right Command using the native `hidutil` interface, with no third-party remapping software.

```zsh
cp macos/launchagents/com.user.capslock-remap.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.user.capslock-remap.plist
```

### Finder quick actions

| Action | Description |
|---|---|
| **New Item** | Creates an empty file from the right-click menu |
| **Send to Gmail** | Sends selected files as attachments through Mail.app via AppleScript |
| **Send to Ollama** | Runs selected files through `scripts/send-to-ollama` and writes a summary alongside each original |

```zsh
cp -R "services/finder-new-item/New Item.workflow" ~/Library/Services/
cp -R "macos/automator/Send to Gmail.workflow" ~/Library/Services/
cp -R "services/send-to-ollama/Send to Ollama.workflow" ~/Library/Services/
```

Send to Ollama requires `scripts/send-to-ollama` on `$PATH` and `bat` for content extraction. Its Run Shell Script step invokes the script at the literal path `$HOME/Documents/portfolio/dotfile/scripts/send-to-ollama`, so the repository must be cloned to that location or the workflow edited. See [`services/README.md`](services/README.md).

| Quick Action | Demonstration |
|---|---|
| New Item | ![new item](assets/demos/new-item.gif) |
| Send to Gmail | ![send to gmail](assets/demos/send-to-gmail-1.gif) ![send to gmail](assets/demos/send-to-gmail-2.gif) |
| Send to Ollama | ![send to ollama](assets/demos/send-to-ollama.gif) |

---

## Neovim

A modular configuration targeting **Neovim 0.11 or later**, built on [lazy.nvim](https://github.com/folke/lazy.nvim) with the native LSP API (`vim.lsp.config` and `vim.lsp.enable`), Treesitter from the `main` branch, and [blink.cmp](https://github.com/saghen/blink.cmp) completion.

### Layout

| Path | Contents |
|---|---|
| `nvim/init.lua` | Leader keys, PATH shim for spawned jobs, module loader |
| `nvim/lua/config/` | `options`, `keymaps`, `autocmds`, lazy bootstrap |
| `nvim/lua/plugins/` | One file per concern — LSP, completion, Treesitter, Telescope, git, UI, editor, DAP, linting |
| `nvim/stylua.toml` · `nvim/ruff.toml` · `nvim/clang-format` | Formatter and linter configuration referenced by conform and ruff |

### Configuration

| Area | Detail |
|---|---|
| LSP | Native, without the lspconfig framework: pyright, ruff, clangd, lua_ls, bashls, ts_ls, rust_analyzer, gopls, jsonls, yamlls, taplo, marksman, html, cssls, installed through [mason](https://github.com/mason-org/mason.nvim) |
| Completion | blink.cmp with LSP, snippet, path, buffer, and lazydev sources |
| Syntax | Treesitter `main` branch — highlighting, indentation, folds, sticky context, textobjects |
| Fuzzy finding | Telescope with fzf-native |
| Git | gitsigns for hunks; Neogit and diffview for staging and commits |
| Formatting | conform on save — stylua, ruff, clang-format, shfmt, prettier, rustfmt, goimports, taplo |
| Linting | ruff and clang-tidy, plus nvim-lint for shellcheck, yamllint, markdownlint, and hadolint |
| Debugging | nvim-dap with dap-ui — Python through debugpy, C/C++/Rust through codelldb |
| Quality of life | flash, oil, todo-comments, render-markdown, which-key, trouble, toggleterm, tokyonight |

### Installation

```zsh
[ -e ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
ln -s ~/Documents/portfolio/dotfile/nvim ~/.config/nvim
nvim   # lazy.nvim bootstraps and installs plugins on first launch
```

Then install the external tool binaries through mason:

```
:MasonInstall prettierd shfmt stylua taplo goimports yamlfmt \
  shellcheck markdownlint-cli2 yamllint hadolint debugpy codelldb
```

### Dependencies

Neovim 0.11 or later is required for the native LSP API. The Treesitter `main` branch invokes the **tree-sitter CLI** to compile parsers (`brew install tree-sitter`), which in turn requires a **C compiler**. **ripgrep** backs Telescope live-grep and `:grep`. A **Nerd Font** provides the icons used in the statusline, file tree, and completion menu. Per-language toolchains — `go`, `cargo`, `node` — are required for the corresponding servers and formatters.

---

## VS Code

Settings tuned for Python, JavaScript and TypeScript, C and C++, and web development.

| Area | Configuration |
|---|---|
| Performance | Accessibility support and telemetry disabled, smooth scrolling, reduced minimap |
| Typography | JetBrains Mono with ligatures at 13.5px |
| File management | Smart nesting for related files — `.ts` with `.js`, `.h` with `.c` |
| Formatting | Prettier for JS and JSON, Ruff for Python, both on save |
| Editing | Bracket pair colourisation, sticky scroll, linked editing, indentation guides |
| Language overrides | Python (Ruff with import organisation), Markdown (word wrap, no formatting), JSON |

```zsh
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
jq -r '.recommendations[]' vscode/extensions.json | xargs -n1 code --install-extension
```

Twenty extensions spanning Python, C and C++, web, git, and AI tooling. The complete list is in `vscode/extensions.json`.

---

## Zen Browser

Performance and privacy configuration for [Zen Browser](https://zen-browser.app), tuned for Apple Silicon.

| File | Location in profile | Purpose |
|---|---|---|
| `zen/user.js` | Profile root | `about:config` overrides applied on every launch |
| `zen/userChrome.css` | `chrome/` | Browser interface customisation |
| `zen/userContent.css` | `chrome/` | Page-level style overrides |
| `zen/zen-themes.css` | `chrome/` | Zen-specific theme overrides |
| `zen/zen-themes/` | `chrome/zen-themes/` | Exported Zen Theme Store themes |

`user.js` covers four areas: **performance** (WebRender and Metal compositor, 60fps frame rate, HTTP/3, DNS prefetch, enlarged caches), **memory** (incremental garbage collection, background tab unloading after three minutes, reduced session I/O), **privacy** (social, fingerprinting, and cryptomining tracker blocking; all telemetry disabled), and **Apple Silicon** (Metal GPU API, hardware video decoding, asynchronous scrolling, zero paint delay).

```zsh
# Locate the profile: Zen → about:support → Profile Folder
PROFILE="$HOME/Library/Application Support/zen/Profiles/<your-profile>"

cp zen/user.js "$PROFILE/"
cp zen/userChrome.css zen/userContent.css zen/zen-themes.css "$PROFILE/chrome/"
cp -R zen/zen-themes "$PROFILE/chrome/"
```

Restart Zen. `user.js` values are applied on every launch and override `prefs.js`.

---

## Environment

macOS on Apple Silicon, zsh, VS Code, and Zen Browser. Tested on an M4 MacBook Air.

## License

[MIT](LICENSE) © V Chakradhar

## Contributors

| | |
|---|---|
| [chakri192](https://github.com/chakri192) | Author |
| [aider](https://github.com/Aider-AI/aider) | AI pair programmer |

Documentation assisted by aider using local models through [Ollama](https://ollama.com): `qwen2.5-coder:7b` for code and `llama3.1:8b` for prose.
