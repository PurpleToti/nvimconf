--print("remap.lua ...")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.api.nvim_set_keymap('n', '<leader>pv', '<Cmd>Ex<CR>', { noremap = false, silent = true })
