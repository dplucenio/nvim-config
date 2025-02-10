return {{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup()

    -- Set nvim-tree related mappings
    vim.keymap.set("n", "<leader>to", "<cmd>NvimTreeOpen<cr>")
    vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeFindFile<cr>")
    vim.keymap.set("n", "<leader>tg", "<cmd>NvimTreeToggle<cr>")
  end
}}
