-- lua/config/keymaps.lua
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move by visual line when no count given
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Grow height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shrink height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Shrink width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Grow width" })

-- Move lines (Alt+j/k)
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-1<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on jumps
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Void-register deletes / paste
map("x", "<leader>p", [["_dP]], { desc = "Paste (keep register)" })
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete to void" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Quick save / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>Q", "<cmd>quitall<CR>", { desc = "Quit all" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
