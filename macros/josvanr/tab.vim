" **tab.vim**
" 
" FUNCTIONS:
" 
" :call I()<cr>@a
" 
"   Go back to the previous insert. When leaving insert mode, the line 
"   and column are stored. I() stores a command for returning to the line
"   and column, and the proper insert command ("i" or "a" depending on
"   the line length) in register a. To go back to insert mode, issue @a.
" 
" let n=NAlignLeft(mode,alignpatt)
" 
"   Calculate the number of positions to shift a word in order to align
"   it with another word. 
" 
"   Eg:
" 
"           test
"        test
"        ^------------>the cursor, in normal mode
" 
"   NAlignLeft("n",tab_rightprev) = 3 is the number of spaces to insert 
"   in front of the second test, to align it with the first test, on the 
"   right of the second test.
" 
"   tab_rightprev is a search pattern, finding the start of the first word
"   on the right of the cursor, on the first previous non-empty line.
"   tab_rightnext is the same for the next non-empty line.
" 
"   If you want to use the cursor position as it was in insert mode, 
"   exit   insert mode with _esc-, and say NAlignLeft("i",tab_rightprev)
" 
" MAPS:
" 
"   ,t            Insert spaces to align the cursor with the word on 
"                 the previous line.
"   ,T            Same for the word on the next line.
" 
" -----------------------------------------------------------------------------
imap ,t _esc-:call Tab("i",tab_rightprev)<cr>:call I()<cr>@a
imap ,T _esc-:call Tab("i",tab_rightnext)<cr>:call I()<cr>@a
" -----------------------------------------------------------------------------
if !exists("_tab_vim_sourced")
let _tab_vim_sourced=1
" -----------------------------------------------------------------------------
so ~\strfun.vim

ino _esc- Tt<esc>FT:let g:icol=col(".")\|let g:iline=line(".")<cr>dft:ec<cr>

let tab_rightprev="-\\(\\s\\|\\>\\)\\<"
let tab_rightnext="+\\(\\s\\|\\>\\)\\<"

fu! Tab(mode,ap)
  let n=NAlignLeft(a:mode,a:ap)
  let sp=StrNTimesChar(" ",n)
  call I()
  exe "normal @a".sp."_esc-"
endf

fu! I()
  exe g:iline."norm ".g:icol."|"
  if g:icol<=strlen(getline("."))
    let @a="i"
  el
    let @a="a"
  en
endf

fu! NAlignLeft(mode,alp)
  let step=(strpart(a:alp,0,1)=="+")*2-1
  let ap=strpart(a:alp,1,strlen(a:alp))
  if a:mode=="i"
    let i=g:iline+step|let c=g:icol
  else
    let i=line(".")+step|let c=col(".")
  end
  let m=-1
  if step>0
    let I=line("$")
    wh (i<=I)&&(m<0)
      let str=getline(i)
      let m=match(strpart(str,c-1,strlen(str)),ap)
      let i=i+1
    endwh
  else
    wh (i>=1)&&(m<0)
      let str=getline(i)
      let m=match(strpart(str,c-1,strlen(str)),ap)
      let i=i-1
    endwh
  end
  return m+1
endf
" -----------------------------------------------------------------------------
endif
" -----------------------------------------------------------------------------
