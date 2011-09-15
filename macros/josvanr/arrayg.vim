" **arrayg.vim**
" 
" Use arrays of strings in vim. Same as array.vim, but operate on globals.
" 
" ARRAY_FUNCTIONS: ("gn" is the name of the global array)
"
" ArrNewG(...)                      New global arrays.
" ArrG("gn","first", "second")      Array containing some strings.
" let maxl=ArrMaxLenG("gn")         Length of the longest string in the array.
" let ix=ArrMaxLenIxG(arr)          Index of first longest string in array.
" ArrSetG("gn","string",n)          Set the string at the n-th index.
" let strn=ArrGetG("gn".arr,n)      Retreive the string at the n-th index.
" ArrAppendG("gn",arr,"added")      Add a string to array arr.
" let n=ArrFindExactG("gn",pattern) Index of string at which pattern matches.
" let l=ArrLenG("gn",arr)           Find out the length of an array.
" let arr=ArrGetItemsG("gn",str,seppat) Array containing items separated by seppat.
" 
" Todo:
"
" let arr=ArrPartG(arr,n1,n2)       Return sub-array, starting at n1, length n2.
" let arr=ArrConG(arr1,arr2)        Concatinate strings.
" let arr=ArrDelIxG(arr,ix)         Remove entry ix from string.
" let arr=ArrLoadG(filename)        Load lines in file into array.
" 
" OTHER_FUNCTIONS: 
" 
" let bufnamesarr=BufNamesArr()    Array with names of loaded buffers.
" let bufnumsarr=BufNumsArr()      Array with numbers of loaded buffers.
" 
" Defined in |buffun.vim|.
" 
" NOTE: 
" 
"   The array itself is also a string like:
" 
"         °2±first one°1±middle one°0±last one°-1±
" 
"   i.e. the strings stored in the array are separated by marks °n±.
"   This means that the strings stored in the array cannot contain °
"   or ±. If you do want to store ° or ±, you must define more complex 
"   separation marks, and the search pattern strings to find them.
"   (See global variables arropen, arropenexp etc. below.)
" 
" ----------------------------------------------------------------------------- 
if !exists("_arrayg_vim_sourced_") 
let _arrayg_vim_sourced_=1 
" ----------------------------------------------------------------------------- 
so ~/array.vim
let arropen="°"
let arropenexp="°"
let arrclose="±"
let arrcloseexp="±"
let arrstop="-1"
let arrstopexp="-1"
let arrnew=arropen.arrstop.arrclose

fu! ArrNewG(...)
  let i=1
  while i<=a:0
    exe "let name=a:".i
    exe "let g:".name."=g:arrnew" 
    let i=i+1
  endwh
endf

function! ArrLenG(gn)
  exe "return strpart(g:".a:gn.",1,match(g:".a:gn.",g:arrcloseexp)-1)+1"
endfunction

fu! ArrG(gn,...)
  let newarr=g:arrnew
  let n=a:0
  let i=1
  while i<=n
    execute "let newarr=ArrAppend(newarr,a:".i.")"
    let i=i+1
  endwhile
  exe " let g:".a:gn."=newarr"
endfunction

function! ArrMaxLenG(gn)
  exe "let arr=g:".a:gn
  let maxlen=0
  let n=ArrLen(arr)-1
  let i=0
  while i<=n
    let l=strlen(ArrGet(arr,i))
    if l>maxlen
      let maxlen=l
    endif
    let i=i+1
  endwhile
  return maxlen
endfunction

fu! ArrMaxLenIxG(gn)
  exe "let arr=g:".a:gn
  let l=ArrMaxLen(arr)
  let n=ArrLen(arr)|let i=0
  wh i<n
    let candidate=ArrGet(arr,i)
    if strlen(candidate)==l
      return i
      let i=n
    end
    let i=i+1
  endwh
endf

function! ArrSetG(gn,setstr,nix) 
  exe "let oldarr=g:".a:gn
  if a:nix>(ArrLen(oldarr)-1) 
    echo "ERROR in ArrSet(oldarr,setstr,nix): nix exceeds array length." 
  else 
    let n1=matchend(oldarr,g:arropenexp.a:nix.g:arrcloseexp) 
    let n2=match(oldarr,g:arropenexp.(a:nix-1).g:arrcloseexp) 
    let newarr=strpart(oldarr,0,n1).strpart(oldarr,n2,strlen(oldarr)) 
    let n=matchend(newarr,g:arropenexp.a:nix.g:arrcloseexp) 
    exe "let g:".a:gn."=strpart(newarr,0,n).a:setstr.strpart(newarr,n,strlen(newarr)-n)"
  endif 
endfunction 

function! ArrGetG(gn,nix)
  exe "let arr=g:".a:gn
  let n1=matchend(arr,g:arropenexp.a:nix.g:arrcloseexp)
  let n2=match(arr,g:arropenexp.(a:nix-1).g:arrcloseexp)
  return strpart(arr,n1,n2-n1)
endfunction

function! ArrAppendG(gn,str)
  exe "let g:".a:gn."=g:arropen.(strpart(g:".a:gn.",1,match(g:".a:gn.",g:arrcloseexp)-1)+1).g:arrclose.a:str.g:".a:gn
endfunction

function! ArrFindExactG(gn,str)
  exe "let arr=g:".a:gn
  let n=match(arr,g:arrcloseexp.a:str.g:arropenexp)
  if n>-1
    let s=strpart(arr,0,n+1)
    let n1=match(s,g:arropenexp."[0-9\\(-1\\)]\*".g:arrcloseexp."$")
    return strpart(s,n1+1,n-n1-1)
  else
    return -1
  endif
endfunction

function! ArrGetItemsG(gn,str,seppat)
  let arr=g:arrnew
  let str=a:str
  let n=match(str,a:seppat)
  while n>-1
    let arr=ArrAppend(arr,strpart(str,0,n))
    let str=strpart(str,n+1,strlen(str))
    let n=match(str,a:seppat)
  endwhile
  exe "let g:".a:gn."=ArrAppend(arr,str)"
endfunction

" so ~\txtfun.vim 
" Print the contents of an array linewise 
" function! ArrPrint(arr) 
"   let oc=col(".") 
"   let ol=line(".") 
"   let n=ArrLen(a:arr)-1 
"   let outstr="" 
"   let i=0 
"   while i<=n 
"     let s=ArrGet(a:arr,i) 
"     let outstr=outstr.s."\n" 
"     let i=i+1 
"   endwhile 
"   call PrintLineAfter(outstr) 
" endfunction 

" 
" function! ArrLinesStr(arr)
"   let out=""
"   let i=0
"   while i<=(ArrLen(a:arr)-1)
"     let out=out.ArrGet(a:arr,i)."\n"
"     let i=i+1
"   endwhile
"   return out
" endfunction

" function! ArrPart(arr,start,length)
"   let newarr=g:arrnew
"   let i=a:start
"   while i<=(a:start+a:length-1)
"     let newarr=ArrAppend(newarr,ArrGet(a:arr,i))
"     let i=i+1
"   endwhile
"   return newarr
" endfunction
" 
" function! ArrCon(arr1,arr2)
"   let newarr=a:arr1
"   let i=0
"   while i<=(ArrLen(a:arr2)-1)
"     let newarr=ArrAppend(newarr,ArrGet(a:arr2,i))
"     let i=i+1
"   endwhile
"   return newarr
" endfunction
" 
" function! ArrDelIx(arr,n)
"   let a1=ArrPart(a:arr,0,a:n)
"   let a2=ArrPart(a:arr,a:n+1,ArrLen(a:arr)-1-a:n)
"   return ArrCon(a1,a2)
" endfunction
" 
" fu! Arr(...)
"   let newarr=g:arrnew
"   let n=a:0
"   let i=1
"   while i<=n
"     execute "let newarr=ArrAppend(newarr,a:".i.")"
"     let i=i+1
"   endwhile
"   return newarr
" endfunction

" function! ArrExecute(arr,...)
"   if a:0==0
"     let n1=0
"     let n2=ArrLen(a:arr)-1
"   else
"     let n1=a:1
"     let n2=a:1
"   endif
"   let i=n1
"   while i<=n2
"     execute ArrGet(a:arr,i)
"     let i=i+1
"   endwhile
" endfunction
" 
" fu! ArrLoad(fn)
"   set ch=7
"   let bn=bufnr("%")
"   exe "w!|e ".a:fn
"   let a=g:arrnew|let n=line("$")|let i=1
"   wh i<=n
"     exe i
"     norm v$"zy
"     let a=ArrAppend(a,@z)
"     let i=i+1
"   endwh
"   exe "bd!|b ".bn
"   set ch=1
"   return a
" endf
" ----------------------------------------------------------------------------- 
endif 
" ----------------------------------------------------------------------------- 

