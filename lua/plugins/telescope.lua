return {
  {
    "nvim-telescope/telescope.nvim",
    version = '*',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "xiyaowong/telescope-emoji.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local layout = "horizontal" -- switch to "horizontal" if you want side-by-side again

      telescope.setup({
        defaults = {
          layout_strategy = layout,
          path_display = { "smart" }, -- options: "smart", "truncate", "tail", "shorten", "absolute"
          layout_config = {
            vertical = {
              width = 0.95,
              height = 0.95,
              preview_height = 0.55,
            },
            horizontal = {
              width = 0.95,
              height = 0.95,
              preview_width = 0.55,
            },
          },
        },
        pickers = {
          lsp_document_symbols = {
            show_line = false,
            symbol_width = 60,
          },
          lsp_workspace_symbols = {
            fname_width = 60,
            symbol_width = 50,
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "emoji")

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
    end
  },
  { "xiyaowong/telescope-emoji.nvim" },
}
