-- Setup git signs
dofile(os.getenv("DOTFILES")..'/gitsigns_config.lua')

-- Setup telescope with extensions
require('telescope').setup()
require('telescope').load_extension('fzf')

-- Setup treesitter
dofile(os.getenv("DOTFILES")..'/treesitter_config.lua')

vim.o.foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g') . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
