-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false

-- 8-wide hard tabs
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.expandtab = false

-- auto-session restores buffer-local options too
vim.opt.sessionoptions:append("localoptions")
