local set = vim.o

--- Base options
set.clipboard      = "unnamed,unnamedplus"     -- Clipboard config
set.listchars      = "tab:>-,trail:·,space:·"  -- Toggle invisible chars config
set.tabstop        = 2                         -- Number of columns occupied by a tab character
set.shiftwidth     = 2                         -- Width for autoindents
set.softtabstop    = 2                         -- See multiple spaces as tabstops so <BS> does the right thing
set.expandtab      = true                      -- Convert tabs to white space
set.termguicolors  = true                      -- Enable termguicolors
set.signcolumn     = "yes"                     -- Reserve a space in the gutter
set.splitbelow     = true                      -- Set split window to be created below
set.splitright     = true                      -- Set split window to be created right

--- Leader key setup
vim.g.mapleader      = " "                       -- Set global leader key
vim.g.maplocalleader = "\\"                      -- Set local leader key

--- Base mappings
vim.keymap.set("n", "<M-j>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<M-k>", "<cmd>cprevious<cr>")
vim.keymap.set("n", "<M-0>", "<cmd>tabonly<cr>")
vim.keymap.set("n", "<M-1>", "<cmd>tabprevious<cr>")
vim.keymap.set("n", "<M-2>", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")
vim.keymap.set("n", "<leader>li", "<cmd>set list!<cr>")
vim.keymap.set("n", "<leader>h", "<cmd>set hlsearch!<cr>")
