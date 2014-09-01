set tabstop=4

set shiftwidth=4

set smarttab

set showcmd

set ruler

set autoindent

map <M-Space> <Esc>

" Whitespace stuff
"set listchars=tab:»\ ,trail:·
"set list

" Switch to alternate file
map <M-f> :bnext<cr>
map <M-b> :bprevious<cr>
map <C-d> <Ins>

" Default mapping
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_key='<C-l>'
let g:multi_cursor_next_key='<C-l>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
