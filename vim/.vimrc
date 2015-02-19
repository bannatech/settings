set tabstop=8

set shiftwidth=8

set smarttab

set showcmd

set ruler

set autoindent

set number

map <M-Space> <Esc>

" Whitespace stuff
set listchars=tab:»\ ,trail:·
set list

" Switch to alternate file
map <C-x> :bnext<cr>
map <C-c> :bprevious<cr>
map <C-d> <Ins>

" Default mapping
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_key='<C-l>'
let g:multi_cursor_next_key='<C-l>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" YAY COLOR
syntax on
hi SpecialKey ctermfg=black  cterm=bold
hi Statement  ctermfg=yellow cterm=bold
hi Special    ctermfg=yellow cterm=none
hi PreProc                   cterm=none
hi Type                      cterm=bold
hi MatchParen cterm=bold ctermbg=none ctermfg=white
hi LineNr     ctermfg=black  cterm=bold ctermbg=black
