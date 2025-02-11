vim.api.nvim_create_user_command(
  "SetTab",
  function(opts)
    local size        = tonumber(opts.args)
    vim.o.tabstop     = size
    vim.o.shiftwidth  = size
    vim.o.softtabstop = size
  end,
  { nargs = 1, desc = "a" }
)
