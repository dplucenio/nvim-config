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


vim.api.nvim_create_user_command(
  "MarkdownHere",
  function()
    vim.bo.filetype = "markdown"
  end,
  { nargs = 0, desc = "Set filetype to markdown for current buffer" }
)

local function lsp_server_names()
  local seen = {}
  local names = {}

  for name, _ in pairs(vim.lsp.config._configs or {}) do
    if name ~= "*" then
      seen[name] = true
    end
  end

  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name and client.name ~= "" then
      seen[client.name] = true
    end
  end

  for name, _ in pairs(seen) do
    table.insert(names, name)
  end

  table.sort(names)
  return names
end

local function lsp_name_complete(arglead)
  local matches = {}
  local pattern = "^" .. vim.pesc(arglead or "")

  for _, name in ipairs(lsp_server_names()) do
    if name:match(pattern) then
      table.insert(matches, name)
    end
  end

  return matches
end

vim.api.nvim_create_user_command(
  "LspEnable",
  function(opts)
    vim.lsp.enable(opts.args, true)
    vim.notify("Enabled LSP: " .. opts.args)
  end,
  {
    nargs = 1,
    complete = function(arglead)
      return lsp_name_complete(arglead)
    end,
    desc = "Enable an LSP server for this session",
  }
)

vim.api.nvim_create_user_command(
  "LspDisable",
  function(opts)
    vim.lsp.enable(opts.args, false)

    local stopped = 0
    for _, client in ipairs(vim.lsp.get_clients({ name = opts.args })) do
      client:stop(true)
      stopped = stopped + 1
    end

    vim.notify(string.format("Disabled LSP: %s (stopped %d client(s))", opts.args, stopped))
  end,
  {
    nargs = 1,
    complete = function(arglead)
      return lsp_name_complete(arglead)
    end,
    desc = "Disable an LSP server for this session and stop active clients",
  }
)
