" **array.vim**
" 
" Use arrays of strings in vim. 
" 
" ARRAY_FUNCTIONS:
" 
" let arr=g:arrnew                 Make a new, empty array of length 0.
" let arr=Arr("first", "second")   Array containing some strings.
" let arr=ArrSet(arr,"string",n)   Set the string at the n-th index.
" let strn=ArrGet(arr,n)           Retreive the string at the n-th index.
" let arr=ArrAppend(arr,"added")   Add a string to array arr.
" let n=ArrFindExact(arr,pattern)  Index of string at which pattern matches.
" let l=ArrLen(arr)                Find out the length of an array.
" call ArrExecute(arr,[ix])        Execute contents array, or only one entry.
" let maxl=ArrMaxLen(arr)          Length of the longest string in the array.
" let ix=ArrMaxLenIx(arr)          Index of first longest string in array.
" call ArrPrint(arr)               Print the contents of an array.
" let arr=ArrGetItems(str,seppat)  Array containing items separated by seppat.
" let str=ArrLinesStr(arr)         Convert array->string with item on each line.
" let arr=ArrPart(arr,n1,n2)       Return sub-array, starting at n1, length n2.
" let arr=ArrCon(arr1,arr2)        Concatinate strings.
" let arr=ArrDelIx(arr,ix)         Remove entry ix from string.
" let arr=ArrLoad(filename)        Load lines in file into array.
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
if !exists("_array_vim_sourced_") 
let _array_vim_sourced_=1 
" ----------------------------------------------------------------------------- 
let arropen="°"
let arropenexp="°"
let arrclose="±"
let arrcloseexp="±"
let arrstop="-1"
let arrstopexp="-1"
let arrnew=arropen.arrstop.arrclose

function! ArrLen(array)
  return strpart(a:array,1,match(a:array,g:arrcloseexp)-1)+1
endfunction

function! ArrMaxLen(arr)
  let maxlen=0
  let n=ArrLen(a:arr)-1
  let i=0
  while i<=n
    let l=strlen(ArrGet(a:arr,i))
    if l>maxlen
      let maxlen=l
    endif
    let i=i+1
  endwhile
  return maxlen
endfunction

fu! ArrMaxLenIx(arr)
  let l=ArrMaxLen(a:arr)
  let n=ArrLen(a:arr)|let i=0
  wh i<n
    let candidate=ArrGet(a:arr,i)
    if strlen(candidate)==l
      return i
      let i=n
    end
    let i=i+1
  endwh
endf

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

function! ArrLinesStr(arr)
  let out=""
  let i=0
  while i<=(ArrLen(a:arr)-1)
    let out=out.ArrGet(a:arr,i)."\n"
    let i=i+1
  endwhile
  return out
endfunction

function! ArrSet(oldarr,setstr,nix) 
  if a:nix>(ArrLen(a:oldarr)-1) 
    echo "ERROR in ArrSet(oldarr,setstr,nix): nix exceeds array length." 
  else 
    let n1=matchend(a:oldarr,g:arropenexp.a:nix.g:arrcloseexp) 
    let n2=match(a:oldarr,g:arropenexp.(a:nix-1).g:arrcloseexp) 
    let newarr=strpart(a:oldarr,0,n1).strpart(a:oldarr,n2,strlen(a:oldarr)) 
    let n=matchend(newarr,g:arropenexp.a:nix.g:arrcloseexp) 
    return strpart(newarr,0,n).a:setstr.strpart(newarr,n,strlen(newarr)-n) 
  endif 
endfunction 

function! ArrGet(arr,nix)
  let n1=matchend(a:arr,g:arropenexp.a:nix.g:arrcloseexp)
  let n2=match(a:arr,g:arropenexp.(a:nix-1).g:arrcloseexp)
  return strpart(a:arr,n1,n2-n1)
endfunction

function! ArrAppend(arr,str)
  return g:arropen.(strpart(a:arr,1,match(a:arr,g:arrcloseexp)-1)+1).g:arrclose.a:str.a:arr
endfunction

function! ArrPart(arr,start,length)
  let newarr=g:arrnew
  let i=a:start
  while i<=(a:start+a:length-1)
    let newarr=ArrAppend(newarr,ArrGet(a:arr,i))
    let i=i+1
  endwhile
  return newarr
endfunction

function! ArrCon(arr1,arr2)
  let newarr=a:arr1
  let i=0
  while i<=(ArrLen(a:arr2)-1)
    let newarr=ArrAppend(newarr,ArrGet(a:arr2,i))
    let i=i+1
  endwhile
  return newarr
endfunction

function! ArrDelIx(arr,n)
  let a1=ArrPart(a:arr,0,a:n)
  let a2=ArrPart(a:arr,a:n+1,ArrLen(a:arr)-1-a:n)
  return ArrCon(a1,a2)
endfunction

fu! Arr(...)
  let newarr=g:arrnew
  let n=a:0
  let i=1
  while i<=n
    execute "let newarr=ArrAppend(newarr,a:".i.")"
    let i=i+1
  endwhile
  return newarr
endfunction

function! ArrFindExact(arr,str)
  let n=match(a:arr,g:arrcloseexp.a:str.g:arropenexp)
  if n>-1
    let s=strpart(a:arr,0,n+1)
    let n1=match(s,g:arropenexp."[0-9\\(-1\\)]\*".g:arrcloseexp."$")
    return strpart(s,n1+1,n-n1-1)
  else
    return -1
  endif
endfunction

function! ArrGetItems(str,seppat)
  let arr=g:arrnew
  let str=a:str
  let n=match(str,a:seppat)
  while n>-1
    let arr=ArrAppend(arr,strpart(str,0,n))
    let str=strpart(str,n+1,strlen(str))
    let n=match(str,a:seppat)
  endwhile
  let arr=ArrAppend(arr,str)
  return arr
endfunction

function! ArrExecute(arr,...)
  if a:0==0
    let n1=0
    let n2=ArrLen(a:arr)-1
  else
    let n1=a:1
    let n2=a:1
  endif
  let i=n1
  while i<=n2
    execute ArrGet(a:arr,i)
    let i=i+1
  endwhile
endfunction

fu! ArrLoad(fn)
  set ch=7
  let bn=bufnr("%")
  exe "w!|e ".a:fn
  let a=g:arrnew|let n=line("$")|let i=1
  wh i<=n
    exe i
    norm v$"zy
    let a=ArrAppend(a,@z)
    let i=i+1
  endwh
  exe "bd!|b ".bn
  set ch=1
  return a
endf
" ----------------------------------------------------------------------------- 
endif 
" ----------------------------------------------------------------------------- 

