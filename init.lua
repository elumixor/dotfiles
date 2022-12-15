-- Setup telescope with extensions
require('telescope').setup()
require('telescope').load_extension('fzf')

-- Setup treesitter
dofile(os.getenv("DOTFILES")..'/treesitter_config.lua')

-- Setup trouble
dofile(os.getenv("DOTFILES")..'/trouble_config.lua')

-- Setup git signs
dofile(os.getenv("DOTFILES")..'/gitsigns_config.lua')

-- Setup Scrollbar
require("scrollbar").setup({
    handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        handle = true,
    },
})

-- Setup treesitter
require('treesitter-context').setup()

vim.o.foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g') . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
