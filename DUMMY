call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/vim-lsp'
Plug 'frazrepo/vim-rainbow'
Plug 'adelarsq/vim-matchit'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
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



"
" How to use split windows:
"
" :tabedit / :tab split
" :split file to split
" ^W^W - toggle window
" ^W <direction> change window
" ^W +/- resize
"
