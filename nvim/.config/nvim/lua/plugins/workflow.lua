return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values

        -- == CUSTOM DOC CREATOR ==
        local function create_doc_entry()
            local opts = require("telescope.themes").get_dropdown{}
            
            pickers.new(opts, {
                prompt_title = "Create New Documentation",
                finder = finders.new_table {
                    results = { 
                        { "Journal Entry", "journal" },
                        { "Architecture Decision Record (ADR)", "adr" },
                        { "Technical Spec", "specs" }
                    },
                    entry_maker = function(entry)
                        return {
                            value = entry,
                            display = entry[1],
                            ordinal = entry[1],
                            type = entry[2] 
                        }
                    end
                },
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        local type = selection.type
                        
                        -- Define path relative to current working directory
                        local subdir = "docs/" .. type
                        os.execute("mkdir -p " .. subdir)

                        local filename = ""
                        if type == "journal" then
                            filename = subdir .. "/" .. os.date("%Y-%m-%d") .. ".norg"
                        else
                            local input = vim.fn.input(type .. " Name: ")
                            if input == "" then return end
                            input = input:gsub("%s+", "-"):lower()
                            filename = subdir .. "/" .. input .. ".norg"
                        end

                        vim.cmd("edit " .. filename)
                        
                        -- Add template content
                        if type == "adr" then
                            vim.api.nvim_put({ "* Title", "", "** Status", "Proposed", "", "** Context", "" }, "l", true, true)
                        elseif type == "journal" then
                            vim.api.nvim_put({ "* Daily Log: " .. os.date("%Y-%m-%d"), "" }, "l", true, true)
                        end
                    end)
                    return true
                end,
            }):find()
        end

        vim.keymap.set("n", "<leader>nd", create_doc_entry, { desc = "Create New Doc" })
    end
}
