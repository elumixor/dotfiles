call plug#begin()

" Copilot
Plug 'github/copilot.vim'

" Color scheme interactive editor
" start by :LushRunQuickstart
Plug 'rktjmp/lush.nvim'

" The color scheme we actually use
Plug 'elumixor/nvim-colorscheme'

" Build system that is used to import our lua color theme
Plug 'rktjmp/shipwright.nvim'

call plug#end()

" Set relative line numbers
set number relativenumber

" This is needed for the True Color in neovim
set termguicolors

" Highlight the cursor line
set cursorline

" Enable display of whitespaces
set listchars=space:·
set list

lua << EOF
-- Include our color scheme
require('meliora')

EOF

colorscheme meliora

