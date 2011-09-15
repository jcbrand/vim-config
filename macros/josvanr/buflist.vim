" **buflist.vim**
" 
" Use an interactive buffer list to manage the currently loaded buffers.
" 
" MAPS:
" 
"   <cr>   Open the buffer list.
" 
"   From the buffer list:
" 
"   <cr>   Edit the buffer on the current line.
"    x     Remove a buffer.
"   <esc>  Quit the buffer list.
"
" -----------------------------------------------------------------------------
nm ,<cr> :call BuflistOpen()<cr>
" ----------------------------------------------------------------------------- 
if !exists("_buflist_vim_sourced")
let _buflist_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\buffun.vim
so ~\fun.vim
so ~\strfun.vim
so ~\txtfun.vim

augroup buflist
  au!
  au bufenter _buflist nm <cr> :call BuflistEdit()<cr>
  au bufleave _buflist nun <cr>
  au bufenter _buflist nm <esc> :call BuflistClose()<cr>
  au bufleave _buflist nun <esc>
  au bufenter _buflist nm x :call BuflistDelete()<cr>
  au bufleave _buflist nun x
  au bufleave _buflist so ~/_vimrc
augroup END

" Edit the buffer on the current line
function! BuflistEdit()
  " avoid return prompts
  set ch=10
  execute "normal viWy"
  let b=@0
  execute "bd!"
  call delete("_buflist")
  execute "b ".b
  set ch=1
endfunction

" Remove a buffer from the buffer list
function! BuflistDelete()
  set ch=10
  call BuflistEdit()
  execute "w!"
  execute "bd!"
  call BuflistOpen(g:buflistLastEditedBuffer)
  set ch=1
endfunction

" Open the buffer list
function! BuflistOpen(...)
  set ch=10
  if a:0==0
    let bc=bufnr("%")
    execute "w!"
  else
    let bc=a:1
  endif
  let g:buflistLastEditedBuffer=bc
  if bufnr("$")==1
    echo "Only one buffer in memory."
  else
    let fn="_buflist"
    call delete(fn)
    execute "e!".fn
    let b=bufnr("%")
    let bl=bufnr("$")
    let bcline=1
    let i=1
    while i<=bl
      if bufexists(i)&&(i!=b)
        call ToLine("$")
        call PrintLineAfter(i." ".bufname(i))
        if i==bc
          let bcline=line("$")
        endif
      endif
    let i=i+1
    endwhile
    call DeleteLine(1) 
    exe bcline-1
    execute "normal 1|"
  endif
  set ch=1
endfunction

" Close the bufferlist, and return to previously edited file
function! BuflistClose()
  set ch=10
  execute "bd!"
  call delete("_buflist")
  if exists("g:buflistLastEditedBuffer")
    let b=g:buflistLastEditedBuffer
    if bufexists(b)
      execute "b".b
    endif
  endif
  set ch=1
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
