return {
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
    
    config = function()
        local cmp = require('cmp')
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "gopls", "sqls", "lua_ls" },
            handlers = {
                function(server_name) 
                    require("lspconfig")[server_name].setup { capabilities = capabilities }
                end,
                ["gopls"] = function()
                    require("lspconfig").gopls.setup {
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                analyzers = { unusedparams = true },
                                staticcheck = true,
                            },
                        },
                    }
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } }
                            }
                        }
                    }
                end,
            }
        })

        cmp.setup({
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'buffer' },
          })
        })
    end
}
