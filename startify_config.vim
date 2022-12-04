" Custom sessions directory
let g:session_directory = '~/.config/startify_sessions'

" Show modified and untracked files
" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" What should be displayed in the menu
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions'] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
      \ { 'type': 'files',     'header': ['   Recent Files'] },
      \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
      \ { 'type': function('s:gitModified'),  'header': ['   Git Modified']},
      \ { 'type': function('s:gitUntracked'), 'header': ['   Git Untracked']},
      \ ]

" Custom bookmarks
let g:startify_bookmarks = [
      \ { 'v': '~/.config/nvim/init.vim' },
      \ { 'z': '~/.zshrc' },
      \ { 'd': '~/dotfiles' },
      \ ]

" Change to VCS (git) directory
let g:startify_change_to_vcs_root = 1

" Use unicode icons
let g:startify_fortune_use_unicode = 1

" Automatically update sessions
let g:startify_session_persistence = 1

" Custom ASCII header
let g:startify_custom_header = []
