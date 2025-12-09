local M = {}

-- == ROBUST PATH RESOLVER ==
local function get_project_docs_root()
    local cwd = vim.fn.getcwd()
    local separator = package.config:sub(1, 1)

    -- Strategy 1: Find project root marker (e.g., .git)
    local git_root_tbl = vim.fs.find('.git', { upward = true, path = cwd, stop = vim.loop.os_homedir(), type = 'directory' })
    if git_root_tbl and git_root_tbl[1] then
        return vim.fs.dirname(git_root_tbl[1]) .. separator .. 'docs'
    end

    -- Strategy 2: Find the 'docs' directory itself, searching upwards
    local parts = vim.split(cwd, separator)
    for i = #parts, 1, -1 do
        if parts[i] == 'docs' then
            return table.concat(parts, separator, 1, i)
        end
    end

    -- Strategy 3: If not currently inside a 'docs' tree, check for a 'docs' subdir
    local local_docs = cwd .. separator .. 'docs'
    if vim.fn.isdirectory(local_docs) == 1 then
        return local_docs
    end
    
    -- If no root is found, return nil
    return nil
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

function M.create_doc_entry()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local conf = require('telescope.config').values

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
                local docs_root = get_project_docs_root()
                if not docs_root then
                    vim.notify("Could not find docs root directory.", vim.log.levels.ERROR)
                    return
                end
                local target_dir = docs_root .. "/" .. type
                local current_date = os.date("%Y-%m-%d")
                
                -- Ensure directory exists
                os.execute("mkdir -p " .. target_dir)

                -- 2. Generate Filename
                local filename = ""
                local title_input = ""
                local author_name = "Your Name"

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

local function get_docs_subdirs()
    local docs_root = get_project_docs_root()
    if not docs_root or vim.fn.isdirectory(docs_root) == 0 then
        return {}
    end

    local subdirs = {}
    local files = vim.fn.readdir(docs_root)
    for _, file in ipairs(files) do
        if vim.fn.isdirectory(docs_root .. "/" .. file) == 1 then
            table.insert(subdirs, file)
        end
    end
    table.insert(subdirs, ".") -- for searching the root
    return subdirs
end

function M.search_docs()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local conf = require('telescope.config').values

    local docs_root = get_project_docs_root()
    if not docs_root then
        vim.notify("Could not find docs root directory.", vim.log.levels.ERROR)
        return
    end

    local subdirs = get_docs_subdirs()
    if #subdirs == 0 then
        vim.notify("No subdirectories found in docs.", vim.log.levels.WARN)
        return
    end

    pickers.new(require("telescope.themes").get_dropdown{}, {
        prompt_title = "Search in which documentation directory?",
        finder = finders.new_table {
            results = subdirs,
        },
        sorter = conf.generic_sorter(),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local search_dir = docs_root
                local prompt_title = "Search in docs/"
                if selection.value ~= "." then
                   search_dir = docs_root .. "/" .. selection.value
                   prompt_title = "Search in docs/" .. selection.value
                end

                require("telescope.builtin").find_files({
                    cwd = search_dir,
                    prompt_title = prompt_title,
                })
            end)
            return true
        end,
    }):find()
end

return M

