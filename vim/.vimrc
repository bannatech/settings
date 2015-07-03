set tabstop=4

set shiftwidth=4

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
map <M-x> :bnext<cr>
map <M-c> :bprevious<cr>

" tabs
map <C-x> :tabp<cr>
map <C-c> :tabn<cr>
map <C-t> :tabnew<cr>

" Toggle NERDTree
map <C-v> :NERDTreeToggle<CR>

" YAY COLOR
syntax on
hi SpecialKey ctermfg=black  cterm=bold
hi Statement  ctermfg=yellow cterm=bold
hi Special    ctermfg=yellow cterm=none
hi PreProc                   cterm=none
hi Type                      cterm=bold
hi MatchParen cterm=bold ctermbg=none ctermfg=white
hi LineNr     ctermfg=black  cterm=bold ctermbg=black
hi TabLineFill ctermfg=black ctermbg=black
hi TabLine ctermfg=grey ctermbg=black cterm=none
hi TabLineSel ctermfg=white ctermbg=black
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/
