-- lua/plugins/explorer.lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Explorer toggle" },
      { "<leader>ef", "<cmd>NvimTreeFindFile<CR>", desc = "Explorer reveal file" },
    },
    init = function()
      -- disable netrw early so nvim-tree owns directory buffers
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      view = { width = 34, side = "left" },
      renderer = { group_empty = true, highlight_git = true },
      filters = { dotfiles = false, custom = { "^.git$", "__pycache__" } },
      git = { enable = true },
      actions = { open_file = { quit_on_open = false, resize_window = true } },
    },
  },
}
