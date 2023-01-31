require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    -- textobjects = {
        -- select = {
            -- enable = true,
            -- lookahead = true,
            -- keymaps = {
                -- ["af"] = "@function.outer",
                -- ["if"] = "@function.inner",
                -- ["ac"] = "@class.outer",
                -- ["ic"] = "@class.inner",
            -- },
        -- },
        -- move = {
            -- enable = true,
            -- set_jumps = true,
            -- goto_next_start = {
                -- ["]f"] = "@function.outer",
                -- ["]c"] = "@class.outer",
            -- },
            -- goto_previous_start = {
                -- ["[f"] = "@function.outer",
                -- ["[c"] = "@class.outer",
            -- },
        -- },
    -- },
})
