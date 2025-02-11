return { {
  dir = "~/projects/landmark.nvim/",
  config = function()
    vim.keymap.set("n", "<leader>L", "<cmd>Landmark<cr>")
  end
} }
