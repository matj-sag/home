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
source ~/.vim-SuperTab
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
nmap <F4> :call OpenFileFromClipboard()
imap <F4> <C-o>:call OpenFileFromClipboard()

if $TERM=='screen'
   exe "set title titlestring=vim:%f"
   exe "set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif


"
" How to use split windows:
"
" :split file to split
" ^W^W - toggle window
" ^W <direction> change window
" ^W +/- resize
"
