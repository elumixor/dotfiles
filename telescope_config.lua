local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Search git files with Telescope on Ctrl+e
-- vim.keymap.set('n', '<C-e>', builtin.git_files)
vim.keymap.set('n', '<leader>e', builtin.find_files)

-- Search string in files with <leader>f
vim.keymap.set('n', '<leader>f', builtin.live_grep)

-- Search buffers on Ctrl+b
vim.keymap.set('n', '<C-b>', builtin.buffers)

-- Add a picker for symbols using command :Telescope coc
vim.keymap.set('n', '<leader>s', "<cmd>Telescope coc workspace_symbols<cr>")

-- Add a picker for errors in the project using command :Telescope coc
vim.keymap.set('n', '<leader>l', "<cmd>Telescope coc workspace_diagnostics<cr>")

-- Telescope on <leader><leader>
vim.keymap.set('n', '<leader><leader>', "<Cmd>Telescope<CR>")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
                -- Open file with Ctrl+o
                ["<C-o>"] = require('telescope.actions').select_default + require('telescope.actions').center,
                -- Close Telescope with Ctrl+q
                ["<C-q>"] = require('telescope.actions').close,
                -- Close with Esc
                ["<Esc>"] = require('telescope.actions').close,
            },
            n = { ["q"] = require("telescope.actions").close },
        },
        pickers = {
            buffers = {
                ignore_current_buffer = true,
                sort_lastused = true,
            },
        },
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        -- file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules", "locale" },
        -- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    },
    extensions = {
        coc = {
            theme = 'ivy',
            prefere_locations = true
        },
    },
})

telescope.load_extension('coc')
telescope.load_extension('fzf')
