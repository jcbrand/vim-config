" Date sent:      	Fri, 12 Feb 1999 17:23:14 -0800
" From:           	Jim Battle <jb@chromatic.com>
" Subject:        	Re: Cycle through active marks? [script included]
" 
" OK, I went and assumed that you really want to find the next
" mark after the current position, and written a function to navigate
" this way.  I've added a couple bells & whistles.  The function
" obeys the "wrapscan" setting just like a normal search.  Even
" if wrapscan is set, it echos a status line warning to tell you
" that the search wrapped around past the end of the file.  On the
" other hand, searches only go forward in the file; I didn't bother
" making it be able to navigate backwards too.
" 
" I've tested it on sun solaris and on win95 using vim 5.3.  The only
" problem I see is that for some reason, the informative echo commands
" telling you which mark you've jumped to sometimes get erased.  If
" anyone has any clues, please let me know.
" 
" Here then is the script.  Save it as a file named "nextmark.vim".
" From a vim session, just do a "source nextmark.vim".  After that,
" hitting ";" jumps you to the next mark.  If you want to change the
" mapping to another key or key sequence, change the last line of
" the script.
" 
" You might also want to change the highlighting class to use when
" informational messages are produced.

function! Nextmark()

  let curline = line(".")
  let curcol  = col(".")

  let minmark = ""
  let minline = 10000000
  let mincol  = 0

  let nextmark = ""
  let nextline = 10000000
  let nextcol  = 0

  let imark = char2nr("a")
  let emark = char2nr("z")

  while (imark <= emark)

    let mark = nr2char(imark)
    let imark = imark+1
    let markline = line("'".mark)

    " check for invalid mark
    if markline == 0
      continue
    endif
    let markcol = col("'".mark)

    " save off the first mark in the file
    " process only one mark if more than one are identically positioned
    if markline < minline || (markline == minline && markcol < mincol)
      let minmark = mark
      let minline = markline
      let mincol  = markcol
    endif

    " see if the mark is after the current cursor position
    if markline > curline || (markline == curline && markcol > curcol)
      " save the earliest such mark
      " process only one mark if more than one are identically positioned
      if markline < nextline || (markline == nextline && markcol < nextcol)
        let nextmark = mark
        let nextline = markline
        let nextcol  = markcol
      endif
    endif

  endwhile

  if minmark == ""
    echohl ErrorMsg
    echo "No marks set"
    echohl Normal
    return
  endif

  if nextmark == ""
    if &wrapscan
      exec ":normal `".minmark
      echohl Search
      echo "Wrapped: Jumped to mark " . minmark
      echohl Normal
      return
    endif
    echohl Search
    echo "search hit BOTTOM without finding any marks"
    echohl Normal
    return
  endif

  exec ":normal `".nextmark
  echo "Jumped to mark " . nextmark

endfunction

map ;; :call Nextmark()<CR>

