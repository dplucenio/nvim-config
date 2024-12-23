return {{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup()

    -- Set nvim-tree related mappings
    vim.keymap.set("n", "<leader>to", ":NvimTreeOpen<CR>")
    vim.keymap.set("n", "<leader>tt", ":NvimTreeFindFile<CR>")
  end
}}
