--- Base options
vim.o.clipboard      = "unnamed,unnamedplus"     -- Clipboard config
vim.o.listchars      = "tab:>-,trail:·,space:·"  -- Toggle invisible chars config
vim.o.tabstop        = 4                         -- Number of columns occupied by a tab character
vim.o.shiftwidth     = 4                         -- Width for autoindents
vim.o.softtabstop    = 4                         -- See multiple spaces as tabstops so <BS> does the right thing
vim.o.expandtab      = true                      -- Convert tabs to white space
vim.o.termguicolors  = true                      -- Enable termguicolors
vim.opt.signcolumn   = "yes"                     -- Reserve a space in the gutter

--- Leader key setup
vim.g.mapleader      = " "                       -- Set global leader key
vim.g.maplocalleader = "\\"                      -- Set local leader key

--- Base mappings
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>0", ":tabonly<CR>")
vim.keymap.set("n", "<leader>1", ":tabprevious<CR>")
vim.keymap.set("n", "<leader>2", ":tabnext<CR>")
vim.keymap.set("n", "<leader>li", ":set list!<CR>")
vim.keymap.set("n", "<leader>h", ":set hlsearch!<CR>")
