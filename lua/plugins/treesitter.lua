local ensure_installed = {
  "bash",
  "c",
  "cmake",
  "css",
  "diff",
  "go",
  "html",
  "javascript",
  "java",
  "json",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "scala",
  "sql",
  "terraform",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

-- Custom mapping for certain filetypes to installed parsers
local custom_parser_mappings = {
  json = { "jsonc" },
  kotlin = {
    "simkit-data-type",
    "simkit-method",
    "simkit-workflow-type",
  },
}

local function is_markdown(lang) return lang == "markdown" end

local function has_indent_query(lang)
  return vim.treesitter.query.get(lang, "indents") ~= nil
end

return {{
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(ensure_installed)

    -- Map certain filetypes to installed parsers:
    for parser, filetypes in pairs(custom_parser_mappings) do
      vim.treesitter.language.register(parser, filetypes)
    end

    -- Use a named group to avoid duplicate callbacks when reloading the config.
    local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

    for _, lang in ipairs(ensure_installed) do
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = vim.treesitter.language.get_filetypes(lang),
        callback = function()
          vim.treesitter.start()
          -- Indent with treesitter when language supports, except markdown:
          if has_indent_query(lang) and not is_markdown(lang) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end
  end
}}
