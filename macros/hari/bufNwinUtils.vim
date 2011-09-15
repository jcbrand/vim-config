" bufNwinUtils.vim
" Return the number of windows open currently.
"
:function! NumberOfWindows ()
:  let i = 1
:  while winbufnr (i) != -1
:    let i = i+1
:  endwhile
:  return i - 1
:endfunction

"
" Find the window number for the buffer passed.
"
:function! FindWindowForBuffer (bufferName)
:  let bufno = bufnr (a:bufferName)
:  return bufwinnr (bufno)
:endfunction

" Returns the buffer number of the given fileName if it is already loaded.
:function! FindBufferForName (fileName)
:  let i = 1
:  while i <= bufnr ("$")
:    if bufexists (i) && (match (bufname (i), a:fileName) != -1)
:      break
:    endif
:    let i = i + 1
:  endwhile
:  if i <= bufnr ("$")
:    return i
:  else
:    return -1
:  endif
:endfunction

"
" Saves the heights of the currently open windows for restoring later.
"
:function! SaveWindowSettings ()
:  let i = 2
:  let g:savedCurrentWindowNumber = winnr ()
:  let g:savedWindowSettings = winheight (1)
:  while winbufnr (i) != -1
:    let g:savedWindowSettings = g:savedWindowSettings . "," . winheight (i)
:    let i = i + 1
:  endwhile
:endfunction

"
" Restores the heights of the windows from the information that is saved by
"  SaveWindowSettings ().
"
:function! RestoreWindowSettings ()
:  if ! exists ("g:savedWindowSettings")
:    return
:  endif
:  
:  let prevIndex = 0
:  let winNo = 1
:  while prevIndex != -1
:    let nextWinHeight = NextElement (g:savedWindowSettings, ",", prevIndex)
:    exec "normal " . winNo . "\<C-W>w"
:    exec "resize " . nextWinHeight
:    let winNo = winNo + 1
:    let prevIndex = NextIndex (g:savedWindowSettings, ",", prevIndex + 1)
:  endwhile
:  unlet g:savedWindowSettings
:
:  " Restore the current window.
:  exec "normal " . g:savedCurrentWindowNumber . "\<C-W>w"
:  unlet g:savedCurrentWindowNumber
:endfunction


