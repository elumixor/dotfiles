" Switch to NERDTree on <Ctrl+f>
nnoremap <silent> <leader>f :NERDTreeFind<CR>

" Close NERDTree if it's the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Auto open NERDTree on startup, but only if a file is provided
" Then also focus on the file automatically
" Otherwise if it's a directory, open telescope
autocmd VimEnter * if argc() == 1 && isdirectory(expand("%:p")) | NERDTree | wincmd p | endif

" Use NERD Fonts for the Git Gutter
let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 0
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeDirArrows = 0

" Show hidden files
let g:NERDTreeShowHidden = 1

let g:NERDTreeIgnore = ['\.pyc$', '__pycache__']

" NERDTrees File highlighting
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
