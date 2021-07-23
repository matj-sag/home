call plug#begin('~/.vim/plugged')
Plug 'frazrepo/vim-rainbow'
Plug 'adelarsq/vim-matchit'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'plasticboy/vim-markdown'
Plug 'elzr/vim-json'
Plug 'leafgarland/typescript-vim'
Plug 'ekalinin/dockerfile.vim'
Plug 'moll/vim-node'
Plug 'hdima/python-syntax'
Plug 'hynek/vim-python-pep8-indent'
Plug 'rip-rip/clang_complete'
Plug 'conradirwin/vim-bracketed-paste'
Plug 'pbrisbin/vim-mkdir'
Plug 'sukima/xmledit'
Plug 'bogado/file-line'
Plug 'terryma/vim-smooth-scroll'
Plug 'avakhov/vim-yaml'
Plug 'ervandew/supertab'
Plug 'ntpeters/vim-better-whitespace'
Plug 'adelarsq/vim-matchit'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'tpope/vim-fugitive'
call plug#end()
set noexpandtab
set softtabstop=3
set shiftwidth=3
set cindent
set autoindent
set smartindent
set tabstop=3
set backspace=2
set sm
set ai
syntax on
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1
set foldmethod=indent
set foldlevel=1
set lbr
" new tex file
map nt i\documentclass[a4paper,12pt]{report}<enter><enter>\author{Matthew Johnson\\matthew.johnson@cl.cam.ac.uk}<enter>\title{}<enter><enter>\begin{document}<enter><enter>\maketitle<enter><enter><enter><enter>\end{document}<esc>/title<enter>$i
" temp java file
map jt ipublic class test<enter>{<enter>public static void main(String[] args)<enter>{<enter>}<enter>}<enter><esc>kkko
map rl gqap
set background=dark
autocmd FileType make set noet
set shm=AITt
set noequalalways

if $TERM=='screen'
   exe "set title titlestring=vim:%f"
   exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif

let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F1> :TlistToggle<cr>
"map <F9> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

map <F8> :cp<cr>
map <F9> :cn<cr>
map <F7> :cw<cr>
map sfl :set foldlevel=9999<CR>
map <F2> :Ex<CR>
map <F3> :bp<CR>
map <F4> :bn<CR>

let g:clang_library_path='/shared/apama-lib5/linux/amd64/rhel8-gcc8.4.1/clang/12.0.0/lib/'
set laststatus=2
if !has('gui_running')
  set t_Co=256
endif
let g:lightline = { 'colorscheme': 'PaperColor', }
set noshowmode
let g:rainbow_active = 1
let g:vim_json_syntax_conceal = 0

noremap <silent> <PageUp> :call smooth_scroll#up(&scroll/2, 3, 1)<CR>
noremap <silent> <PageDown> :call smooth_scroll#down(&scroll/2, 3, 1)<CR>
noremap <silent> <C-PageUp> :call smooth_scroll#up(&scroll, 5, 2)<CR>
noremap <silent> <C-PageDown> :call smooth_scroll#down(&scroll, 5, 2)<CR>

autocmd VimEnter * NERDTree | wincmd p

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"
" How to use split windows:
"
" :tabedit / :tab split
" :split file to split
" ^W^W - toggle window
" ^W <direction> change window
" ^W +/- resize
"
