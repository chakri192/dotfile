-- lua/plugins/linting.lua  — standalone linters via nvim-lint
-- (Python is already linted by ruff LSP; C/C++ by clangd's clang-tidy.)
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
      }

      local grp = vim.api.nvim_create_augroup("cfg_nvim_lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = grp,
        callback = function()
          -- don't lint unmodifiable / special buffers
          if vim.bo.modifiable and vim.bo.buftype == "" then
            require("lint").try_lint()
          end
        end,
      })

      vim.keymap.set("n", "<leader>ll", function()
        require("lint").try_lint()
      end, { desc = "Lint buffer" })
    end,
  },
}
