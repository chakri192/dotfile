# services

macOS Finder Quick Actions (Services). Each is a `.workflow` bundle installed by
copying it into `~/Library/Services/`; it then appears in the Finder right-click
menu under **Quick Actions** (and in  → System Settings → Keyboard → Keyboard
Shortcuts → Services).

## New Item

`finder-new-item/New Item.workflow` — creates a new empty file in the current
Finder folder (à la Windows' "New > Text Document"), straight from the
right-click menu.

```zsh
cp -R "finder-new-item/New Item.workflow" ~/Library/Services/
```

## Send to Ollama

`send-to-ollama/Send to Ollama.workflow` — runs the selected files through
`scripts/send-to-ollama`, which summarizes each with a local Ollama model and
writes `<name>-summary.md` next to the original.

```zsh
cp -R "send-to-ollama/Send to Ollama.workflow" ~/Library/Services/
```

### requirements

- `scripts/send-to-ollama` on `$PATH` — the workflow's Run Shell Script step
  invokes it via `$HOME/Documents/portfolio/dotfile/scripts/send-to-ollama`, so
  it must live at that literal path.
- [Ollama](https://ollama.com) installed and a model pulled (default
  `llama3.1:8b`; override with `OLLAMA_MODEL`, e.g. `OLLAMA_MODEL=qwen2.5:7b`).
- `bat` (optional) for content extraction; falls back to plain `cat` if absent.

> The "Send to Gmail" Quick Action lives under `macos/automator/` — see the
> repo README's macOS section.
