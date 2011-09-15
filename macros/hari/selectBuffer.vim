"
" selectBuffer.vim -- lets you select a buffer visually.
"  Source this file and press <F3> to get the list of buffers.
"  Move the cursor on to the buffer that you need to select and press <CR> or
"   double click with the left-mouse button.
"  If you want to close the window without making a selection, press <F3> again.
"  You can also press ^W<CR> to open the file in a new window.
"  You can use dd to delete the buffer.
"  For convenience when the browser is opened, the line corresponding to the
"   next buffer is marked with 'a so that you can quickly go to the next buffer.
"
" Author: Hari Krishna <haridsv@hotmail.com>
" Last Change: 01-Nov-1999 @ 19:52
"
" Bugs fixed and Improvements made:
"  If for some reason, there is only one window, the application may quit.
"  Now you don't need to prepend a / to the browser name.
"  Setup/Unsetup of the browser window is done more robustly.
"  A quick hack is provided to restore the search string. It works for most of
"   the time.
"  Only one browser window will be on. If the <F3> is pressed when there is
"   already a window open, then the focus will be taken into the existing
"   window.
"  Now the browser restores the window heights when it is done.
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
" The name of the browser. The default is "---Select Buffer---", but you can
"   change the name at your will.
:let selBufWindowName = '---\ Select\ Buffer\ ---'

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
:  exec 'nmap ' . g:selBufActKeySeq . ' :call SelBufListBufs ()<CR>:<BS>'
:endfunction

:function! SelBufSetupDeActivationKey ()
:  exec 'nmap ' . g:selBufActKeySeq . ' :quit<CR>:call RestoreWindowSettings()<CR>:<BS>'
:endfunction

:call SelBufSetupActivationKey ()

:function! SelBufListBufs ()
:  " First check if there is a browser already running.
:  let browserWinNo = FindWindowForBuffer (g:selBufWindowName)
:  if browserWinNo != -1
:    exec "normal " . browserWinNo . "\<C-W>w"
:    return
:  endif
:  call SaveWindowSettings ()
:  let savedReport = &report
:  let &report = 10000
:  let curBuf = bufnr ("%")
:  " A quick hack to restore the search string.
:  if histnr ("search") != -1
:    let g:selBufSavedSearchString = histget ("search", -1)
:  endif
:  split
:
:  " Find if there is a buffer already created.
:  let bufNo = FindBufferForName(g:selBufWindowName)
:  if bufNo != -1
:    " Switch to the existing buffer.
:    exec "buffer " . bufNo
:  else
:    " Create a new buffer.
:    exec ":e " . g:selBufWindowName
:  endif
:  set noswapfile
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
:  exec "/^" . curBuf
:  call histdel ("search", -1)
:  if line (".") < line ("$")
:    +mark a " Mark the next line.
:  endif
:  1
:  set nomodified
:  exec "normal \<C-W>_"
:  let &report = savedReport
:endfunction

:aug SelectBuffers
:  au!
:  exec "au WinEnter " . g:selBufWindowName . " call SelBufSetupSelect ()"
:  exec "au BufEnter " . g:selBufWindowName . " call SelBufSetupSelect ()"
:  exec "au WinLeave " . g:selBufWindowName . " call SelBufUnsetupSelect ()"
:  exec "au BufLeave " . g:selBufWindowName . " call SelBufUnsetupSelect ()"
:aug END

:function! SelBufSetupSelect ()
:  if ! exists ("g:SelBufSetup")
:    syn keyword Title Buffer File
:    if g:highlightOnlyFilename == 0
:      syn match Directory +\([a-z][A-Z]:\)\=\([/\\]*\p\+\)+
:    else
:      syn match Directory +\([^/\\]\+$\)+
:    endif
:    syn match Constant +^[0-9]\++
:    nmap <CR> :call SelBufSelectCurrentBuffer (0)<CR>:<BS>
:    nmap <2-LeftMouse> :call SelBufSelectCurrentBuffer (0)<CR>:<BS>
:    nmap <C-W><CR> :call SelBufSelectCurrentBuffer (1)<CR>:<BS>
:    nmap dd :call SelBufDeleteCurrentBuffer ()<CR>:<BS>
:    cabbr w q
:    cabbr wq q
:    call SelBufSetupDeActivationKey ()
:    let g:SelBufSetup = 1 " Some value.
:  endif
:endfunction

:function! SelBufUnsetupSelect ()
:  if exists ("g:SelBufSetup")
:    nunmap <CR>
:    nunmap <2-LeftMouse>
:    nunmap <C-W><CR>
:    nunmap dd
:    cunabbr w
:    cunabbr wq
:    call SelBufSetupActivationKey ()
:    " A quick hack to restore the search string.
:    if exists ("g:selBufSavedSearchString")
:      if histget ("search", -1) != g:selBufSavedSearchString
:        let @/ = g:selBufSavedSearchString
:        call histadd ("search", g:selBufSavedSearchString)
:        unlet g:selBufSavedSearchString
:      endif
:    endif
:    unlet g:SelBufSetup
:  endif
:endfunction

:function! SelBufSelectCurrentBuffer (openInNewWindow)
:  let myBufNr = bufnr ("%")
:  normal 0yw
:  if @" =~ "Buffer"
:    +
:    return
:  endif
:  if (! a:openInNewWindow) && ! (g:selBufOpenInNewWindow)
:    " In any case, if there is only one window, then don't quit.
:    let moreThanOneWindowExsists = (NumberOfWindows () > 1)
:    if moreThanOneWindowExsists
:      quit
:    endif
:  endif
:  exec "buffer" @"
:  if g:selBufRemoveBrowserBuffer
:    exec "bd " . myBufNr
:  endif
:  call RestoreWindowSettings ()
:endfunction

:function! SelBufDeleteCurrentBuffer ()
:  let saveReport = &report
:  let &report = 10000
:  normal 0yw
:  if @" =~ "Buffer"
:    +
:    return
:  endif
:  exec "bdelete" @"
:  delete
:  set nomodified
:  let &report = saveReport
:endfunction


