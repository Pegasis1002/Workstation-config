return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "plenary.nvim" },
    config = function()
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')
        local conf = require('telescope.config').values

        -- == CONFIGURATION ==
        local author_name = "Your Name" 

        -- == INTELLIGENT PATH RESOLVER ==
        local function get_docs_path(doc_type)
            local cwd = vim.fn.getcwd()
            
            -- STRATEGY 1: Look for .git upward (The most reliable method)
            local dot_git_path = vim.fs.find(".git", {
                upward = true,
                stop = vim.loop.os_homedir(),
                path = cwd
            })[1]
            
            local docs_root = ""
            
            if dot_git_path then
                -- Found git in parent! Root is the folder containing .git
                local project_root = vim.fs.dirname(dot_git_path)
                docs_root = project_root .. "/docs"
            else
                -- STRATEGY 2: No git found. Guess based on current folder name.
                -- Check if we are ALREADY in a 'docs' folder to avoid 'docs/docs'
                if cwd:match("/docs$") or cwd:match("/docs/") then
                    -- We are inside docs, so we need to find where 'docs' starts
                    -- Simple hack: just look for the docs folder in the path string
                    local pattern = "(.*" .. "/docs)"
                    local match = cwd:match(pattern)
                    if match then
                        docs_root = match
                    else
                        docs_root = cwd -- Fallback
                    end
                else
                    -- We are likely at project root (no docs in path)
                    docs_root = cwd .. "/docs"
                end
            end
            
            return docs_root .. "/" .. doc_type
        end

        -- == RICH TEMPLATES ==
        local templates = {
            journal = [[
@document.meta
title: Journal Entry {{DATE}}
description: Daily development log
authors: {{AUTHOR}}
categories: [journal]
created: {{DATE}}
updated: {{DATE}}
version: 1.0.0
@end

* Daily Log: {{DATE}}

** Goals for Today
   - ( ) 

** Notes & Thoughts
   - 

** End of Day Review
   - What did I learn?
   - What is blocking me?
]],
            adr = [[
@document.meta
title: {{TITLE}}
description: Architectural Decision Record
authors: {{AUTHOR}}
categories: [adr, architecture]
created: {{DATE}}
status: draft
version: 1.0.0
@end

* ADR: {{TITLE}}

** Context
   - What is the issue that we're seeing?
   - What are the constraints?

** Decision
   - We will use...

** Consequences
   - Positive: ...
   - Negative: ...

** Considered Options
   - Option 1
   - Option 2
]],
            specs = [[
@document.meta
title: {{TITLE}}
description: Technical Specification
authors: {{AUTHOR}}
categories: [spec, technical]
created: {{DATE}}
version: 0.1.0
@end

* Spec: {{TITLE}}

** Overview
   - High level summary...

** Architecture
   - Components involved...

** Data Model
   - Schema changes...

** API Interface
   - Endpoints...
]]
        }

        -- == CUSTOM DOC CREATOR FUNCTION ==
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
                        
                        -- 1. Calculate the exact target directory
                        local target_dir = get_docs_path(type)
                        local current_date = os.date("%Y-%m-%d")
                        
                        -- Ensure directory exists
                        os.execute("mkdir -p " .. target_dir)

                        -- 2. Generate Filename
                        local filename = ""
                        local title_input = ""

                        if type == "journal" then
                            filename = target_dir .. "/" .. current_date .. ".norg"
                            title_input = "Journal " .. current_date
                        else
                            local input = vim.fn.input(type:upper() .. " Title: ")
                            if input == "" then return end
                            title_input = input
                            local safe_name = input:gsub("%s+", "-"):gsub("[^%w%-]", ""):lower()
                            filename = target_dir .. "/" .. safe_name .. ".norg"
                        end

                        -- 3. Open File
                        vim.cmd("edit " .. filename)
                        
                        -- 4. Insert Template (If file is empty)
                        if vim.fn.getfsize(filename) <= 0 then
                            local content = templates[type]
                            if content then
                                content = content:gsub("{{DATE}}", current_date)
                                content = content:gsub("{{AUTHOR}}", author_name)
                                content = content:gsub("{{TITLE}}", title_input)
                                
                                local lines = {}
                                for line in content:gmatch("([^\n]*)\n?") do
                                    table.insert(lines, line)
                                end
                                vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
                            end
                        end
                    end)
                    return true
                end,
            }):find()
        end

        vim.keymap.set("n", "<leader>nd", create_doc_entry, { desc = "Create New Doc" })
    end
}
