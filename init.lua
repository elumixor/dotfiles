-- Setup treesitter
dofile(os.getenv("DOTFILES")..'/treesitter_config.lua')

-- Setup trouble
dofile(os.getenv("DOTFILES")..'/trouble_config.lua')

-- Setup git signs
dofile(os.getenv("DOTFILES")..'/gitsigns_config.lua')

-- Setup telescope
dofile(os.getenv("DOTFILES")..'/telescope_config.lua')

-- Setup registers
dofile(os.getenv("DOTFILES")..'/registers_config.lua')

-- Setup Scrollbar
require("scrollbar").setup({
    show = true,
    handlers = {
        cursor = false,
        diagnostic = true,
        gitsigns = false, -- Requires gitsigns
    },
    marks = {
        Error = {
            text = { "•", "•" },
        },
        Warn = {
            text = { "•", "•" },
        },
        Info ={
            text = { "•", "•" },
        },
        Hint = {
            text = { "•", "•" },
        },
    }
})

-- Setup the sticky header for the function / file
require('treesitter-context').setup()

-- Setup which-key
require('which-key').setup({
    triggers = { "<leader>" },
    triggers_blacklist = { 
        i = { "j", "k", "<C-r>" },
        v = { "j", "k", '"' },
    },
})

vim.o.timeout = true
vim.o.timeoutlen = 0

-- vim.o.foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g') . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

-- Setup our custom colorscheme
dofile(os.getenv("DOTFILES")..'/colorscheme.lua')
