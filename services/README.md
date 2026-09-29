# Finder quick actions

Install by copying into `~/Library/Services/` (`install.sh` does this for you). They then appear when you right-click files in Finder, under **Quick Actions**.

| Action | |
|---|---|
| **New Item** | Creates an empty file in the current folder |
| **Send to Ollama** | Summarises the selected files with a local AI model and saves `<name>-summary.md` next to each |

```zsh
cp -R "finder-new-item/New Item.workflow" ~/Library/Services/
cp -R "send-to-ollama/Send to Ollama.workflow" ~/Library/Services/
```

Send to Ollama needs [Ollama](https://ollama.com) with a model installed (default `llama3.1:8b`), and the repo cloned to `~/Documents/portfolio/dotfile`.

The Send to Gmail action is in [`../macos/automator/`](../macos/automator/).
