local ensure_installed = {
  "bash",
  "c",
  "html",
  "java",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "query",
  "sql",
  "terraform",
  "vim",
  "vimdoc",
  "yaml",
}

return {{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = ensure_installed,
      auto_install = false,
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return true end
        end,
        additional_vim_regex_highlighting = false,
      },
      -- note that currently indentation is an experimental feature
      indent = {
        enable = true,
        disable = { "markdown" }, -- leave markdown indentation to builtin vim and LS
      },
    }
  end
}}
