-- lua/plugins/editor.lua
return {
  -- Surround: cs"' ds" ysiw)  etc.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto-close brackets/quotes (integrates with blink automatically)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Formatting (conform). Binaries installable via :Mason
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        rust = { "rustfmt" },
        go = { "goimports", "gofmt" },
        toml = { "taplo" },
        json = { "prettierd", "prettier", "jq", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", "yamlfmt", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      },
      -- Point clang-format / ruff at the global configs kept in the nvim dir.
      formatters = {
        clang_format = {
          prepend_args = { "--style=file:" .. vim.fn.stdpath("config") .. "/clang-format" },
        },
        ruff_format = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/ruff.toml" },
        },
        ruff_organize_imports = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/ruff.toml" },
        },
      },
      -- Only autoformat if a real formatter exists; fall back to LSP otherwise.
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
        vim.notify("Autoformat " .. ((vim.g.disable_autoformat or vim.b.disable_autoformat) and "OFF" or "ON"))
      end, { bang = true, desc = "Toggle autoformat (! = buffer only)" })
    end,
  },

  -- Floating / split terminal (<C-\> to toggle)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { [[<C-\>]], desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=horizontal size=15<CR>", desc = "Horizontal terminal" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
      shade_terminals = true,
    },
  },
}
