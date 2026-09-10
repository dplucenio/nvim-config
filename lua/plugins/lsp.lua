-- This is where you enable features that only work if there is a language
-- server active in the file
local function lspattachconfig()
  local group = vim.api.nvim_create_augroup("UserLspAttachActions", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "LSP actions",
    callback = function(event)
      local client = event.data and vim.lsp.get_client_by_id(event.data.client_id) or nil
      if client then
        vim.notify(("LSP attached: %s"):format(client.name), vim.log.levels.INFO)
      end

      local opts = { buffer = event.buf }
      local has_telescope, telescope_builtin = pcall(require, "telescope.builtin")
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({
          border = "rounded",
          focusable = true,
        })
      end, opts)
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float(nil, {
          focusable = true,
          border = "rounded",
        })
      end, opts)
      vim.keymap.set("n", "]w", function()
        vim.diagnostic.jump({ count = 1, severity = { min = vim.diagnostic.severity.WARN } })
      end, opts)
      vim.keymap.set("n", "[w", function()
        vim.diagnostic.jump({ count = -1, severity = { min = vim.diagnostic.severity.WARN } })
      end, opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
      if has_telescope then
        vim.keymap.set("n", "<leader>fs", telescope_builtin.lsp_document_symbols, opts)
        vim.keymap.set("n", "<leader>fS", telescope_builtin.lsp_workspace_symbols, opts)
      end
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
      -- Optional: use Telescope for references instead.
      -- if has_telescope then
      --   vim.keymap.set("n", "gr", telescope_builtin.lsp_references, opts)
      -- end
      vim.keymap.set("n", "gs", function()
        vim.lsp.buf.signature_help({
          border = "rounded",
          focusable = true,
        })
      end, opts)
      vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
      vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
      vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "folke/lazydev.nvim",
    },
    config = function()
      -- Pull completion capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.filetype.add({
        pattern = {
          [".*%.data%-type%.kts"] = "simkit-data-type",
          [".*%.method%.kts"] = "simkit-method",
          [".*%.workflow%-type%.kts"] = "simkit-workflow-type",
        },
      })

      -- Define per-server options here (you can add cmd/root_dir/etc. as needed)
      local servers = {
        clangd        = { enabled = true },   -- C/C++
        neocmake      = { enabled = true },   -- CMake
        gopls         = { enabled = true },   -- Go
        lua_ls        = { enabled = true },   -- Lua
        jsonls        = {                     -- JSON
          enabled = true,
          cmd = { "vscode-json-language-server", "--stdio" },
        },
        yamlls        = { enabled = true },   -- YAML
        pylsp         = { enabled = true },   -- Python
        marksman      = { enabled = true },   -- Markdown
        terraformls   = {                     -- Terraform
          enabled = true,
          on_attach = function(_, bufnr)
            if vim.lsp.codelens.enable then
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            else
              -- Neovim 0.11 has refresh(), but not enable().
              vim.lsp.codelens.refresh({ bufnr = bufnr })
            end
          end,
        },
        rust_analyzer = { enabled = true },   -- Rust
        vtsls         = {                     -- TypeScript / JavaScript
          enabled = true,
          cmd = { "vtsls", "--stdio" },
        },
        kotlin_lsp    = {                     -- Kotlin
          enabled = true,
          cmd = { "kotlin-lsp", "--stdio" },
        },
        simkit_ide_lsp = {                    -- SimKit DSL scripts
          enabled = true,
          cmd = { "simkit", "lsp" },
          filetypes = {
            "simkit-data-type",
            "simkit-method",
            "simkit-workflow-type",
          },
          root_markers = { ".git" },
        },
      }

      -- Register & enable each server using the 0.11 API
      for name, cfg in pairs(servers) do
        local enabled = cfg.enabled ~= false
        cfg.enabled = nil
        cfg.capabilities = capabilities
        vim.lsp.config(name, cfg)
        if enabled then
          vim.lsp.enable(name)
        end
      end

      -- Extra buffer-local keymaps & behavior:
      lspattachconfig()
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
    opts_extend = { "sources.default" }
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
      -- Disable when a .luarc.json file is found:
      enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end,
    },
  }
}
