call plug#begin()

" Copilot
Plug 'github/copilot.vim'

" Color scheme interactive editor
" start by :LushRunQuickstart
Plug 'rktjmp/lush.nvim'

" The color scheme we actually use
Plug 'elumixor/nvim-colorscheme'

" Startify
Plug 'mhinz/vim-startify'

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

" Transform tabs to spaces with 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Include custom startify config
source ~/.config/nvim/startify_config.vim

lua << EOF
-- Include our color scheme
require('meliora')

EOF

colorscheme meliora

