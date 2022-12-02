call plug#begin()

" GitHub Copilot
Plug 'github/copilot.vim'

" Color scheme interactive editor
" start by :LushRunQuickstart
Plug 'rktjmp/lush.nvim'

" The color scheme we actually use
Plug 'elumixor/nvim-colorscheme'

" Startify
Plug 'mhinz/vim-startify'

" NERDTree
Plug 'preservim/nerdtree'

" Git gutter in the NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'

" Git gutter in the code
Plug 'airblade/vim-gitgutter'

" Git commands made simple by Fugitive
Plug 'tpope/vim-fugitive'

" Icons
Plug 'ryanoasis/vim-devicons'

" Telescope
Plug 'nvim-lua/plenary.nvim' " This is required for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " To use fzf syntax in the telescope

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

" Switch to NERDTree on Alt+f
nnoremap <silent> <A-f> :NERDTree<CR>

" Close NERDTree if it's the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Use NERD Fonts for the Git Gutter
let g:NERDTreeGitStatusUseNerdFonts = 1

" Seach git files with Telescope on Ctrl+e
nnoremap <silent> <C-e> :Telescope git_files<CR>

"region Git Gutter

" Update Git Gutter more often
set updatetime=100

" Git Undo/Redo with Alt+u and Alr+r
nnoremap <silent> <A-u> :GitGutterUndo<CR>
nnoremap <silent> <A-r> :GitGutterRedo<CR>

" Git Gutter jump with Alt+j and Alt+k
nnoremap <silent> <A-j> :GitGutterNextHunk<CR>
nnoremap <silent> <A-k> :GitGutterPrevHunk<CR>

" Git Gutter stage with Alt+s
nnoremap <silent> <A-s> :GitGutterStageHunk<CR>

"endregion (Git Gutter)

" Alt+g to show Git summary window
nnoremap <silent> <A-g> :G<CR>


" Ctrl+hjkl to move between windows
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Close the file on Alt+q
nnoremap <silent> <A-q> :q<CR>

lua << EOF
-- Include our color scheme
-- require('meliora')

-- Setup telescope with extensions
require('telescope').setup()
require('telescope').load_extension('fzf')

EOF

colorscheme meliora
