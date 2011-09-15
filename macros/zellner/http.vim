" Description:	http client for vim -- type :Http, then <f1>
" Author:	Johannes Zellner <johannes@zellner.org>
" URL:		http://www.zellner.org/vim/plugin/http.vim
" Last Change:	Die, 17 Okt 2000 15:00:26 +0200
" Requirements:	vim >= 6.0h, cpoptions must /not/ contain '<C'
"		python
" $Id: http.vim,v 1.4 2000/10/25 13:03:16 joze Exp $

command! -nargs=? Http call Http(<q-args>)
command! -nargs=? Hhttp let g:http_split_vertical = 0 | call Http(<q-args>)
command! -nargs=? Vhttp let g:http_split_vertical = 1 | call Http(<q-args>)

aug HTTP
    au!
    au BufEnter http://* call Http(expand('<afile>')) | exe 'silent! bd! '.expand('<afile>')
aug END

if !exists('g:http_split_vertical')
    let g:http_split_vertical = 1
endif

if !exists('g:http_python_library')
    let g:http_python_library = expand('<sfile>:p:h').'/httpvim.py'
endif

if !exists('g:http_anchor_s') || !exists('g:http_anchor_e')
    " let g:http_anchor_s = '·'
    " let g:http_anchor_e = '·'
    let g:http_anchor_s = '·'
    " let g:http_anchor_e = '»'
    let g:http_anchor_e = ''
    " let g:http_anchor_s = ''
    " let g:http_anchor_e = ''
endif

fun! Http(url)
    if !exists('g:http_python_initialized')
	if !has('python')
	    echohl WarningMsg | echo 'sorry, the http plugin needs a python enabled vim version' | echohl NONE
	    return
	endif
	" [-- initializing: done only once --]
	if !filereadable(g:http_python_library)
	    echo "python library file `".g:http_python_library."' not found"
	    return
	endif
	exe 'pyfile '.g:http_python_library
	python import vim
	exe 'python pages = UrlPageList("'.g:http_anchor_s.'","'.g:http_anchor_e.'")'
	let g:http_context = ''
	let g:http_python_initialized = 1
    endif
    call HttpCmd(a:url)
endfun

fun! HttpCmd(url)
    if '' == a:url
	return
    endif
    echo 'loading '.a:url.' ...'
    call HttpDisplay('python vim.current.buffer.append(pages("'.a:url.'",'.winwidth(0).',0))', '')
    let v:statusmsg = ''
endfun

fun! HttpSaveMarks()
    if '' == g:http_context
	" [-- save marks --]
	let lnum = line('.')
	let cnum = col('.')
	normal H
	let top = line('.')

	let restore_marks = 'normal '.top.'Gzt'.lnum.'G'.cnum.'|'
	exe 'python pages.save_data_to_current("'.restore_marks.'")'
    endif
endfun

fun! HttpRestoreMarks(context)
    let g:http_context = a:context
    if '' == g:http_context
	python vim.command(pages.get_data_from_current())
    endif
endfun

" [-- clear buffer and call command to fill the buffer --]
fun! HttpDisplay(command, context)
    if hlexists('httpHelpHeader')
	syn clear httpHelpHeader
	syn clear httpHelpSpecial
    endif

    if bufexists('/http')
	call HttpBufferSwitchto()
    else
	call HttpBufferCreate()
    endif

    call HttpSaveMarks()

    " [-- fill the buffer with the callback command --]
    setlocal noro
    %d _
    exe a:command
    if getline(1) =~ '^\s*$'
	" remove blank line at top
	1d _
    endif
    setlocal nomodified
    setlocal ro

    " [-- restore marks --]
    call HttpRestoreMarks(a:context)
    " TODO display the new current name (w/o hitting carriage return)
    " let v:statusmsg = HttpCurrent()
endfun

fun! HttpBufferSwitchto()
    let switchbuf=&switchbuf
    set switchbuf=useopen
    if g:http_split_vertical
	vertical sb /http
    else
	sb /http
    endif
    let &switchbuf=switchbuf
    call HttpBufferSetup()
endfun

fun! HttpBufferCreate()
    if g:http_split_vertical
	vertical sp /http
    else
	sp /http
    endif
    call HttpBufferSetup()
endfun

fun! HttpBufferSetup()
    if exists('b:http_setup')
	return
    endif
    " setlocal noswapfile
    setlocal noswapfile
    setlocal report=999999
    setlocal buftype=scratch
    setlocal showcmd " want to see typing counts
    " exe 'setlocal isprint+='.g:http_anchor_s
    " exe 'setlocal isprint+='.g:http_anchor_e
    call HttpLocalMappings()
    call HttpSyntax()
    " augroup httpLEAVE
    "     au! VimLeavePre * silent! bd! /http
    " augroup END
    let b:http_setup = 1
endfun

fun! HttpSyntax()
    if has('syntax')
	syn clear
	let s = strlen(g:http_anchor_s)
	let e = strlen(g:http_anchor_e)
	if s > 0
	    let start='hs=s+'.s
	else
	    let start=''
	endif
	if e > 0
	    let end='he=e-'.e
	else
	    let end=''
	endif
	exe 'syn region httpLink matchgroup=NONE start=+'.g:http_anchor_s.'+'.start.' end=+\[\d\+\]'.g:http_anchor_e.'+'.end.' contains=httpLinkNumber keepend'
	exe 'syn match httpLinkNumber contained +\[\d\+\]+hs=s+1,he=e-1'

	hi link httpLink	Identifier
	hi link httpLinkNumber	Number
	" hi link httpNav           Function
	" hi link httpCurrent       Function
	" hi link httpHelpHeader    Comment
    endif
endfun

fun! HttpLocalMappings()
    " don't need insert mode commands
    noremap <buffer> a <nop>
    noremap <buffer> A <nop>
    noremap <buffer> c <nop>
    noremap <buffer> C <nop>
    noremap <buffer> d <nop>
    noremap <buffer> D <nop>
    noremap <buffer> i <nop>
    noremap <buffer> I <nop>
    noremap <buffer> o <nop>
    noremap <buffer> O <nop>
    noremap <buffer> r <nop>
    noremap <buffer> R <nop>
    noremap <buffer> s <nop>
    noremap <buffer> S <nop>
    noremap <buffer> x <nop>
    noremap <buffer> X <nop>
    " local command keys

    " [-- navigation --]
    nnoremap <buffer> <cr>          :<c-u>call HttpSelect()<cr>
    nnoremap <buffer> <2-LeftMouse> :<c-u>call HttpSelect()<cr>
    nnoremap <buffer> <RightMouse>  :<c-u>call HttpBack()<cr>
    nnoremap <buffer> <MiddleMouse> :<c-u>call HttpForward()<cr>
    nnoremap <buffer> <tab>         :call HttpNextLink()<cr>
    nnoremap <buffer> <bs>          :call HttpPrevLink()<cr>
    nnoremap <buffer> ,             :<c-u> call HttpBack()<cr>
    nnoremap <buffer> .             :<c-u> call HttpForward()<cr>
    nnoremap <buffer> u             :<c-u> call HttpEditUrl()<cr>
    nnoremap <buffer> s             :<c-u> call HttpListSetup()<cr>
    nnoremap <buffer> S             :<c-u> call HttpHistoryListSetup()<cr>
    nnoremap <buffer> r             :<c-u> call HttpRedisplay()<cr>
    nnoremap <buffer> <c-r>         :<c-u> call HttpReload()<cr>

    " [-- query --]
    nnoremap <buffer> <c-g>         :<c-u> echo HttpCurrent()<cr>
    nnoremap <buffer> i             :<c-u> call HttpPeek()<cr>
    nnoremap <buffer> I             :<c-u> call HttpPeekHeader()<cr>
    nnoremap <buffer> <f1>          :<c-u> call HttpHelp()<cr>
    nnoremap <buffer> q             :<c-u> call HttpQuit()<cr>
    " [-- visual --]
    vnoremap <buffer> d             :call HttpDeleteBuffers()<cr>
endfun

fun! HttpDeleteBuffers() range
    if 'select' != g:http_context
	return
    endif
    let lnum = a:firstline
    while lnum <= a:lastline
	exe 'python del pages["'.HttpGetUrlFromList(lnum).'"]'
	let lnum = lnum + 1
    endwhile
    set noro
    exe a:firstline.','.a:lastline.'d'
    set nomodified
    set ro
endfun

fun! HttpPeek()
    echo HttpLink()
endfun

fun! HttpPeekHeader()
    python pages.headers(pages.current())
endfun

fun! HttpEditUrl()
    " add the current buffer to the history
    " so that we can easily edit.
    let url = HttpCurrent()
    call histadd('@', url)
    let new_url = input('url? ')
    call HttpCmd(new_url)
endfun

fun! HttpSelect()
    if '' == g:http_context
	call HttpCmd(HttpLink())
    elseif 'help' == g:http_context
	call HttpRedisplay()
    elseif 'select' == g:http_context
	call HttpCmd(HttpGetUrlFromList(line('.')))
    endif
endfun

fun! HttpGetUrlFromList(lnum)
    return substitute(getline(a:lnum), '^\s*\(-->\s*\)\=\([^ \t]*\).*$', '\2', '')
endfun

" [-- extract http link number at the current cursor position --]
fun! HttpLink()
    if v:count
	let n = v:count
    else
	let line = getline(line('.'))
	let cnum = col('.') - 1
	if cnum > 0
	    let cnum = cnum - 1
	endif
	let pos = stridx(strpart(line, cnum, 999999), ']'.g:http_anchor_e)
	if -1 == pos
	    " try the next line
	    let line = getline(line('.') + 1)
	    let pos = stridx(line, ']'.g:http_anchor_e)
	    if -1 == pos
		return ''
	    endif
	else
	    let pos = pos + cnum
	endif
	let n = substitute(strpart(line, 0, pos), '^.\{-}\(\d\+\)$', '\1', '')
	if n !~ '^\d\+$'
	    return ''
	endif
    endif
    exe 'python vim.command("let link = \"" + pages.anchor('.n.') + "\"")'
    return link
endfun

fun! HttpCurrent()
    python vim.command("let link = '" + pages.current() + "'")
    return link
endfun

fun! HttpRedisplay()
    call HttpDisplay('python vim.current.buffer.append(pages.redisplay('.winwidth(0).'))', '')
endfun

fun! HttpReload()
    call HttpDisplay('python vim.current.buffer.append(pages.reload('.winwidth(0).'))', '')
endfun

fun! HttpQuit()
    if '' == g:http_context
	call HttpSaveMarks()
	let g:http_context = 'closed'
	bd! /http
    else
	call HttpRedisplay()
    endif
endfun

" [-- <tab> jumps to the next anchor --]
fun! HttpNextLink()
    if '' == g:http_anchor_e
	call search(g:http_anchor_s.'\_.\{-}\[\d\+\]')
    else
	call search(g:http_anchor_s.'\_[^'.g:http_anchor_e.']\{-}\[\d\+\]'.g:http_anchor_e)
    endif
endfun

" [-- <bs> jumps to the previous anchor --]
fun! HttpPrevLink()
    if '' == g:http_anchor_e
	exe 'silent! normal ?'.g:http_anchor_s.'\_.\{-}\[\d\+\]?'
    else
	exe 'silent! normal ?'.g:http_anchor_s.'\_[^'.g:http_anchor_e.']\{-}\[\d\+\]'.g:http_anchor_e.'?'
    endif
    call histdel('/', -1)
endfun

fun! HttpPlaceArrow()
    setlocal noro
    %s/^/     /
    call histdel('/', -1)
    1
    call search('^\s*'.escape(HttpCurrent(), '~?.^$*').'\s*$')
    s/^     / --> /
    call histdel('/', -1)
    normal 0
    setlocal nomodified
    setlocal ro
endfun

fun! HttpHelpCallback()
    let help = 
    \ "[-- navigation --]\n"
    \."  <cr> / <2-LeftMouse> --  select link under cursor. Can be given\n"
    \."                           a count: e.g. 42<cr> selects link 42\n"
    \."  <tab>                --  jump to next link\n"
    \."  <bs>                 --  jump to prev link\n"
    \."  , / <RightMouse>     --  Back: go to older entry in history\n"
    \."  . / <MiddleMouse>    --  Forward: go to newer entry in history\n"
    \."  u                    --  enter url (use the input history)\n"
    \."  s                    --  show list of cached documents\n"
    \."  S                    --  show history list\n"
    \."  r                    --  redisplay according to the window's width\n"
    \."  <c-r>                --  reload\n"
    \."\n"
    \."[-- query --]\n"
    \."  <c-g>                --  show current document name\n"
    \."  I                    --  show mime headers of current document\n"
    \."  i                    --  show url of link under cursor\n"
    \."  <visual>d            --  remove selected documents from memory cache\n"
    \."                           (only valid in the selection windows)\n"
    \."  <f1>                 --  this help text (leave this list with [,.iq]\n"
    \."  q                    --  quit and delete temporary buffer\n"
    \."                           (the history will be kept)\n"
    \."\n"
    \."nodes can also be entered directly with the :Http command\n"
    \."    :Http http://localhost/\n"
    \."use :Vhttp for splitting vertically\n"
    0put=help
    syn match  httpHelpHeader  +^\[-- \(navigation\|query\) --\]$+
    syn match  httpHelpHeader  +:\(Vh\|H\)ttp+
    syn match  httpHelpSpecial +^\s\+.\{-}\s*--+he=e-3
    hi! link httpHelpHeader   Comment
    hi! link httpHelpSpecial  Special
endfun

" [-- display help text --]
fun! HttpHelp()
    if '' == g:http_context
	call HttpDisplay('call HttpHelpCallback()', 'help')
    else
	call HttpRedisplay()
    endif
endfun

" [-- display a list of cached (visited) buffers --]
fun! HttpListSetup()
    if '' == g:http_context
	call HttpDisplay('python vim.current.buffer.append(pages.urls())', 'select')
	call HttpPlaceArrow()
    else
	call HttpRedisplay()
    endif
endfun

" [-- display the history list --]
fun! HttpHistoryListSetup()
    if '' == g:http_context
	call HttpDisplay('python vim.current.buffer.append(pages.history())', 'select')
	call HttpPlaceArrow()
    else
	call HttpRedisplay()
    endif
endfun

" [-- go back --]
fun! HttpBack()
    call HttpDisplay('python vim.current.buffer.append(pages.back('.winwidth(0).'))', '')
endfun

" [-- go forward --]
fun! HttpForward()
    call HttpDisplay('python vim.current.buffer.append(pages.forward('.winwidth(0).'))', '')
endfun

" vim:set ts=8 sw=4 fdm=indent
