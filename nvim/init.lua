-- ~/.config/nvim/init.lua
-- Leader keys must be set before lazy.nvim / any plugin loads.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Ensure CLI tools installed via Homebrew / Cargo are visible to jobs spawned
-- by nvim (e.g. tree-sitter, formatters). Terminal/GUI nvim on macOS doesn't
-- always inherit the interactive shell's PATH. Idempotent + safe.
do
  local extra = { "/opt/homebrew/bin", "/opt/homebrew/sbin", vim.fn.expand("~/.cargo/bin") }
  local path = vim.env.PATH or ""
  for _, dir in ipairs(extra) do
    if vim.fn.isdirectory(dir) == 1 and not (":" .. path .. ":"):find(":" .. dir .. ":", 1, true) then
      path = dir .. ":" .. path
    end
  end
  vim.env.PATH = path
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
