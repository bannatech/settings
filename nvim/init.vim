set number relativenumber
set hidden

highlight OverLength ctermbg=Red ctermfg=White
match OverLength /\%81v.\+/

let mapleader="="

highlight Comment ctermbg=Black ctermfg=Green
highlight Constant ctermbg=Black ctermfg=Yellow
highlight Normal ctermbg=Black
highlight NonText ctermbg=Black ctermfg=Red
highlight Special ctermbg=Black ctermfg=Gray
highlight Cursor ctermbg=Magenta ctermfg=White
highlight Search ctermbg=Yellow ctermfg=White

syntax enable
noremap <F8> :tabn
noremap <F9> :!clear
set nowrap


set autoindent
set tabstop=2
set shiftwidth=2
set expandtab

set listchars=space:.,precedes:«,extends:»,tab:>.
set list
highlight NonIndent ctermfg=black guifg=black ctermbg=black guifg=black
2match NonIndent / /
highlight Indentation ctermfg=cyan guifg=cyan
match Indentation /^ \+/
highlight ExtraSpace ctermbg=cyan guibg=cyan
3match ExtraSpace /\s\+$\| \+\ze\t/

set shell=/usr/bin/zsh
set nocompatible               " be iMproved

packadd minpac

call minpac#init()

call minpac#add('itchyny/lightline.vim')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-surround')
call minpac#add('jacquesbh/vim-showmarks')
call minpac#add('neitanod/vim-clevertab')
call minpac#add('vim-scripts/SearchComplete')
call minpac#add('lyuts/vim-rtags')
call minpac#add('roxma/python-support.nvim')
call minpac#add('scrooloose/nerdtree')
call minpac#add('editorconfig/editorconfig-vim')
call minpac#add('w0rp/ale')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-speeddating')
call minpac#add('tpope/vim-fugitive')
call minpac#add('ervandew/supertab')

packloadall

function! LaTeXCompile()
    :!pdflatex --enable-write18 %
    :silent !rm %:r.aux %:r.log %:r.*.gnuplot %:r.*.table
endfunction

function! LaTeXDisplay()
    :silent !xdg-open %:r.pdf
    :redraw!
endfunction

noremap <C-f>  :call LaTeXCompile()<CR>
noremap D :call LaTeXDisplay()<CR>

noremap <F2> :call minpac#update()<CR>

noremap <Leader>; :DoShowMarks!<CR>
noremap <Leader>, :NoShowMarks!<CR>

noremap ; :Files<CR>

noremap <C-t> :NERDTreeToggle<CR>

noremap <F3> :set hlsearch!<CR>
inoremap <F3> <ESC>:set hlsearch!<CR>a

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

let g:gitgutter_terminal_reports_focus=0

let g:lightline = {
\   'active': {
\    'left': [[ 'mode', 'paste'], ['readonly', 'filename', 'modified', 'git']]
\   },
\   'component_function': {
\    'git': 'fugitive#head'
\   }
\ }
