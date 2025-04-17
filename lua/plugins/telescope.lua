return {
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.8',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "xiyaowong/telescope-emoji.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.load_extension("fzf")
      telescope.load_extension("emoji")

      vim.keymap.set("n", "<leader>T", "<cmd>Telescope<cr>", { desc = "Telescope" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>",
        { desc = "Telescope find files (including hidden)" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set(
        "n", "<leader>fG",
        -- Note: in case we'd like to search also to ignored files (besides hidden):
        -- Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--hidden,--no-ignore<cr>
        -- Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--hidden,--no-ignore<cr>
        "<cmd>Telescope live_grep vimgrep_arguments=rg,--color=never,--no-heading,--with-filename,--line-number,--column,--smart-case,--hidden<cr>",
        { desc = "Telescope live grep (including hidden)" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      -- Optionally set gr as Telescope lsp_references:
      -- vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>")
    end
  },
  { "xiyaowong/telescope-emoji.nvim" },
}
