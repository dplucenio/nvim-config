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
      vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
      vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float(nil, {
          focusable = true,
          border = "rounded",
        })
      end, opts)
      vim.keymap.set("n", "]w", function()
        vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
      end, opts)
      vim.keymap.set("n", "[w", function()
        vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
      end, opts)
      vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
      vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
      vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
      -- `gr` can be set on telescope config (to use Telescope lsp_references)
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
      vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
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
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = "rounded",
          focusable = true,
        }
      )

      -- Pull completion capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Define per-server options here (you can add cmd/root_dir/etc. as needed)
      local servers = {
        clangd        = { enabled = true },   -- C/C++
        lua_ls        = { enabled = true },   -- Lua
        jsonls        = { enabled = true },   -- JSON
        yamlls        = { enabled = true },   -- YAML
        pylsp         = { enabled = true },   -- Python
        marksman      = { enabled = true },   -- Markdown
        terraformls   = { enabled = true },   -- Terraform
        rust_analyzer = { enabled = true },   -- Rust
        jdtls         = { enabled = true },   -- Java
        kotlin_lsp    = {                     -- Kotlin
          enabled = true,
          cmd = { "kotlin-lsp", "--stdio" },
        },
      }

      -- Register & enable each server using the 0.11 API
      for name, cfg in pairs(servers) do
        -- Consume custom `enabled` entry in cfg table and remove it:
        local enabled = cfg.enabled ~= false; cfg.enabled = nil
        cfg.capabilities = capabilities
        vim.lsp.config(name, cfg)
        -- Enabled only when enabled == true
        if enabled then vim.lsp.enable(name) end
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
