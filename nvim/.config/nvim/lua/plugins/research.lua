-- Define these outside the plugin definition so they can be accessed by the keys
local neorg_workspaces = {
    brain = os.getenv("HOME") .. "/notes/neorg",
    project = vim.fn.getcwd(),
}

local function get_relative_path(from_path, to_path)
    -- Ensure paths are absolute for consistent splitting
    local abs_from = vim.fn.fnamemodify(from_path, ":p")
    local abs_to = vim.fn.fnamemodify(to_path, ":p")

    -- Split paths into components
    local from_parts = {}
    for part in abs_from:gmatch("([^/]+)") do
        table.insert(from_parts, part)
    end

    local to_parts = {}
    for part in abs_to:gmatch("([^/]+)") do
        table.insert(to_parts, part)
    end

    -- Find the length of the common prefix
    local common_len = 0
    while common_len < #from_parts
        and common_len < #to_parts
        and from_parts[common_len + 1] == to_parts[common_len + 1]
    do
        common_len = common_len + 1
    end

    local relative_parts = {}

    -- Add '..' for each directory to go up from 'from_path'
    for _ = 1, #from_parts - common_len do
        table.insert(relative_parts, "..")
    end

    -- Add the remaining parts of 'to_path'
    for i = common_len + 1, #to_parts do
        table.insert(relative_parts, to_parts[i])
    end

    local result_path = table.concat(relative_parts, "/")

    -- For files in subdirectories, prepend './' for clarity.
    if #relative_parts > 0 and relative_parts[1] ~= ".." then
        return "./" .. result_path
    elseif result_path == "" then
        -- This can happen if from_path is the directory containing to_path.
        -- In that case, the path is just the filename. Prepend './'.
        return "./" .. vim.fn.fnamemodify(to_path, ":t")
    end

    return result_path
end

local function insert_link()
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    require("telescope.builtin").find_files({
        prompt_title = "Find File to Link",
        cwd = git_root,
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function(bufnr)
                local entry = require("telescope.actions.state").get_selected_entry()
                local current_buf_path = vim.api.nvim_buf_get_name(0)
                local current_buf_dir = vim.fn.fnamemodify(current_buf_path, ':h')
                local rel_path = get_relative_path(current_buf_dir, entry.path)
                local link = "{:" .. rel_path .. ":}[link]"
                require("telescope.actions").close(bufnr)
                vim.api.nvim_put({ link }, "c", false, true)
            end)
            return true
        end,
    })
end

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

                if selection.value == "project" then
                    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
                    if git_root then
                        workspace_path = git_root
                    end
                end

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
            { "<leader>nl", insert_link, desc = "Insert Link" },
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
