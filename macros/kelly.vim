" Functions
" Allan Kelly <akelly@holyrood.ed.ac.uk>
" Re: Commenting text
" -------------------
"
" Please note that you must use line-wise highlight for these functions.
" In my .vimrc, i have:
"
" source $VIM/al_funcs.vim
" autocmd BufNewFile,BufRead,BufEnter *.html vmap .c :call CommentifyHTML(1)<CR>
" autocmd BufNewFile,BufRead,BufEnter *.html vmap ,c :call CommentifyHTML(0)<CR>
" autocmd BufNewFile,BufRead,BufEnter *.c,*.cpp,*.h vmap .c :call CommentifyC(1)<CR>
" autocmd BufNewFile,BufRead,BufEnter *.c,*.cpp,*.h vmap ,c :call CommentifyC(0)<CR>
"
" Also you might find the following useful:
"
" vmap \a :call AlignThingy()<CR>
"
" Hope it helps someone.
" al.
"

" vi: set sw=2 sts=2 et:
fu! InsertLine ( linenum, linestring )
    exe 'normal' . ":" . a:linenum . "insert\<CR>" . a:linestring . "\<CR>.\<CR>"
endf

fu! AppendLine ( linenum, linestring )
    exe 'normal' . ":" . a:linenum . "append\<CR>" . a:linestring . "\<CR>.\<CR>"
endf

fu! SubstLine ( linenum, pat, rep, flags )
    let thislineStr = getline( a:linenum )
    let thislineStr = substitute( thislineStr, a:pat, a:rep, a:flags )
    call setline( a:linenum, thislineStr )
endf

" Note! expandtab and retab are used here, this could potentially alter
" whitespace in strings, which will seem very mysterious!
" TODO: This business with TABs may cause problems, where the indenting of
" decommented text may not exactly match the pre-commented indents. Debug this
" if + when it happens.
fu! Commentify ( b_comment, opencomm, closecomm, midcomm, firstln, lastln )
    let originaletvalue = &expandtab
    if a:b_comment
        " First, get a string of spaces for indent.  This is a problem when noet
        " is set, because a literal match does not match tabs to spaces.
        " Solutions: either find a clever substitute syntax to do the job, or
        " manually expand tabs or use 'set et' and 'retab'.
	" Solution:
	exe 'set et'
	exe a:firstln . "," . a:lastln . "retab"
	" END Solution
	let midline = a:firstln
	let indentStr = getline ( midline )
	while midline <= a:lastln
	    let indentStrLen = strlen ( indentStr )
	    let midlnStr = getline ( midline )
	    " As long as the line's not empty, get indent
	    "if ( !matchstr ( midlnStr, "^[ ]*$" ) )
	    if ( !( midlnStr =~ "^[ ]*$" ) )
		let newindentStr = matchstr ( midlnStr, "^[ ]*" )
		if strlen ( newindentStr ) < indentStrLen
		    let indentStrLen = strlen ( newindentStr )
		    let indentStr = newindentStr
		endif
	    endif
	    let midline = midline + 1
	endwhile
	
	let midline = a:firstln
	while midline <= a:lastln
	    call SubstLine ( midline, '^' . indentStr . '\(.*\)$', indentStr . a:midcomm . '\1', "" )
	    let midline = midline + 1
	endwhile
	call InsertLine ( a:firstln, indentStr . a:opencomm )
	let lastline = a:lastln + 1
	call AppendLine ( lastline, indentStr . a:closecomm )
    else
	exe 'set et'
	exe a:firstln . "," . a:lastln . "retab"
	if ( originaletvalue == 0 )
	    exe 'set noet'
	endif

	let opencommMatch = escape ( a:opencomm, '*.' )
	let opencommMatch = substitute( opencommMatch, '\s', '\\s\\=', "g" )
	let closecommMatch = escape ( a:closecomm, '*.' )
	let closecommMatch = substitute( closecommMatch, '\s', '\\s\\=', "g" )
	let midcommMatch = escape ( a:midcomm, '*.' )
	let midcommMatch = substitute( midcommMatch, '\s', '\\s\\=', "g" )
	
	let firstlnStr = getline(a:firstln) 
	if ( firstlnStr =~ '^\s*' . opencommMatch . '\s*$' )
	    " We're at the top of a block. Remove the line.
	    exe 'normal dd'
	    let firstline = a:firstln
	    let lastline = a:lastln - 1
	elseif ( firstlnStr =~ '^\s*' . opencommMatch )
	    " We're at the top of a block. Remove the comment-start.
	    call SubstLine ( a:firstln,  opencommMatch, "", "" )
	    let firstline = a:firstln
	    let lastline = a:lastln
	elseif ( firstlnStr =~ '^\s*' . midcommMatch )
	    " We're in the middle of a block. Add a block-end above and uncomment 
	    " this line.
	    let midlnStr = getline ( a:firstln )
	    let indentStr = matchstr ( midlnStr, "^[ 	]*" )
	    call InsertLine ( a:firstln, indentStr . a:closecomm )
	    call SubstLine ( a:firstln + 1,  midcommMatch, "", "" )
	    let firstline = a:firstln + 2
	    let lastline = a:lastln + 1
	else
	    " Something weird. Abort.
	    echohl Warning Msg | echo "Couldn't apply uncomment." | echohl None
	    return -1
	endif
	
	if ( a:firstln == a:lastln )
	    " Either we're in the middle of a block, or this is a one-line comment.
	    let lastlnStr = getline( lastline )
	    if ( lastlnStr =~ closecommMatch . '\s*$' )
		" one-line comment
		call SubstLine ( lastline, closecommMatch, "", "" )
		return 0
	    else
		" mid-block - I assume that the user wants just this line
                " uncommented, so we've added a close comment above and and now
                " add an open comment below.
		call AppendLine ( lastline, indentStr . a:opencomm )
		return 0
	    endif
	else
	    let midline = firstline
	    while midline < lastline
		let midlnStr = getline(midline)  
		if !( midlnStr =~ closecommMatch )
		    call SubstLine ( midline, midcommMatch, "", "" )
		endif
		let midline = midline + 1
	    endwhile
	endif
	
	let lastlnStr = getline(lastline)    
	if ( lastlnStr =~ '^\s*' . closecommMatch . '\s*$' )
	    " We're at the end of a block. Remove the line.
	    exe 'normal' . lastline . 'G'
	    exe 'normal dd'
	elseif ( lastlnStr =~ '^\s*' . midcommMatch )
	    " We're in the middle of a block. Add a block-start below and uncomment
	    " this line.
	    call AppendLine ( lastline, a:opencomm )
	    call SubstLine ( midline, midcommMatch, "", "" )
	else
	    " Proly the user went past the end of the commented block.
	    let midline = firstline
	    while midline <= lastline
		let midlnStr = getline(midline)  
		if ( midlnStr =~ '^\s*' . closecommMatch . '\s*$' )
		    " We're at the end of a block. Remove the line.
		    exe 'normal' . midline . 'G'
		    exe 'normal dd'
		    return 0
		elseif ( midlnStr =~ closecommMatch . '\s*$' )
		    " comment close at EOL
		    call SubstLine ( midline, closecommMatch, "", "" )
		    return 0
		endif
		let midline = midline + 1
	    endwhile
	endif
    endif
    " restore expandtab setting, if necessary
    if ( originaletvalue == 0 )
	exe 'set noet'
	" this range could be inaccurate, but so what? it's only a retab.
	exe a:firstln . "," . lastline . "retab!"
    endif
endf

fu! CommentifyC ( b_comment ) range
    let opencomm  = "/*"
    let closecomm = " */"
    let midcomm    = " *  "
    call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline )
endf

fu! CommentifyHTML ( b_comment ) range
    let opencomm  = "<!--"
    let closecomm = "  -->"
    let midcomm    = "	      "
    call Commentify ( a:b_comment, opencomm, closecomm, midcomm, a:firstline, a:lastline )
endf

fu! WordCount2 ( ) range
    let thisline = a:firstline
    let g:report = 0
    normal :%s/\i\+/&/g
    let resultstr = g:report . " words found"
    call confirm( resultstr, "OK" )
    return g:report
endf

fu! WordCount ( ) range
    let thisline = a:firstline
    let wordcount = 0
    while thisline <= a:lastline
	let thislineStr = getline ( thisline )
	let thislineStr = substitute( thislineStr, '\<[a-zA-Z_0-9-]\+\>', '_', "g" )
	let thislineStr = substitute( thislineStr, "[^_]", "", "g" )
	let thiscount = strlen( thislineStr )
	let wordcount = wordcount + thiscount 
	let thisline = thisline + 1
    endwhile
    let resultstr = wordcount . " words counted"
    call confirm( resultstr, "OK" )
    echo resultstr
    return count
endf

fu! HTMLTable ( ) range
    let firstln = a:firstline
    let lastln = a:lastline
    call InsertLine ( firstln, '<tr><td>' )
    call InsertLine ( firstln, '<table border=0 width=575>' )
    let firstln = firstln + 2
    let lastln = lastln + 2
    call AppendLine ( lastln, '</table>' )
    call AppendLine ( lastln, '</td></tr>' )


    let thisln = firstln
    while ( thisln <= lastln )
	let thislnStr = getline ( thisln )
	if ( thislnStr =~ '^\s*$' )
	    if ( thisln != lastln )
		call SubstLine ( thisln, '.*', '</td></tr>', "" )
		call AppendLine ( thisln, '<tr><td>' )
		let lastln = lastln + 1
		let thisln = thisln + 1
	    endif
	else
	    call SubstLine ( thisln, '.*', '	&', "" )
	endif
	let thisln = thisln + 1
    endwhile
endf

fu! HTMLBody ( ) range
    let firstln = a:firstline
    let lastln = a:lastline
    call InsertLine ( firstln, '<BODY bgcolor=#a0ffe0 alink=#ff0000 vlink=0000ff link=#00ff00>' )
    call InsertLine ( firstln, '<HTML>' )
    call InsertLine ( firstln, '</TITLE></HEAD>' )
    call InsertLine ( firstln, '<HEAD><TITLE>' )
    let firstln = firstln + 4
    let lastln = lastln + 4
    call AppendLine ( lastln, '</HTML>' )
    call AppendLine ( lastln, '</BODY>' )
endf

fu! AlignCommentsC ( ) range
    let opencomm = '/\*'
    call AlignComments (opencomm, a:firstline, a:lastline )
endf

fu! AlignCommentsCpp ( ) range
    let opencomm = '//'
    call AlignComments (opencomm, a:firstline, a:lastline )
endf

fu! AlignCommas ( ) range
    let opencomm = ','
    call AlignComments (opencomm, a:firstline, a:lastline )
endf

" This general-purpose function must escape it's arguments carefully.
fu! AlignThingy (...) range
  " Deal with TABs
  let originaletvalue = &expandtab
  exe 'set et'
  exe a:firstline . "," . a:lastline . "retab"
  
  if (a:0 == 0)
    let alignchar = input("Input align character: ")
  else
    let alignchar = a:1
  endif

  let alignchar = escape( alignchar, ".*[^$" )
  call AlignComments (alignchar, a:firstline, a:lastline )

  if ( originaletvalue == 0 )
      exe 'set noet'
      exe a:firstline . "," . a:lastline . "retab!"
  endif
endf

" Originally for Comment alignment, this function is actually general-purpose
fu! AlignComments (opencomm, firstln, lastln )
    let opencomm = a:opencomm
    let midln = a:firstln
    let lastln = a:lastln
    let maxcol = 0
    let newcol = 0
    " find the most indented comment
    while midln <= lastln
	let midlnStr = getline(midln)  
	let newcol = match ( midlnStr, opencomm )
	if newcol > maxcol
	    let maxcol = newcol
	endif
	let midln = midln + 1
    endwhile

    let midln = a:firstln
    while midln <= lastln
	let midlnStr = getline(midln)  
	let curcol = match ( midlnStr, opencomm )
	let spaces = maxcol - curcol
	let spaceStr = ""
	while spaces > 0
	    let spaceStr = spaceStr . " "
	    let spaces = spaces - 1
	endwhile
	call SubstLine ( midln, opencomm, spaceStr . '&', "" )
	let midln = midln + 1
    endwhile
endf
" This function adapted from vim discussion by Michael Geddes
" <mgeddes@cybergraphic.com.au> and 'Siew Kam Onn' <KOSIEW@MY.oracle.com>
" It requires a .vimrc entry:
" au BufWrite * call StampFileEditTime()
function! StampFileEditTime()
    let pat = '^\(.*Last edit:\)[0-9a-zA-Z:, ]*\(.*\)'
    let rep = '\1 '.strftime('%Y %b %d, %X').'\2'
    " Try the first 5 lines
    let lineno = 0
    while lineno <= 5
	call SubstLine (lineno,pat,rep,"")
	let lineno = lineno + 1
    endwhile
    " Try the last line
    let lineno = line("$")
    call SubstLine (lineno,pat,rep,"")
endfunction

