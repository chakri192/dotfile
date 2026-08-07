-- lua/config/options.lua
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false            -- statusline already shows it
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.pumheight = 12
opt.cmdheight = 1
opt.laststatus = 3              -- global statusline
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { eob = " ", fold = " " }
opt.inccommand = "split"       -- live preview of :s

-- Behaviour
opt.mouse = "a"
opt.clipboard = "unnamedplus"  -- share macOS system clipboard
opt.breakindent = true
opt.wrap = false
opt.undofile = true
opt.swapfile = false
opt.confirm = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.ignorecase = true
opt.smartcase = true
opt.gp = "rg --vimgrep"        -- :grep uses ripgrep

-- Indentation (2 spaces default; treesitter handles per-language indentexpr)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

-- Folding via treesitter (opened by default)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Diagnostics float on jump
vim.o.winborder = "rounded"

-- Optional: pin a Python provider (uncomment + point at your conda/base env
-- that has `pynvim` installed) to avoid slow provider probing:
-- vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/bin/python3")
