--print("me.lua ...")

vim.o.background = false

vim.opt.number = true
vim.opt.relativenumber = true

-- Golang handles

vim.api.nvim_create_user_command(
    'GoFormat',
    function(opts)
        vim.cmd('!go fmt .')
    end,
    { nargs = 0 }
)

vim.api.nvim_create_user_command(
    'GoRun',
    function(opts)
        vim.cmd('!go run main.go')
    end,
    { nargs = 0 }
)

-- JSON handles

vim.api.nvim_create_user_command(
    'JsonFormat',
    function(opts)
        vim.cmd(':%!python -m json.tool')
    end,
    { nargs = 0 }
)
