return {
    {
        'folke/tokyonight.nvim',
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = true,
                on_colors = function(colors)
                    colors.bg = "#000000"
                    colors.bg_dark = "#000000"
                    colors.bg_float = "#000000"
                    -- Matrix Green Overrides
                    local matrix_green = "#20c20e"
                    local matrix_teal = "#44aacc"
                    colors.purple = matrix_green
                    colors.magenta = matrix_green
                    colors.red = "#cc5555"
                    colors.orange = "#e0af68"
                    colors.blue = matrix_teal
                    colors.cyan = matrix_teal
                    colors.green = matrix_green
                    colors.comment = "#608060"
                end,
                on_highlights = function(hl, c)
                    hl.LineNr = { fg = "#305030" }
                    hl.CursorLineNr = { fg = "#20c20e", bold = true }
                    hl.WinSeparator = { fg = "#305030" }
                    hl.TelescopeBorder = { fg = "#20c20e" }
                    hl.TelescopePromptBorder = { fg = "#20c20e" }
                    hl.TelescopeTitle = { fg = "#000000", bg = "#20c20e" }
                    hl.Directory = { fg = "#20c20e", bold = true }
                    hl.netrwDir = { fg = "#20c20e", bold = true }
                    hl.netrwClassify = { fg = "#20c20e" }
                    hl.netrwLink = { fg = "#608060" }
                    hl.netrwExe = { fg = "#cc5555" }
                    hl.Pmenu = { bg = "#101010", fg = "#c0dcc0" }
                    hl.PmenuSel = { bg = "#20c20e", fg = "#000000" }
                end
            })
            vim.cmd[[colorscheme tokyonight]]
        end
    }
}
