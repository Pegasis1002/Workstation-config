return {
    {
        "nvim-neorg/neorg",
        version = "*", 
        build = ":NeorgSyncParsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = { 
                        config = {
                            workspaces = {
                                brain = os.getenv("HOME") .. "/notes/neorg", 
                                project = vim.fn.getcwd(),
                            },
                            default_workspace = "brain",
                        },
                    },
                    ["core.esupports.metagen"] = { config = { type = "auto" } },
                },
            }
        end,
        keys = {
            { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Open Brain" },
        }
    },
    {
        "luckasRanarison/nvim-devdocs",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
        keys = {
            { "<leader>d", "<cmd>DevdocsOpen<cr>", desc = "Open Offline Docs" }
        }
    }
}
