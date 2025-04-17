vim.api.nvim_create_user_command(
  "Tab",
  function(opts)
    local size        = tonumber(opts.args)
    vim.o.tabstop     = size
    vim.o.shiftwidth  = size
    vim.o.softtabstop = size
  end,
  { nargs = 1, desc = "a" }
)

vim.api.nvim_create_user_command(
  "Width",
  function(opts)
    vim.o.colorcolumn = opts.args
    vim.o.textwidth   = tonumber(opts.args)
  end,
  { nargs = 1, desc = "a" }
)

