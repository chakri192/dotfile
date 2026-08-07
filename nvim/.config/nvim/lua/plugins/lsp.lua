-- lua/plugins/lsp.lua  — native LSP (nvim 0.11 vim.lsp.config/enable) + mason
return {
  -- Lua LS knows about the nvim runtime + vim.uv when editing this config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Mason as its own spec so :Mason* commands work from the dashboard too
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = { ui = { border = "rounded" } },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Diagnostics presentation
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or true,
      })

      -- Give every server blink.cmp's capabilities
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Per-server settings (merged over nvim-lspconfig's shipped defaults)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
      })
      -- Ruff as a fast linter LSP alongside pyright (pyright does types, ruff lints).
      vim.lsp.config("ruff", {
        init_options = {
          settings = { configuration = vim.fn.stdpath("config") .. "/ruff.toml" },
        },
      })
      vim.lsp.config("yamlls", {
        settings = { yaml = { keyOrdering = false } },
      })

      -- Install + auto-enable the servers (mason-lspconfig v2 calls vim.lsp.enable)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "ruff", "clangd", "bashls",
          "ts_ls", "rust_analyzer", "gopls",
          "jsonls", "yamlls", "taplo", "marksman", "html", "cssls",
        },
        automatic_enable = true,
      })

      -- Buffer-local keymaps when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("cfg_lsp_attach", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local function map(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
          end

          map("grd", vim.lsp.buf.definition, "Definition")
          map("grD", vim.lsp.buf.declaration, "Declaration")
          map("gri", vim.lsp.buf.implementation, "Implementation")
          map("grt", vim.lsp.buf.type_definition, "Type definition")
          map("grr", vim.lsp.buf.references, "References")
          map("grn", vim.lsp.buf.rename, "Rename")
          map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
          map("<leader>ls", vim.lsp.buf.signature_help, "Signature help")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Let pyright own hover; ruff is lint/format only
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- Inlay hints toggle
          if client and client:supports_method("textDocument/inlayHint") then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
                { bufnr = buf }
              )
            end, "Toggle inlay hints")
          end

          -- Highlight references of symbol under cursor
          if client and client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("cfg_lsp_highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = hl, buffer = buf, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = hl, buffer = buf, callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
