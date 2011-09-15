" Author:	Ron Aaron (Moss Bay Engineering)
" Email:	[SMTP:v-ronaar@Exchange.Microsoft.com]
" Sent: 	Thursday, 30 July 1998 2:24

" Subject: 	Yet another set of coolness: Grep function
" 
" Hi all,
" 
" As cool as the new :grep function is, I find it doesn't work as I would
" like.  So I spiffied up my former way of doing this so that:
" 	1) F3 does 'lid' on the <cword>, S-F3 prompts for what to 'lid'
" 	2) F4 does 'grep' on the <cword>, S-F4 prompts...
" 	3) after lid or grep, the results are put in a split window, where
" they are syntax-highlighted such that the searched-for text is in the
" 'Search' color
" 	4) In the 'grep' window, dbl=clicking on a line takes you to the
" line in the file in question; so does ENTER.
" 	5) 'grep' windows are deleted when closing vim
" 
" Advantages of doing this:
" 	1) you can see at a glance what was found
" 	2) you can manipulate the list, say :g/Bogus/d to remove bogus
" entries 
" 	3) you can save the list or copy to the clipboard or whatever
" 
" Enjoy!

aug GrepBuf
au!
au BufEnter Grep!* call GrepEnterBuf()
au BufLeave Grep!* call GrepLeaveBuf()
au VimLeave Grep!* :bd
au BufEnter greps* if match(getline(1),"GREPTERM")==0
au BufEnter greps* 	let b:searchterm=strpart(getline(1),10,80)
au BufEnter greps* endif
"if match(getline(1),"GREPTERM")==0 \| let b:searchterm=strpart(getline(1),10,80) \| endif
au BufEnter greps* call GrepEnterBuf()
au BufLeave greps* call GrepLeaveBuf()
au VimLeave greps* :bd

au BufRead Greps!* 0,%d
au BufRead Greps!* 0 read $home/greps
au BufRead Greps!* set nomod
au BufNewFile Greps!* 0,%d
au BufNewFile Greps!* 0 read $home/greps
au BufNewFile Greps!* set nomod
aug END

" F3 is for lid
"map <f3> :call Grep(0,1)<cr>
"map <s-f3> :call Grep(1,1)<cr>

" F3 IS for rg
map <f3> :call GrepProg(0,2,0)<cr>
map <s-f3> :call GrepProg(1,2,0)<cr>
vmap <F3> "gy:call Grep(escape(@g,'\\*&\|'),'rg ')
map <m-f3> :call GrepProg(0,2,1)<cr>
map <m-s-f3> :call GrepProg(1,2,1)<cr>

let GrepWinMax=20
let GrepWinMin=5

" assume curbuf is a grep output.
func! GrepEditFile()
	let curline = getline(".")
	" format is ^....:nnnn:.....
	let matchstart = match(curline, ':\d\+:')
	if matchstart >= 0
		let matchend = matchend(curline, ':\d\+:')
		let pos = strpart(curline, matchstart+1, (matchend-matchstart)-2)
		let fname = strpart(curline, 0, matchstart)
			
		let term=b:searchterm
		if winheight(winnr()+1) < 0
		  exe "normal \<c-w>s"
		endif
		if (g:GrepWinMin>0)
		  exe "normal ".g:GrepWinMin."\<c-w>_"
		endif
		exe "normal \<c-w>w"
		exe 'edit +'.pos.' '.fname
		exe 'syntax match GrepFind /'.term.'/'
	endif
endfunc

func! GrepEnterBuf()
	" map <enter> to edit a file, also dbl-click
	nmap <cr> :call GrepEditFile()<cr>
	nmap <2-LeftMouse> :call GrepEditFile()<cr>
	let height=winheight(".")
	if g:GrepWinMin > 0 && height < g:GrepWinMin 
	  exe "normal ".g:GrepWinMin."\<c-w>_"
	endif

	if has("syntax")
		syn clear
		syntax match GrepLineNr /:\d\+:/ms=s+1,me=e-1
		syntax match GrepFile /^[^:]*:\d/me=e-2
		if exists("b:searchterm")
		  exe 'syntax match GrepFind /' . b:searchterm . '/'
		endif
		syntax match GrepRest /^.*$/ contains=GrepLineNr,GrepFile,GrepFind
		highlight GrepFile guifg=Maroon
		highlight GrepRest guifg=MidnightBlue
		highlight GrepLineNr guifg=darkGreen
		highlight link GrepFind Search
	endif
endfunc

func! GrepLeaveBuf()
	unmap <cr>
	unmap <2-LeftMouse>
endfunc

" grep based upon parameters:
func! GrepProg (prompt, lid, chdir)
	if (a:chdir)
	  let curdir=getcwd()
	  cd %:p:h
	endif
	if (a:lid == 1)
		let grep = "lid -R grep "
	elseif ( a:lid == 0 )
		let grep = expand("$binw")."/grep -n "
	else
	    let grep = "rg "
	endif
	if (a:prompt)
		let searchtext = input("search for: ")
	else
		let searchtext = expand('<cword>')
	endif
	if a:lid==0 && !a:prompt
		let searchtext = searchtext . ' *.c *.h *.cpp *.hpp *.rc *.rh'
	endif
	call Grep( escape(searchtext,'\\^$*.'), grep )
	if (a:chdir)
	  exe "cd ".curdir
	endif
endfunction

func! Grep( searchtext, grep )
	if a:searchtext == ''
	  echo "<cancelled>"
	  return
	endif 
	let searchtext=a:searchtext
	" make searchtext into an ok file name:
	let searchtitle = substitute(searchtext, "[ \t\*\?]", "", "g")
	" the search term is a bit more interesting: remove *.cpp, for instance:
	"let searchterm = substitute(searchtext, '\s*[\*\?]\S\+', "", "g")
	let searchterm = substitute(searchtext, '[ 	.]','_','g')
	" remove quotes
	let searchterm = substitute(searchterm, '"', "", "g")
	let b:searchterm=searchterm
	" so do it already:
	if a:grep != 'rg '
	  exe 'new Grep!' . searchtitle
	  exe "normal iPress ENTER or dbl-click the mouse on a line to edit that file \<esc>"
	  exe 'syntax match GrepFind /' . searchterm . '/'
	  exe 'read ! ' . a:grep . searchtext
	  2	
	else
	  let winnum=-1
	  let win=1
	  while winheight(win)>-1 && winnum==-1
		if bufname(winbufnr(win))=~"Greps!.*"
		  let winnum=win
		endif
		let win=win+1
	  endwhile
	  exe '!sh rg '.searchtext
	  if winnum==-1
		exe 'new Greps!'.searchtitle
	  else
		exe "normal ".winnum."\<c-w>w"
		exe 'edit Greps!'.searchtitle
	  endif
	  2
	endif
	set nomod
	if g:GrepWinMax > 0 
	  exe "normal ".g:GrepWinMax."\<c-w>_"
	endif
endfunc
