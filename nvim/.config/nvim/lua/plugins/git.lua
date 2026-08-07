-- lua/plugins/git.lua
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = "Git: " .. desc })
        end
        map("]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("<leader>hs", gs.stage_hunk, "Stage hunk")
        map("<leader>hr", gs.reset_hunk, "Reset hunk")
        map("<leader>hp", gs.preview_hunk, "Preview hunk")
        map("<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("<leader>hd", gs.diffthis, "Diff this")
        map("<leader>hB", function() gs.blame() end, "Blame buffer")
      end,
    },
  },

  -- Full in-editor git UI (stage/commit per file, matches granular-commit workflow)
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      integrations = { telescope = true, diffview = true },
    },
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit status" },
      { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
      { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Neogit pull" },
      { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Neogit push" },
    },
  },

  -- Side-by-side diffs + file/branch history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
    },
  },
}
