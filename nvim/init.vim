set number relativenumber
highlight OverLength ctermbg=Red ctermfg=White
match OverLength /\%81v.\+/

highlight Comment ctermbg=Black ctermfg=Green
highlight Constant ctermbg=Black ctermfg=Yellow
highlight Normal ctermbg=Black
highlight NonText ctermbg=Black ctermfg=Red
highlight Special ctermbg=Black ctermfg=Gray
highlight Cursor ctermbg=Magenta ctermfg=White
highlight Search ctermbg=Yellow ctermfg=White

syntax enable
map <F8> :tabn
map <F9> :!clear
set nowrap


set autoindent
set tabstop=4
set shiftwidth=4

set listchars=tab:>.
set list

set shell=/usr/bin/zsh
set nocompatible               " be iMproved

packadd minpac

call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('itchyny/lightline.vim')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-surround')

packloadall

function! LaTeXCompile()
	:!pdflatex --enable-write18 %
	:silent !rm %:r.aux %:r.log %:r.*.gnuplot %:r.*.table
endfunction

function! LaTeXDisplay()
	:silent !xdg-open %:r.pdf
	:redraw!
endfunction

map <C-f>  :call LaTeXCompile()<CR>
map D :call LaTeXDisplay()<CR>

map <F2> :call minpac#update()<CR>

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

