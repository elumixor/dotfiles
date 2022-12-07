call plug#begin()

" GitHub Copilot
Plug 'github/copilot.vim'

" Color scheme interactive editor which we also need to load the colorscheme
" start by :LushRunQuickstart
Plug 'rktjmp/lush.nvim'

" The color scheme we actually use
Plug 'elumixor/nvim-colorscheme'

" Tmux-vim navigation
Plug 'christoomey/vim-tmux-navigator'

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

" Icons for NERDTree
Plug 'ryanoasis/vim-devicons'

" Telescope
Plug 'nvim-lua/plenary.nvim' " This is required for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " To use fzf syntax in the telescope

" Treesitter (for syntax highlighting and folding)
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Remap leader to space
nnoremap <SPACE> <Nop>
let mapleader = " "

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

" Set signcolumn to always so that the editor doesn't jump
" when the git gutter is added or else
set signcolumn=yes

" Set scrolloff to 2 so that the cursor is always 2 lines from the top/bottom
set scrolloff=2

" Do the same for the horizontal scroll
set sidescrolloff=10
set nowrap

" We'll remap Ctrl+u and Ctrl+d to just move the cursor up and down by 20 lines
nnoremap <C-u> 20k
nnoremap <C-d> 20j

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

" Include custom startify config
source ~/dotfiles/coc_settings.vim

" Move line up and down with Alt+Shift+j/k
nnoremap <silent> <A-S-j> :m .+1<CR>==
nnoremap <silent> <A-S-k> :m .-2<CR>==
" Move lines in visual mode
vnoremap <silent> <A-S-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-S-k> :m '<-2<CR>gv=gv

" Move block up and down with Alt+o/O
" nnoremap <silent> <A-o> :m '}-1<CR>==
" nnoremap <silent> <A-O> :m '{+1<CR>==

" Comment code on Ctrl+/ in both normal and visual mode
autocmd FileType c,cpp,java,scala let b:comment_leader = '//'
autocmd FileType sh,ruby,python   let b:comment_leader = '#'
autocmd FileType conf,fstab       let b:comment_leader = '#'
autocmd FileType tex              let b:comment_leader = '%'
autocmd FileType mail             let b:comment_leader = '>'
autocmd FileType vim              let b:comment_leader = '"'
function! CommentToggle()
    execute ':silent! s/\([^ ]\)/' . escape(b:comment_leader,'\/') . ' \1/'
    execute ':silent! s/^\( *\)' . escape(b:comment_leader,'\/') . ' \?' . escape(b:comment_leader,'\/') . ' \?/\1/'
endfunction
map <silent> <C-_> :call CommentToggle()<CR>
vmap <silent> <C-_> :call CommentToggle()<CR>

" Close the file on Alt+q
nnoremap <silent> <A-q> :q<CR>

" Folding using treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable " Disable folding by default

" Increase fold with Crtrl+ and decrease with Ctrl-
" nnoremap <silent> <C-_> zc
" nnoremap <silent> <C-+> zo

lua << EOF
-- Include our color scheme
-- require('meliora')

-- Setup telescope with extensions
require('telescope').setup()
require('telescope').load_extension('fzf')

-- Setup treesitter
require('nvim-treesitter.configs').setup {
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
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

vim.o.foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g') . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

EOF

colorscheme meliora
