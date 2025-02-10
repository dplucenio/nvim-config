return { {
  "tpope/vim-fugitive",
  config = function()
    -- Set fugitive related mappings
    vim.keymap.set("n", "<leader>g", ":Ge:<CR>")
  end
} }
