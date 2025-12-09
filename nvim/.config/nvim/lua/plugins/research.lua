-- Define these outside the plugin definition so they can be accessed by the keys
local neorg_workspaces = {
    brain = os.getenv("HOME") .. "/notes/neorg", 
    project = vim.fn.getcwd(),
}

local function search_headings_scoped()
    local workspace_names = {}
    for name, _ in pairs(neorg_workspaces) do
        table.insert(workspace_names, name)
    end

    require('telescope.pickers').new({}, {
        prompt_title = "Select Neorg Workspace",
        finder = require('telescope.finders').new_table {
            results = workspace_names,
        },
        sorter = require('telescope.config').values.generic_sorter(),
        attach_mappings = function(prompt_bufnr, map)
            require('telescope.actions').select_default:replace(function()
                local selection = require('telescope.actions.state').get_selected_entry()
                require('telescope.actions').close(prompt_bufnr)
                local workspace_path = neorg_workspaces[selection.value]

                require('telescope.builtin').live_grep({
                    prompt_title = "Search Headings in " .. selection.value,
                    search_dirs = { workspace_path },
                    default_text = "^\\*+\\s",
                })
            end)
            return true
        end,
    }):find()
end

return {
    -- The Second Brain (Neorg)
    {
        "nvim-neorg/neorg",
        version = "*", 
        build = ":NeorgSyncParsers",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = { 
                        config = {
                            workspaces = neorg_workspaces,
                            default_workspace = "brain",
                        },
                    },
                    ["core.esupports.metagen"] = { config = { type = "auto" } },
                    ["core.integrations.telescope"] = {},
                },
            }
        end,
        keys = {
            { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Open Brain" },
            { "<leader>nsh", search_headings_scoped, desc = "Search Neorg Headings (Scoped)" },
        }
    },
    -- The Offline Library (DevDocs)
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
