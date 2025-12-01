-- THE PRECISION CONFIG (FIXED)
-- Based on Primeagen's workflow

-- 1. GLOBALS & LEADER
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NETRW PRECISION CONFIG
vim.g.netrw_banner = 0          -- Kill the useless banner
vim.g.netrw_liststyle = 3       -- Tree View (Like NERDTree)
vim.g.netrw_browse_split = 0    -- Open files in current window (No weird splits)
vim.g.netrw_altv = 1            -- Split to the right (if you use vsplit)
vim.g.netrw_winsize = 25        -- Default width if you use Lexplore
vim.g.netrw_keepdir = 0         -- Sync browser with current directory
vim.g.netrw_localcopydircmd = 'cp -r'

-- 2. OPTIONS
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-- SYNC CLIPBOARD
vim.opt.clipboard = "unnamedplus"

-- 3. LAZY.NVIM BOOTSTRAP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 4. PLUGINS
require("lazy").setup({
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    },
    {
        'theprimeagen/harpoon',
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'folke/tokyonight.nvim',
    
    -- LSP (The Fix is here)
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/nvim-cmp'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'L3MON4D3/LuaSnip'},
})

-- 5. COLORSCHEME SETUP (Void Matrix Override)
require("tokyonight").setup({
    style = "night",
    transparent = true, -- Let Hyprland blur shine through
    
    -- THE PRECISION PALETTE OVERRIDE
    on_colors = function(colors)
        colors.bg = "#000000"       -- Pure Black
        colors.bg_dark = "#000000"
        colors.bg_float = "#000000"

        -- THE SHIFT: KILL PURPLE, MAKE IT GREEN
        local matrix_green = "#20c20e" -- Your Kitty Green
        local matrix_teal = "#44aacc"  -- Your Kitty Cyan/Blue
        
        colors.purple = matrix_green
        colors.magenta = matrix_green
        colors.red = "#cc5555"         -- Muted Red (Errors)
        colors.orange = "#e0af68"
        colors.blue = matrix_teal      -- Functions/Methods
        colors.cyan = matrix_teal
        colors.green = matrix_green    -- Strings
        
        -- Make comments slightly brighter/greener so they are legible
        colors.comment = "#608060"
    end,

-- FORCE UI ELEMENTS
    on_highlights = function(hl, c)
        -- Line numbers: Greenish Gray
        hl.LineNr = { fg = "#305030" }
        hl.CursorLineNr = { fg = "#20c20e", bold = true }
        
        -- Split borders: Dark Green
        hl.WinSeparator = { fg = "#305030" }
        
        -- Telescope: Green Borders
        hl.TelescopeBorder = { fg = "#20c20e" }
        hl.TelescopePromptBorder = { fg = "#20c20e" }
        hl.TelescopeTitle = { fg = "#000000", bg = "#20c20e" } 
        
        -- NETRW / DIRECTORIES
        -- This forces folders to be your Matrix Green
        hl.Directory = { fg = "#20c20e", bold = true }
        hl.netrwDir = { fg = "#20c20e", bold = true }
        hl.netrwClassify = { fg = "#20c20e" }     -- The trailing slash
        hl.netrwLink = { fg = "#608060" }         -- Symlinks
        hl.netrwExe = { fg = "#cc5555" }          -- Executables (Red)

        -- Completion Menu
        hl.Pmenu = { bg = "#101010", fg = "#c0dcc0" }
        hl.PmenuSel = { bg = "#20c20e", fg = "#000000" } 
    end
})

vim.cmd[[colorscheme tokyonight]]

-- 6. KEYMAPS
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- 7. LSP CONFIG (The Robust Handler Method)
local cmp = require('cmp')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason").setup()
require("mason-lspconfig").setup({
    -- Replaced 'sqlls' with 'sqls' (Go based, better for you)
    ensure_installed = { "gopls", "sqls", "lua_ls" },
    handlers = {
        -- The Default Handler: "Just make it work" for any server installed
        function(server_name) 
            require("lspconfig")[server_name].setup {
                capabilities = capabilities
            }
        end,

        -- Specific Overrides for Go
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

        -- Specific Overrides for Lua (Fixes the "Undefined global vim" warning)
        ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
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
