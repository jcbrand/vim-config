" **strfun.vim**
"
" StrDel(str,n1,n2)     Remove part n1 to n2.
" StrReverse(string)    Reverse characters in string.
" StrFileExt(str)       Return ext of filename.ext.
" StrFileName(str)      Return filename of filename.ext.
" StrChar(string,num)   Return char of string at index num.
" StrLowercase(str)     Make a string lowercase.
" StrUppercase(str)     Make a string uppercase.
" StrNTimesChar(char,N) Return N times the character char.
" StrCut(str,n1,n2)     Return part of str from n1 to n2 (inclusive).
" 
" StrLoad(fn)           Load file into string.
" StrRead("command")    Read output of command into string.
" StrLineN(str,n)       Return line n of str.
" StrSetCol(str,c)     Reduce string width to c.
"
" Todo:
"
" StrNLines(str)        Return number of lines in str.
" ----------------------------------------------------------------------------- 
" if !exists("_strfun_vim_sourced_")
" let _strfun_vim_sourced_=1
" ----------------------------------------------------------------------------- 

fu! StrSetCol(str,c)
  let str=a:str
  let nl=strlen(str)
  let nstr=""
  let n=matchend(str,"\n")
  let i=1|wh n>-1
    if n<a:c
      let cut=n
    else 
      let cut=a:c
    endif
    let nstr=nstr.strpart(str,0,cut-1)."\n"
    let str=strpart(str,n,nl)
    let n=matchend(str,"\n")
  let i=i+1|endwh
  return nstr
endf

fu! StrNLines(str)
  let i=0
  let str=a:str
  let l=strlen(str)
  let n=match(str,"\n")
  wh n>-1
    let n=match(str,"\n")
    let str=strpart(str,n+1,l)
    let i=i+1
  endwh
  return i+1
endf

fu! StrLoad(fn)
  set ch=7
  let bn=bufnr("%")
  exe "w!|e ".a:fn
  norm ggVG"zy
  exe "bd!|b ".bn
  set ch=1
  return @z
endf

fu! StrRead(com)
  set ch=7
  let bn=bufnr("%")
  let temp=tempname()
  exe "w!|e ".temp
  exe "r!".a:com
  norm ggVG"zy
  exe "bd!|b ".bn
  if filereadable(temp)
    exe delete(temp)
  end
  set ch=1
  return @z
endf

" function! StrDel(str,n1,n2)
"   let n=strlen(a:str)-1
"   let pre=StrCut(a:str,0,a:n1-1)
"   let post=StrCut(a:str,a:n2+1,n)
"   return pre.post
" endfunction

" function! StrReverse(str)                                                     
"   let strout=""                                                               
"   let n=strlen(a:str)-1                                                       
"   let i=0                                                                     
"   while i<=n                                                                  
"     let strout=StrChar(a:str,i).strout                                        
"     let i=i+1                                                                 
"   endwhile                                                                    
"   return strout                                                               
" endfunction                                                                   

function! StrFileExt(str)
  let dot=match(a:str,"\\.")
  if dot==-1
    return ""
  else
    return strpart(a:str,dot+1,strlen(a:str)-1-dot)
  endif
endfunction

function! StrFileName(str)
  let dot=match(a:str,"\\.")
  if dot==-1
    return a:str
  else
    return strpart(a:str,0,dot)
  endif
endfunction

function! StrChar(string,num)
  let Nix=strlen(a:string)-1
  if a:num>Nix
    let char=""
    let errorcode=2
  elseif a:num<0
    let char=""
    let errorcode=1
  else
    let errorcode=0
    let char=strpart(a:string,a:num,1)
  endif
  "errors
  if g:echowarningmessages
    if errorcode==1
      call input("WARNING in StrChar(\"".a:string."\",".a:num."): Index negative.")
    elseif errorcode==2
      call input("WARNING in StrChar(\"".a:string."\",".a:num."): Index too large.")
    endif
  endif
  "
  return char
endfunction

function! StrLowercase(str)
  let n=strlen(a:str)-1
  let strout=""
  if n>=0
    let i=0
    while i<=n
       let chrn=char2nr(strpart(a:str,i,1))
       if (chrn>=65)&&(chrn<=90)
         let strout=strout.nr2char(chrn+32)
       else
         let strout=strout.strpart(a:str,i,1)
       endif
       let i=i+1
    endwhile
  endif
  return strout
endfunction

function! StrUppercase(str)
  let n=strlen(a:str)-1
  let strout=""
  if n>=0
    let i=0
    while i<=n
       let chrn=char2nr(strpart(a:str,i,1))
       if (chrn>=65+32)&&(chrn<=90+32)
         let strout=strout.nr2char(chrn-32)
       else
         let strout=strout.strpart(a:str,i,1)
       endif
       let i=i+1
    endwhile
  endif
  return strout
endfunction

function! StrNTimesChar(char,N)
  let errorcode=0
  if a:N<0
    let nchar=""
    let errorcode=1
  elseif a:char==""
    let nchar=""
    let errorcode=2
  else
    let i=0
    let nchar=""
    while i<a:N
      let nchar=nchar.a:char
      let i=i+1
    endwhile
  endif
  if g:echowarningmessages
    if errorcode==1 
      call input("ERROR in StrNTimesChar(\"".a:char."\",".a:N."): N < 0.")
    elseif errorcode==2 
      call input("ERROR in StrNTimesChar(\"".a:char."\",".a:N."): String is empty.")
    endif
  endif
  return nchar
endfunction

function! StrCut(str,n1,n2)
  let n=strlen(a:str)-1
  if a:n2<a:n1
    let errorcode=-1
    let retval=""
  elseif n<0
    let errorcode=-2
    let retval=""
  elseif a:n1<=-1
    let errorcode=-3
    let retval=strpart(a:str,0,a:n2+1)
  elseif a:n2>n
    let errorcode=-4
    let retval=strpart(a:str,a:n1,n-a:n1+1)
  else
    let retval=strpart(a:str,a:n1,a:n2-a:n1+1)
  endif
  if g:echowarningmessages
    if errorcode==-1
      call input("WARNING in StrCut(\"".a:str."\",".a:n1.",".a:n2."): n2 < n1.")
    elseif errorcode==-2
      call input("WARNING in StrCut(\"".a:str."\",".a:n1.",".a:n2."): String is empty.")
    elseif errorcode==-3
      call input("WARNING in StrCut(\"".a:str."\",".a:n1.",".a:n2."): n1 must be >= 0.")
    elseif errorcode==-4
      call input("WARNING in StrCut(\"".a:str."\",".a:n1.",".a:n2."): n2 exceeds string.")
    endif
  endif
  return retval
endfunction

" Return index where searchstring fits in containerstring, ret -1 if not found
function! StrFind(container,searchstring)
  let war=g:echowarningmessages
  let cs=a:container
  let ss=a:searchstring
  let Ncs=strlen(cs)
  let ncs=Ncs-1
  let Nss=strlen(ss)
  if cs==""
    let retval=-2
  elseif ss==""
    let retval=-3
  elseif Nss>Ncs
    let retval=-4
  else
    let imax=ncs-Nss+1
    let i=0
    let notfound=1
    while (i<=imax)&&notfound
      if strpart(cs,i,Nss)==ss
        let retval=i
        let notfound=0
      endif
      let i=i+1
    endwhile
    if notfound
      let retval=-1
    endif
  endif
  "warnings
  if war 
    if retval==-2
      echo input("ERROR in StrFind(\"".cs."\",\"".ss."\"): Container string empty.") 
    elseif retval==-3
      echo input("ERROR in StrFind(\"".cs."\",\"".ss."\"): Search string empty.") 
    elseif retval==-4
      echo input("ERROR in StrFind(\"".cs."\",\"".ss."\"): Container string bigger than search string.") 
    endif
  endif 
  "
  return retval
endfunction

" Return a string with str inserted in oldstr before position nins
function! StrInsert(oldstr,str,ni)
  let err=g:echoerrormessages
  let oldstr=a:oldstr
  let str=a:str
  let ni=a:ni
  let n=strlen(oldstr)-1
  if ni<0
    call input("ERROR in StrInsert(\"".oldstr."\",\"".str."\",".ni."): Index smaller than zero.")
    let errorcode=-1
    return -1
  elseif ni>n+1
    call input("ERROR in StrInsert(\"".oldstr."\",\"".str."\",".ni."): Index too large.")
    let errorcode=-2
    return -2
  else
    if ni==0
      let pre=""
    else
      let pre=StrCut(oldstr,0,ni-1)
    endif
    if ni==n+1
      let post=""
    else
      let post=StrCut(oldstr,ni,n)
    endif
    return pre.str.post
  endif
endfunction

" Shift string section n1..n2 by one position to the right. 
" Padd with spaces at end of string if necessary. Overwrite
" if necessary.
function! StrShiftR(string,n1,n2)
  let string=a:string
  let n1=a:n1
  let n2=a:n2
  if string==""
    call input("ERROR in StrShiftR(\"".string."\",".n1.",".n2."): String is empty.")
  elseif n1>n2
    call input("ERROR in StrShiftR(\"".string."\",".n1.",".n2."): Index n1 > n2.")
  else
    let n=strlen(string)-1
    if n1==0
      let pre=""
    else
      let pre=StrCut(string,0,n1-1)
    endif
    let mov=StrCut(string,n1,n2)
    if n2>=n-1
      let post=""
    else
      let post=StrCut(string,n2+2,n)
    endif
    return pre." ".mov.post
  endif
endfunction

" Shift string section n1..n2 by one position to the left. 
function! StrShiftL(string,n1,n2)
  let string=a:string
  let n1=a:n1
  let n2=a:n2
  if string==""
    call input("ERROR in StrShiftR(\"".string."\",".n1.",".n2."): String is empty.")
  elseif n1>n2
    call input("ERROR in StrShiftR(\"".string."\",".n1.",".n2."): Index n1 > n2.")
  else
    let n=strlen(string)-1
    if n1<=1
      let pre=""
    else
      let pre=StrCut(string,0,n1-2)
    endif
    let mov=StrCut(string,n1,n2)
    if n2==n
      let post=""
    else
      let post=StrCut(string,n2+1,n)
    endif
    return pre.mov." ".post
  endif
endfunction
" ----------------------------------------------------------------------------- 
" endif
" ----------------------------------------------------------------------------- 
