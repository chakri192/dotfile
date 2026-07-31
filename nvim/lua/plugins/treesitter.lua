-- lua/plugins/treesitter.lua  — nvim-treesitter MAIN branch (requires nvim 0.11+)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      if type(ts.setup) == "function" then
        pcall(ts.setup)
      end

      -- Guard: the MAIN-branch API exposes install(); if this errors you're
      -- still on the archived master branch — run :Lazy sync to switch.
      if type(ts.install) ~= "function" then
        vim.schedule(function()
          vim.notify(
            "nvim-treesitter is on the old master branch. Run :Lazy sync (or reinstall) to move to main.",
            vim.log.levels.WARN
          )
        end)
        return
      end

      -- Parsers to keep installed (installs asynchronously if missing)
      local ensure = {
        "python", "c", "cpp", "lua", "luadoc", "vim", "vimdoc",
        "bash", "json", "yaml", "toml",
        "javascript", "typescript", "tsx", "rust", "go", "gomod", "gosum",
        "html", "css", "sql", "dockerfile",
        "markdown", "markdown_inline", "regex", "query",
        "diff", "gitcommit", "gitignore",
      }
      require("nvim-treesitter").install(ensure)

      -- Enable highlighting + treesitter indentation per filetype
      local ft = {
        "python", "c", "cpp", "lua", "vim", "bash", "sh",
        "json", "jsonc", "yaml", "toml",
        "javascript", "typescript", "typescriptreact", "rust", "go",
        -- (jsonc filetype maps onto the json parser automatically)
        "html", "css", "sql", "dockerfile",
        "markdown", "diff", "gitcommit", "query",
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("cfg_treesitter", { clear = true }),
        pattern = ft,
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Syntax-aware text objects (main branch API)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local map = vim.keymap.set

      -- select: af/if function, ac/ic class, aa/ia parameter
      local objs = {
        af = "@function.outer", ["if"] = "@function.inner",
        ac = "@class.outer", ic = "@class.inner",
        aa = "@parameter.outer", ia = "@parameter.inner",
      }
      for lhs, q in pairs(objs) do
        map({ "x", "o" }, lhs, function()
          select.select_textobject(q, "textobjects")
        end, { desc = "TS " .. q })
      end

      -- movement: ]f [f function, ]c [c class
      map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
      map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function" })
      map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class" })
      map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class" })
    end,
  },
}
