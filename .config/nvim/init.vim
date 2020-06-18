set number relativenumber " Relative Line Numbers
set hidden "Let vim act like every other editor
" To expand the number of binds nvim can do
let mapleader="\<Space>"
let maplocalleader='='

" Highlight when a line exceeds 80 columns
highlight OverLength ctermbg=Red ctermfg=White
" match OverLength /\%81v.\+/ " Old Method
au BufWinEnter * let w:ol = matchadd('OverLength', '\%81v.\+', -1)

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
set noshowmode

" Let ale complete
let g:ale_completion_enabled = 1

" Use the minpac package manager
packadd minpac

" minpac package management
call minpac#init()

call minpac#add('itchyny/lightline.vim')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-surround')
call minpac#add('jacquesbh/vim-showmarks')
call minpac#add('vim-scripts/SearchComplete')
call minpac#add('roxma/python-support.nvim')
call minpac#add('editorconfig/editorconfig-vim')
call minpac#add('w0rp/ale')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-speeddating')
call minpac#add('tpope/vim-fugitive')
call minpac#add('szw/vim-tags')
call minpac#add('idanarye/vim-vebugger')
call minpac#add('lervag/vimtex')
call minpac#add('tikhomirov/vim-glsl')
call minpac#add('maximbaz/lightline-ale')
call minpac#add('sirver/ultisnips')
call minpac#add('honza/vim-snippets')
call minpac#add('0mco/math-tex-snippets')
call minpac#add('gillescastel/latex-snippets')
call minpac#add('shougo/deoplete.nvim')

" Load the packages
packloadall

set omnifunc=ale#completion#omnifunc
let g:deoplete#enable_at_startup = 1
set completeopt=longest,menuone,preview

function! GroffDisplay()
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

function! ShowMarkdown()
  :silent !pandoc -s % -t ms | groff -m ms -T pdf | zathura -
endfunction

function! CompileMarkdown()
  :!pandoc -s % -t ms | groff -m ms -T pdf > %:r.pdf
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

" Groff binds
noremap <Leader>gc :call GroffCompile()<CR>
noremap <Leader>gm :call GroffManCompile()<CR>
noremap <Leader>gd :call GroffDisplay()<CR>

noremap <Leader>md :call ShowMarkdown()<CR>
noremap <Leader>mc :call CompileMarkdown()<CR>

" Makefile
noremap <Leader>m :!make -j2 DEBUG=yes<CR>
noremap <Leader>M :!make -j2 DEBUG=no<CR>
noremap <Leader>tt :!make -j2 DEBUG=yes test<CR>
noremap <Leader>tT :!make -j2 DEBUG=no test<CR>

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

" st does not report focus
let g:gitgutter_terminal_reports_focus=0

" Editor config
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

" Lightline appearence
let g:lightline = {}

let g:lightline.component_expand = {
  \ 'linter_checking': 'lightline#ale#checking',
  \ 'linter_warnings': 'lightline#ale#warnings',
  \ 'linter_errors': 'lightline#ale#errors',
  \ 'linter_ok': 'lightline#ale#ok',
  \ }

let g:lightline.component_type = {
      \ 'linter_checking': 'left',
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error',
      \ 'linter_ok': 'left',
      \}

let g:lightline = {
\   'active': {
\    'left': [[ 'mode', 'paste'], ['readonly', 'filename', 'modified', 'git']],
\    'right': [
\             ['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype'],
\             [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]
\             ]
\   },
\   'component_function': {
\    'git': 'fugitive#head'
\   }
\ }

" ASM needs 8 space tabs
au FileType asm setlocal tabstop=8 shiftwidth=8 noexpandtab

" Makefiles need 2 space tabs
au FileType mk setlocal tabstop=2 shiftwidth=2 noexpandtab
au BufWinEnter,BufEnter,BufNewFile,BufRead Makefile setlocal tabstop=2 shiftwidth=2 noexpandtab

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
let g:Tex_DefaultTargetFormat = 'pdf'
let g:ale_linters = { 'c': ['ccls']}

" Spelling
set dictionary=en_us
set nospell
au BufWinEnter,BufEnter,BufNewFile,BufRead *.txt setlocal spell
au BufWinEnter,BufEnter,BufNewFile,BufRead *.md setlocal spell
au BufWinEnter,BufEnter,BufNewFile,BufRead *.tex setlocal spell

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'customsnips']

let g:tex_flavor="latex"
let g:vimtex_view_method="zathura"
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal="abdmg"

set spelllang=en_us
" automatically choose first spelling correction
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Folding
set foldmethod=syntax
set foldnestmax=5
set foldlevel=1
noremap <Leader>zf :setlocal foldmethod=manual<CR>
noremap <Leader>zF :setlocal foldmethod=syntax<CR>

"URL Search
noremap <Leader><Leader> /http<CR>
noremap <Leader>y "+y$"+yt<SPACE>
noremap <Leader>Y gJN"+y$"+yt<SPACE>

" RFC date
command RFCDate .-1read !date "+\%a, \%d \%b \%Y \%H:\%M:\%S \%z"
noremap <Leader>d a<CR><ESC>:RFCDate<CR>I<BS><ESC>j0i<BS><ESC>l

augroup CleanWhitespace
  autocmd!
  au BufWritePre * :%s/\s\+$//e
augroup END

augroup doccmd
  autocmd!
  au BufWritePost *.groff call GroffCompile()
augroup END

augroup editor
  autocmd!
  au BufWinEnter,BufEnter,BufNewFile,BufRead * EditorConfigEnable
augroup END

augroup Mail
  autocmd!
  au BufRead,BufNewFile /tmp/mutt-* set tw=72
augroup END
