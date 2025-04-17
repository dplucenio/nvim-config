return { {
  dir = "~/projects/landmark.nvim/",
  config = function()
    vim.keymap.set("n", "<leader>la", "<cmd>Landmark<cr>")
    vim.keymap.set("n", "<leader>co", "<cmd>ContentView<cr>")
  end
} }
