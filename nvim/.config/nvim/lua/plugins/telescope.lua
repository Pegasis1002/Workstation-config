return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    {
      "<leader>ff",
      function()
        -- Find files inside the project git repository
        local builtin = require("telescope.builtin")
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if git_root then
          builtin.find_files({ cwd = git_root })
        else
          builtin.find_files()
        end
      end,
      desc = "Find project files",
    },
    {
      "<leader>ns",
      function()
        -- Find .norg files inside the project git repository
        local builtin = require("telescope.builtin")
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if git_root then
          builtin.find_files({ cwd = git_root, file_patterns = { "*.norg" } })
        else
          builtin.find_files({ file_patterns = { "*.norg" } })
        end
      end,
      desc = "Search project .norg files",
    },
    {
      "<leader>fg",
      function()
        -- Grep inside the project git repository
        local builtin = require("telescope.builtin")
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if git_root then
          builtin.live_grep({ cwd = git_root })
        else
          builtin.live_grep()
        end
      end,
      desc = "Live grep in project",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help tags",
    },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true, -- false will disable fuzzy finding
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      },
    })
    telescope.load_extension("fzf")
  end,
}