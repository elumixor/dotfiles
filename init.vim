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
Plug 'lewis6991/gitsigns.nvim'

" Trouble - show errors inline
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" Git commands made simple by Fugitive
Plug 'tpope/vim-fugitive'

" Scrollbar
Plug 'petertriho/nvim-scrollbar'

" Lightline
Plug 'itchyny/lightline.vim'

" Vim Wiki
Plug 'vimwiki/vimwiki'

" Icons for NERDTree
Plug 'ryanoasis/vim-devicons'

" Telescope
Plug 'nvim-lua/plenary.nvim' " This is required for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " To use fzf syntax in the telescope

" Treesitter (for syntax highlighting and folding)
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Sticky header while srolling
Plug 'nvim-treesitter/nvim-treesitter-context'

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

" Insert is unnecesary because the lightline already shows the mode
set noshowmode

" Set signcolumn to always so that the editor doesn't jump
" when the git gutter is added or else
set signcolumn=yes

" Set scrolloff to 2 so that the cursor is always 2 lines from the top/bottom
set scrolloff=2

" Do the same for the horizontal scroll
set sidescrolloff=10
set nowrap

" Set textwidth to 120
set textwidth=120

" We'll remap Ctrl+u and Ctrl+d to just move the cursor up and down by 20 lines
nnoremap <C-u> 20k
nnoremap <C-d> 20j

" Include custom startify config
source ~/dotfiles/startify_config.vim

" Switch to NERDTree on Alt+f
nnoremap <silent> <A-f> :NERDTreeFind<CR>

" Close NERDTree if it's the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Use NERD Fonts for the Git Gutter
let g:NERDTreeGitStatusUseNerdFonts = 1

" Update Git Gutter more often
set updatetime=100

" Git Undo/Redo with Alt+u and Alr+r
nnoremap <silent> <A-u> :GitGutterUndo<CR>
nnoremap <silent> <A-r> :GitGutterRedo<CR>

" Git Gutter stage with Alt+s
nnoremap <silent> <A-s> :GitGutterStageHunk<CR>

" Alt+g to show Git summary window
nnoremap <silent> <A-g> :G<CR>

" Include custom coc settings
source ~/dotfiles/coc_settings.vim

" Include custom lightline config
source ~/dotfiles/lightline_config.vim

" Move line up and down with Alt+Shift+j/k
nnoremap <silent> <A-S-j> :m .+1<CR>==
nnoremap <silent> <A-S-k> :m .-2<CR>==

" Move lines in visual mode
vnoremap <silent> <A-S-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-S-k> :m '<-2<CR>gv=gv

" Clear search selection on Esc
nnoremap <silent> <CR> :noh<CR><CR>

" Comment code on Ctrl+/ in both normal and visual mode
autocmd FileType c,cpp,java,scala,javascript,typescript let b:comment_leader = '//'
autocmd FileType sh,ruby,python                         let b:comment_leader = '#'
autocmd FileType conf,fstab                             let b:comment_leader = '#'
autocmd FileType tex                                    let b:comment_leader = '%'
autocmd FileType mail                                   let b:comment_leader = '>'
autocmd FileType vim                                    let b:comment_leader = '"'
autocmd FileType lua                                    let b:comment_leader = '--'
function! CommentToggle()
    if exists("b:comment_leader")
        execute ':silent! s/\([^ ]\)/' . escape(b:comment_leader,'\/') . ' \1/'
        execute ':silent! s/^\( *\)' . escape(b:comment_leader,'\/') . ' \?' . escape(b:comment_leader,'\/') . ' \?/\1/'
    endif
endfunction
map <silent> <C-_> :call CommentToggle()<CR>
vmap <silent> <C-_> :call CommentToggle()<CR>

" Close the file on Alt+q
nnoremap <silent> <A-q> :q<CR>

" Folding using treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable " Disable folding by default

" Ignore some files in the NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

" Show hidden files
let NERDTreeShowHidden = 1

" Automatically save sessions
let g:startify_session_persistence = 1

" Enable Trouble on g + L
nmap <silent> gL <cmd>call coc#rpc#request('fillDiagnostics', [bufnr('%')])<CR><cmd>Trouble loclist<CR>`

" Use markdown in VimWiki
" Read the paths from the ~.vimwiki file
let g:vimwiki_list = []
" Check if the file exists
if filereadable(expand('~/.vimwiki'))
    " Read the file
    let lines = readfile(expand('~/.vimwiki'))
    " Iterate over the lines
    for line in lines
        " Split the line by the comma
        let split_line = split(line, ',')
        " Add the new wiki to the list
        call add(g:vimwiki_list, {'path': split_line[0], 'syntax': 'markdown', 'ext': '.md'})
    endfor
endif

" Don't treat all md files as VimWiki
let g:vimwiki_global_ext = 0

lua << EOF
-- Load config
dofile(os.getenv("DOTFILES")..'/init.lua')
EOF

colorscheme meliora
