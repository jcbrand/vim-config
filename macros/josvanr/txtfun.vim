" **txtfun.vim**
"
" Obsolete.
"
" ----------------------------------------------------------------------------- 
if !exists("_txtfun_vim_sourced")
let _txtfun_vim_sourced=1
" ----------------------------------------------------------------------------- 

" Move cursor to column n
function! ToCol(colnr)
  let colnr=a:colnr
  if colnr<1
    let colnr=1
  endif
  execute("normal ".colnr."|")
endfunction

" Move cursor to line n
function! ToLine(linenr)
  let linenr=a:linenr
  if linenr=="$"
    let linenr=line("$")
  endif
  let oldcol=col(".")
  execute(": ".linenr)
  call ToCol(oldcol)
endfunction

" Move cursor to col and line
" function! ToXY(colnr, linenr)
"   call ToLine(a:linenr)
"   call ToCol(a:colnr)
" endfunction

" Return last column in line, 0 if line empty
function! LastCol()
  let str=getline(".")
  let N=strlen(str)
  return N
endfunction

" Return 1 if line consists only of spaces
function! OnlySpaces(...)
  if a:0==0
    let str=getline(".")
  else
    let str=getline(a:1)
  endif
  let N=strlen(str)
  if N==0
    return 0
  elseif str==StrNTimesChar(" ",N)
    return 1
  else
    return 0
  endif
endfunction

" Return 1 if line empty, else 0
function! LineEmpty(...)
  if a:0==0
    let str=getline(".") 
  else
    let str=getline(a:1)
  endif
  if strlen(str)==0
    return 1
  else
    return 0
  endif
endfunction

" Return 1 if no non-space charakters on line
function! LineFree()
  if OnlySpaces()||LineEmpty()
    return 1
  else
    return 0
  endif
endfunction

" Print the string in the filename after linenr. 
" Linenr="$": print after last line.
" How to suppress messages?
" function! PrintLineAfterFile(filename,linenr,string)
"   let filename=a:filename
"   let linenr=a:linenr
"   let string=a:string
"   let oldbuf=bufnr("%")
"   execute "e!".filename
"   call ToLine(linenr)
"   call PrintLineAfter(string)
"   execute "w!"
"   execute "bd!"
"   execute "b".oldbuf
" endfunction

" Replace text on current line with string str
function! PrintLineOver(str)
  let @z=a:str
  normal 0d$"zp0
endfunction

" Insert new empty line before/after 
" and leave cursor on new line
function! InsLineBefore()
  execute("normal O"."\e")
endfunction

function! InsLineAfter()
  execute("normal o"."\e")
endfunction

" Print line before the current line
function! PrintLineBefore(str)
  call InsLineBefore()
  let @z=a:str
  normal "zp
endfunction

" arguments: str, linenr or str
" leave cursor at old position if you specify a line,
" leave cursor on new line if you don't specify a line
function! PrintLineAfter(...)
  if a:0==1
    let str=a:1
    let linenr=line(".")
    let goback=0
  else
    let str=a:1
    let linenr=a:2
    let goback=1
  endif
  let oldline=line(".")
  call ToLine(linenr)
  call InsLineAfter()
  let @z=str
  normal "zp
  if goback
    call ToLine(oldline)
  endif
endfunction
"
function! DeleteLine(n)
  let n=a:n
  let l=line(".")
  let c=col(".")
  if (n>=1)&&(n<=line("$"))
    call ToLine(n)
    execute "normal dd"
  endif
  if n<l
    let l=l-1
  endif
  call ToLine(l)
  call ToCol(c)
endfunction

" Go to the next instance of str
function! FindGotoStr(str)
  let str=a:str
  execute("normal /".str."\n")
endfunction

" Go to the next instance of str
function! FindPrevGotoStr(str)
  let str=a:str
  execute("normal ?".str."\n")
endfunction

" Insert a word before cursor (use a space at each side)
" leave cursor at beginning of word
function! InsertWord(word)
  let str=getline(".")
  let Nc=col(".")
  let word=a:word
  let char=GetChar()
  if (Nc==1)||(LineFree())
    let pre=""
  elseif Nc>1 
    if StrChar(str,Nc-2)==" "
      let pre=""
    else 
      let pre=" "
    endif
  else
    let pre=" "
  endif
  if (Nc==LastCol())||(char==" ")||(LineFree())
    let post=""
  else
    let post=" "
  endif
  let insstr=pre.word.post
  call PrintLineOver(StrInsert(str,insstr,Nc-1))
  let cstartnew=Nc+strlen(pre)
  call ToCol(cstartnew)
endfunction

function! AppendWord(word)
let word=a:word
if word!=""
  let curcol=col(".")
  if LastCol()
    let str=getline(".")
    let str=str." "
    call PrintLineOver(str)
  endif
  call ToCol(curcol)
  normal e
  normal l
  call InsertWord(word)
  let curcol=col(".")
endif
endfunction

" Ins. one or N spaces at position of cursor 
function! InsertSpace(...)
  if a:0==0
    let N=1
  else
    let N=a:1 
  endif
  let Nc=col(".")
  let nc=Nc-1
  let oldstr=getline(".")
  let newstr=StrInsert(oldstr,StrNTimesChar(" ",N),nc)
  call PrintLineOver(newstr)
  call ToCol(Nc)
endfunction

" Return character under cursor
function! GetChar()
  let str=getline(".")
  if strlen(str)==0
    return ""
  else
    " 1st column=1
    let col=col(".")
    let n=col-1
    return StrChar(str,n)
  elseif
endfunction

" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
