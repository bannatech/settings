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

set number
set shell=/bin/bash
set nocompatible               " be iMproved
filetype off                   " required!

call vundle#rc()

" My Bundles here:
"
" original repos on github
" Bundle 'tpope/vim-fugitive'
" Bundle 'Lokaltog/vim-easymotion'
" Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" Bundle 'tpope/vim-rails.git'
" vim-scripts repos
" Bundle 'L9'
" Bundle 'FuzzyFinder'
" non github repos
" Bundle 'git://git.wincent.com/command-t.git'
" ...

filetype plugin indent on     " required! 
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

function! LaTeXCompile()
	:!pdflatex --enable-write18 %
	:silent !rm %:r.aux %:r.log %:r.*.gnuplot %:r.*.table
endfunction

function! LaTeXDisplay()
	:silent !evince %:r.pdf
	:redraw!
endfunction

map F  :call LaTeXCompile()<CR>
map D :call LaTeXDisplay()<CR>
