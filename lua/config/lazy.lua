-- Bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- Theme
        {
            "rebelot/kanagawa.nvim",
            lazy = false,
            priority = 1000,
            config = function ()
                local configs = require("kanagawa")

                configs.setup({
                    compile = false,             -- enable compiling the colorscheme
                    undercurl = true,            -- enable undercurls
                    commentStyle = { italic = true },
                    functionStyle = {},
                    keywordStyle = { italic = true},
                    statementStyle = { bold = true },
                    typeStyle = {},
                    transparent = false,         -- do not set background color
                    dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
                    terminalColors = true,       -- define vim.g.terminal_color_{0,17}
                    colors = {                   -- add/modify theme and palette colors
                        palette = {},
                        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                    },
                    overrides = function(colors) -- add/modify highlights
                        return {}
                    end,
                    theme = "wave",              -- Load "wave" theme when 'background' option is not set
                    background = {               -- map the value of 'background' option to a theme
                        dark = "wave",           -- try "dragon" !
                        light = "lotus"
                    },
                })    
            end
        },

        -- Treesitter for better syntax highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            compilers = { "clang", "clang++", "gcc", "g++" },
            -- IMPORTANT : as of 02/10/2024 on windows many compilers errors can cause crash
            build = ":TSUpdate",
            config = function () 
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "c", "vim", "lua", "python"},
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = true },  
                })
            end
        },

        -- Lsp-zero for including lsp and autocompletion
        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v4.x',
            lazy = true,
            config = false,
        },
        {
            'williamboman/mason.nvim',
            lazy = false,
            config = true,
        },
        -- Autocompletion
        {
            'hrsh7th/nvim-cmp',
            event = 'InsertEnter',
            dependencies = {
                {'L3MON4D3/LuaSnip'},
            },
            config = function()
                local cmp = require('cmp')

                cmp.setup({
                    sources = {
                        {name = 'nvim_lsp'},
                    },
                    mapping = cmp.mapping.preset.insert({
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    }),
                    snippet = {
                        expand = function(args)
                            vim.snippet.expand(args.body)
                        end,
                    },
                })
            end
        },
        -- LSP
        {
            'neovim/nvim-lspconfig',
            cmd = {'LspInfo', 'LspInstall', 'LspStart'},
            event = {'BufReadPre', 'BufNewFile'},
            dependencies = {
                {'hrsh7th/cmp-nvim-lsp'},
                {'williamboman/mason.nvim'},
                {'williamboman/mason-lspconfig.nvim'},
            },
            config = function()
                local lsp_zero = require('lsp-zero')

                -- lsp_attach is where you enable features that only work
                -- if there is a language server active in the file
                local lsp_attach = function(client, bufnr)
                    local opts = {buffer = bufnr}

                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                end

                lsp_zero.extend_lspconfig({
                    sign_text = true,
                    lsp_attach = lsp_attach,
                    capabilities = require('cmp_nvim_lsp').default_capabilities()
                })

                require('mason-lspconfig').setup({
                    ensure_installed = {},
                    handlers = {
                        -- this first function is the "default handler"
                        -- it applies to every language server without a "custom handler"
                        function(server_name)
                            require('lspconfig')[server_name].setup({})
                        end,
                    }
                })
            end

        },
        -- import your plugins
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
