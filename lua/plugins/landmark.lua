return { {
  dir = "~/projects/landmark.nvim/",
  config = function()
    vim.keymap.set("n", "<leader>la", "<cmd>Landmark<cr>", { desc = "Landmark overview" })
    vim.keymap.set("n", "<leader>lA", "<cmd>Landmark!<cr>", { desc = "Landmark focus current" })
    vim.keymap.set("n", "<leader>co", "<cmd>ContentView<cr>", { desc = "ContentView overview" })
    vim.keymap.set("n", "<leader>cO", "<cmd>ContentView!<cr>", { desc = "ContentView focus current" })
  end
} }
