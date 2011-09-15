"----selectBuffer.vim----
"
" selectBuffer.vim -- lets you select a buffer visually.
" Source this file and press <F3> to get the list of buffers.
" Move the cursor on to the buffer that you need to select and press <Enter>
" If you want to close the window without making a selection, press <F3> again.
"
" Author: Hari Krishna <haridsv@hotmail.com>
" Last Change: 23-Jul-1999 @ 16:25
"
" TODO:
"   More than 1 VIM windows cann't start the browser.
"
" To configure the behavior, take a look at the following.

"
" BEGIN configuration.
"

"
" The key sequence that should activate the buffer browser. The default is
"   <F3>. Enter the key sequence in a single quoted string, exactly as you
"   would use it in a map command.
"
:let selBufActKeySeq = '<F3>'

"
" The name of the browser. The default is "/---Select Buffer---", but you can
"   change the name at your will. A leading '/' is advised if you change
"   directories from with in vim.
:let selBufWindowName = '/---\ Select\ Buffer\ ---'

"
" A non-zero value for the variable selBufOpenInNewWindow means that the
"   selected buffer should be opened in a separate window. The value zero will
"   open the selected buffer in the current window.
"
:let selBufOpenInNewWindow = 0

"
" A non-zero value for the variable selBufRemoveBrowserBuffer means that after
"   the selection is made, the buffer that belongs to the browser should be
"   deleted. But this is not advisable as vim doesn't reuse the buffer numbers
"   that are no longer used. The default value is 0, i.e., reuse a single
"   buffer. This will avoid creating lots of gaps and quickly reach a large
"   buffer numbers for the new buffers created.
:let selBufRemoveBrowserBuffer = 0

"
" A non-zero value for the variable highlightOnlyFilename will highlight only
"   the filename instead of the whole path. The default value is 0.
:let highlightOnlyFilename = 0

"
" END configuration.
"

:function! SelBufSetupActivationKey ()
:  exec 'nmap ' . g:selBufActKeySeq . ' :call SelBufListBufs ()<CR>'
:endfunction

:function! SelBufSetupDeActivationKey ()
:  exec 'nmap ' . g:selBufActKeySeq . ' :quit<CR>'
:endfunction

:call SelBufSetupActivationKey ()

:function! SelBufListBufs ()
:  let saveReport = &report
:  let &report=10000
:  split
:  exec ":e " . g:selBufWindowName
:  $put=\"Buffer\t\t\tFile\"
:  1d
:  let i = 1
:  let myBufNr = bufnr ("%")
:  while i <= bufnr ("$")
:    if bufexists (i) && (i != myBufNr)
:      $put=i . \"\t\t\t\" . bufname (i)
:    endif
:    let i = i + 1
:  endwhile
:  1
:  set nomodified
:  aug ListBuffers
:    exec "au WinEnter " . g:selBufWindowName . " call SelBufSetupSelect ()"
:    exec "au WinLeave " . g:selBufWindowName . " call SelBufUnsetupSelect ()"
:    exec "au BufLeave " . g:selBufWindowName . " call SelBufClearSetup ()"
:  aug END
:  call SelBufSetupSelect ()
:  let &report = saveReport
:endfunction

:function! SelBufClearSetup ()
:  aug ListBuffers
:    exec "au! WinEnter " . g:selBufWindowName
:    exec "au! WinLeave " . g:selBufWindowName
:    exec "au! BufLeave " . g:selBufWindowName
:  aug END
:  call SelBufUnsetupSelect ()
:endfunction

:function! SelBufSetupSelect ()
:  if ! exists ("g:SelBufSetup")
:    syn keyword Title Buffer File
:    if g:highlightOnlyFilename == 0
:      syn match Directory +\([a-z][A-Z]:\)\=\([/\\]*\p\+\)+
:    else
:      syn match Directory +\([^/\\]\+$\)+
:    endif
:    syn match Constant +^[0-9]\++
:    nmap <CR> :call SelBufSelectCurrentBuffer ()<CR>
:    cabbr w q
:    cabbr wq q
:    call SelBufSetupDeActivationKey ()
:    let g:SelBufSetup = 1
:  endif
:endfunction

:function! SelBufUnsetupSelect ()
:  if exists ("g:SelBufSetup")
:    nunmap <CR>
:    cunabbr w
:    cunabbr wq
:    call SelBufSetupActivationKey ()
:    unlet g:SelBufSetup
:  endif
:endfunction

:function! SelBufSelectCurrentBuffer ()
:  let myBufNr = bufnr ("%")
:  normal 0yw
:  if @" =~ "Buffer"
:    +
:    return
:  endif
:  if ! g:selBufOpenInNewWindow
:    quit
:  endif
:  exec "buffer" @"
:  if g:selBufRemoveBrowserBuffer
:    exec "bd " . myBufNr
:  endif
:endfunction
"----selectBuffer.vim----
