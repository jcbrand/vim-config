" Error window.

" Email:	[SMTP:v-ronaar@Exchange.Microsoft.com]

" Author:  	Michael Geddes
" Email: 	[SMTP:mgeddes@cybergraphic.com.au]

" Thanks to Ron Aaron (Moss Bay Engineering) for the orginal 'Grep Function'

" Reading the PseudoFile 'Errs!' causes 'errors.raw' to be read. (Do this
" however you want.. this is my own preference).

" Double-Clicking or pressing Enter on an entry causes the buffer below the error
" window to jump to the file/linenumber you require. (If none exist, the one is
" opened)

" When selecting an error line the error window then becomes the size
" 'ErrWinMin'. When clicking on the errors window, the window expands to at
" least 'ErrWinMax'

" Calling  ErrorLoad()  causes the error file to be opened or if a buffer
" already exists, it causes the buffer to be re-read.

" This is set up for Borland.  I haven't made it really generic yet.  (It Hides
" Borland header messages and hilights NOTE: as a todo.  This is what we use to
" prefix #pragma message()  commands so that we can distinguish them from
" genuine warnings.

aug ErrBuf
au!
au BufEnter Errs!* call ErrorEnterBuf()
au BufLeave Errs!* call ErrorLeaveBuf()
au VimLeave Errs!* :bd

au BufRead Errs!* 0,%d
au BufRead Errs!* 0 read errors.raw
au BufRead Errs!* set nomod
au BufNewFile Errs!* 0,%d
au BufNewFile Errs!* 0 read errors.raw
au BufNewFile Errs!* set nomod
aug END

" F3 IS for rg
map <c-s-e> :call ErrorLoad()<CR>
"map <s-f3> :call Grep(1,2)<cr>

let ErrWinMax=20
let ErrWinMin=5

" assume curbuf is a grep output.
func! ErrorEditFile()
	let curline = getline(".")
	" format is ^Warning <filename> nnnn:.....
	" 			^Error <filename> nnnn:.....
	let matchstart = match(curline, ' \d\+:')
	if matchstart >= 0
		let matchend = matchend(curline, ' \d\+:')
		let pos = strpart(curline, matchstart+1, (matchend-matchstart)-2)
		let matchbeg = matchend(curline, '^[^ ]\+ ')
		let fname = strpart(curline, matchbeg, matchstart-matchbeg)
			
		let editn='edit'
		if (g:ErrWinMin>0)
		  exe "normal ".g:ErrWinMin."\<c-w>_"
		endif
		if winheight(winnr()+1) < 0
		  exe "normal \<c-w>s"
		endif
		exe "normal \<c-w>w"
		exe 'edit +'.pos.' '.fname
	endif
endfunc

func! ErrorEnterBuf()
	" map <enter> to edit a file, also dbl-click
	nmap <cr> :call ErrorEditFile()<cr>
	nmap <2-LeftMouse> :call ErrorEditFile()<cr>
	let height=winheight(".")
	if g:ErrWinMin > 0 && height < g:ErrWinMin 
	  exe "normal ".g:ErrWinMin."\<c-w>_"
	endif

	if has("syntax")
		syn clear
		syntax match ErrorLineNr / \d\+:/ms=s+1,me=e-1
		syntax match ErrorFile /^Error [^ :]*[ :]/ms=s+6,me=e-1
		syntax match WarningFile /^Warning [^ :]*[ :]/ms=s+8,me=e-1
		syntax match WarningNote /NOTE:/ nextgroup=WarningRest
		syntax match ErrorRest /^Error .*$/ contains=ErrorLineNr,ErrorFile
		syntax match WarningRest /^Warning .*$/ contains=ErrorLineNr,WarningFile
		syntax match NoteRest /^Warning .*NOTE:.*$/ contains=ErrorLineNr,WarningFile,WarningNote
		syntax region NoteWarningMsg start='"' end='"'
		syntax region NewWarningNote start=/NOTE(/ end=')' contains=NoteWarningMsg
		syntax match NoteRest /^Warning .*NOTE(.*$/ contains=ErrorLineNr,WarningFile,NewWarningNote
		syntax match GroupFile	/^[^:]*:$/
		syntax match BorlandHide /^.*Borland.*$/

		highlight BorlandHide guifg=Sys_Window
		highlight GroupFile guifg=Blue gui=bold
		highlight ErrorFile guifg=Maroon
		highlight WarningFile guifg=Maroon
		highlight ErrorRest guifg=Red
		highlight WarningRest guifg=MidnightBlue
		highlight NoteRest guifg=GoldenRod
		highlight ErrorLineNr guifg=darkGreen
		highlight WarningNote guifg=MidnightBlue guibg=bisque
		hi link NewWarningNote WarningNote
		highlight NoteWarningMsg guifg=Blue
	endif
endfunc

func! ErrorLeaveBuf()
	unmap <cr>
	unmap <2-LeftMouse>
endfunc

" Load errors
func! ErrorLoad ()
	let errTitle=""

	let winnum=-1
	let win=1
	while winheight(win)>-1 && winnum==-1
	  if bufname(winbufnr(win))=~"Errs!.*"
		let winnum=win
	  endif
	  let win=win+1
	endwhile
	
	if winnum==-1
	  exe 'new Errs!'.errTitle
	  1
	else
	  let lnum=line(".")
	  exe "normal ".winnum."\<c-w>w"
	  exe 'edit Errs!'.errTitle
	  exe lnum
	endif

	set nomod
	if g:ErrWinMax > 0 
	  exe "normal ".g:ErrWinMax."\<c-w>_"
	endif
endfunc

