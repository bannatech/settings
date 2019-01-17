set number relativenumber " Relative Line Numbers
set hidden "Let vim act like every other editor

" Highlight when a line exceeds 80 columns
highlight OverLength ctermbg=Red ctermfg=White
" match OverLength /\%81v.\+/ " Old Method
au BufWinEnter * let w:ol = matchadd('OverLength', '\%81v.\+', -1)

" To expand the number of binds nvim can do
let mapleader='='

" Syntax colors
highlight Comment ctermbg=Black ctermfg=Green
highlight Constant ctermbg=Black ctermfg=Yellow
highlight Normal ctermbg=Black
highlight NonText ctermbg=Black ctermfg=Red
highlight Special ctermbg=Black ctermfg=Gray
highlight Cursor ctermbg=Magenta ctermfg=White
highlight Search ctermbg=Yellow ctermfg=White

" Enable syntax coloring
syntax enable
" No dumb wrapping
set nowrap

" Splits
set splitbelow splitright
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Use 2 spaces for indentation
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab

" Delete trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" Automerge .Xresources
autocmd BufWritePost ~/.Xresourses,~/.Xdefaults !xrdb %

" Autoupdate sxhkd
autocmd BufWritePost ~/.config/sxhkd/sxhkdrc !pkill -USR1 sxhkd

" Put cyan '.' on spaces that are indentations only
" Hide for everything else
set listchars=space:.,precedes:«,extends:»,tab:>.
set list
highlight NonIndent ctermfg=black guifg=black ctermbg=black guifg=black
au BufWinEnter * let w:m1 = matchadd('NonIndent', ' ', 1)
highlight Indentation ctermfg=cyan guifg=cyan
au BufWinEnter * let w:m2 = matchadd('Indentation', '^\(  \)\+', 2)
highlight ExtraSpace ctermbg=cyan guibg=cyan
au BufWinEnter * let w:m3 = matchadd('ExtraSpace', '\s\+$\| \+\ze\t', 3)

" Use zsh
set shell=/usr/bin/zsh

set nocompatible               " be iMproved

" Use the minpac package manager
packadd minpac

" minpac package management
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
call minpac#add('Ace-Who/vim-AutoPair')
call minpac#add('szw/vim-tags')
call minpac#add('idanarye/vim-vebugger')

" Load the packages
packloadall

" Compile LaTeX with pdflatex
function! LaTeXCompile()
  :!pdflatex --enable-write18 %
  :silent !rm %:r.aux %:r.log %:r.*.gnuplot %:r.*.table
endfunction

" Display LaTeX with current xdg default viewer
function! LaTeXDisplay()
  :silent !xdg-open %:r.pdf &
  :redraw!
endfunction

" Compile document with groff, ms macros
function! GroffCompile()
  :silent !groff % -Tpdf -mms  -e -g -R -j -s -t > %:r.pdf
  :redraw!
endfunction

" Compile document with groff, ms macros
function! GroffManCompile()
  :silent !groff -e -g -G -R -j -s -t -Tpdf -mman -o %:r.pdf
  :redraw!
endfunction

" Key remaps

" Useful clipboard binds for visual mode
if has('clipboard')
  vnoremap y "+yy
  vnoremap p "+p
  vnoremap P "+P
  vnoremap Y "+Y
  vnoremap x "+x
  vnoremap X "+X
endif

" LaTeX binds
noremap <Leader>lc  :call LaTeXCompile()<CR>
noremap <Leader>ld :call LaTeXDisplay()<CR>

" Groff binds
noremap <Leader>gc :call GroffCompile()<CR>
noremap <Leader>gm :call GroffManCompile()<CR>
noremap <Leader>gd :call LaTeXDisplay()<CR>

" minpac binds
noremap <F2> :call minpac#update()<CR>

" Tab control
noremap <F8> :tabn

" ShowMarks plugin binds
noremap <Leader>; :DoShowMarks!<CR>
noremap <Leader>, :NoShowMarks!<CR>

" fzf binds
noremap ; :Files<CR>

" NERDTree binds
noremap <M-t> :NERDTreeToggle<CR>

" Clear search hilighting binds
noremap <F3> :set hlsearch!<CR>
inoremap <F3> <ESC>:set hlsearch!<CR>a

" Disable cursor keys in normal mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Disable insert cursor keys
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" unbind Ex mode
noremap Q <Nop>

" Generate ctags
noremap <F4> :TagsGenerate!

" Automatically reindex rtags on c files
au BufWinEnter *.c,*.cpp,*.h,*.hpp call rtags#ReindexFile()

" Set omnicomplete to rtags on c and cpp files
au BufWinEnter,BufEnter,BufNewFile,BufRead *.c,*.cpp,*.h,*.hpp setlocal omnifunc=RtagsCompleteFunc

" st does not report focus
let g:gitgutter_terminal_reports_focus=0

" Lightline appearence
let g:lightline = {
\   'active': {
\    'left': [[ 'mode', 'paste'], ['readonly', 'filename', 'modified', 'git']]
\   },
\   'component_function': {
\    'git': 'fugitive#head'
\   }
\ }

" ASM needs 8 space tabs
au FileType asm setlocal tabstop=8 shiftwidth=8 noexpandtab

" Searching
set incsearch
set ignorecase
set smartcase

" Modelines
set modeline
set modelines=1

" No swp
set noswapfile

" QoL
set lazyredraw
set linebreak
set encoding=utf-8
set fileencodings=utf-8
filetype plugin indent on
let c_no_curly_error=1
let g:omni_sql_no_default_maps = 1
let g:rust_recommended_style = 0

" Spelling
set dictionary=en_us
set nospell
au BufWinEnter,BufEnter,BufNewFile,BufRead *.txt setlocal spell

" Folding
set foldmethod=syntax
set foldnestmax=5
set foldlevel=1
noremap <Leader>zf :setlocal foldmethod=manual<CR>
noremap <Leader>zF :setlocal foldmethod=syntax<CR>

augroup CleanWhitespace
  autocmd!
  au BufWritePre * :%s/\s\+$//e
augroup END
