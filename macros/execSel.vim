" njj: I prefer Ron Aaron's
" vmap ;x "yy:@y<cr>
"
" ----execSel.vim----
"
" Script that lets you type any Vim commands into the current buffer and source
"  it without saving into a file. To use just source this file, select all the
"  lines in the buffer that you want to source and type \e.
"
" Author: Hari <haridsv@hotmail.com>
" Last Modified: 03-Sep-1999 (24:00)

:function! ExecSelection () range
:  let tmpFileName = tempname ()
:  exec "'<,'>w! " . tmpFileName
:  exec 'source ' . tmpFileName
:endfunction

:map \e :call ExecSelection ()<CR>:<CR> 
