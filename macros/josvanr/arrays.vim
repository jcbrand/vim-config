" **arrays.vim**
" 
" Use arrayspaces of strings in vim. 
" 
" ARRAY_FUNCTIONS:
" 
" let ars=ArsAdd(ars,"name",array)    Add array to arrspace.
" let ars=ArsNew(ars,"name")          Add empty array to space arr.
" let yn=ArsExist(ars,"name")         Check if "name" exists in space ars.
" let ars=ArsAppend(ars,"name","x")   Add a string to array arr.
" let l=ArsLen(ars,"name")            Find out the length of an array.
" let strn=ArsGet(ars,"name",n)       Retreive the string at the n-th index.
" let n=ArsFindExact(ars,"name",pat)  Index of string at which pattern matches.
" let arr=ArsGetArr(ars,"name")       Return array "name" from array space ars.
" let ars=ArsSet(ars,"name","x",n)    Set the string at the n-th index.
" let ars=ArsDel(ars,"name")          Remove array "name" from space arr.
" let ars=ArsDelIx(ars,"name",ix)     Remove entry in one of the arrays.
" let l=ArsMaxLen(ars,"name")         Length of longest string in array "name".
" 
" Todo:
" 
" let maxl=ArsMaxLen(ars)             Length of the longest string in the array.
" let ix=ArsMaxLenIx(ars,"name")      Index of first longest string in array.
" 
" NOTE: 
" 
"   ²second array³°1±string°0±string°-1±²first array³°0±test°-1±
" 
" ----------------------------------------------------------------------------- 
" if !exists("_arrays_vim_sourced") 
" let _arrays_vim_sourced=1 
" ----------------------------------------------------------------------------- 
so ~/array.vim

fu! ArsAdd(ars,name,arr)
  return a:ars."²".a:name."³".a:arr
endf

fu! ArsNew(ars,name)
  let name="²".a:name."³"
  let n=matchend(a:ars,name)
  if n<0
    return a:ars.name."°-1±"
  else
    return fnamemodify(a:ars,":gs?\\(²".a:name."³\\)[^².]*°-1±?\\1°-1±?")
  end
endf

fu! ArsExist(ars,name)
  return match(a:ars,"²".a:name."³")
endf

fu! ArsAppend(ars,name,str)
  let n=matchend(a:ars,"²".a:name."³")
  let post=strpart(a:ars,n,strlen(a:ars))
  return strpart(a:ars,0,n)."°".(strpart(post,1,match(post,"±")-1)+1)."±".a:str.post
endfunction

fu! ArsLen(ars,name)
  let n=matchend(a:ars,"²".a:name."³")
  let post=strpart(a:ars,n,strlen(a:ars))
  return strpart(post,1,match(post,"±")-1)+1
endf

function! ArsGet(ars,name,nx)
  let arr=strpart(a:ars,matchend(a:ars,"²".a:name."³"),strlen(a:ars))
  let n1=matchend(arr,"°".a:nx."±")
  let n2=match(arr,"°".(a:nx-1)."±")
  return strpart(arr,n1,n2-n1)
endfunction

fu! ArsFindExact(ars,name,str)
  let arr=strpart(a:ars,matchend(a:ars,"²".a:name."³"),strlen(a:ars))
  let arr=strpart(arr,0,matchend(arr,"°-1±"))
  let n=match(arr,"±".a:str."°")
  if n>-1
    let s=strpart(arr,0,n+1)
    let n1=match(s,"°[0-9\\(-1\\)]\*±$")
    return strpart(s,n1+1,n-n1-1)
  else
    return -1
  end
endf

fu! ArsGetArr(ars,name)
  let arr=strpart(a:ars,matchend(a:ars,"²".a:name."³"),strlen(a:ars))
  return strpart(arr,0,matchend(arr,"°-1±"))
endf

fu! ArsSet(ars,name,setstr,nix) 
  return fnamemodify(a:ars,":gs?\\(²".a:name."³[^².]*°".a:nix."±\\)\\([^°.]*\\)°?\\1".a:setstr."°?")
endf

fu! ArsDel(ars,name)
  return fnamemodify(a:ars,":gs?²".a:name."³[^².]*°-1±??")
endf

fu! ArsDelIx(ars,name,n)
  let arr=ArsGetArr(a:ars,a:name)
  let a1=ArrPart(arr,0,a:n)
  let a2=ArrPart(arr,a:n+1,ArrLen(arr)-1-a:n)
  return ArsDel(a:ars,a:name)."²".a:name."³".ArrCon(a1,a2)
endf

function! ArsMaxLen(ars,name)
  let arr=ArsGetArr(a:ars,a:name)
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


" function! ArrLen(array)
"   return strpart(a:array,1,match(a:array,g:arrcloseexp)-1)+1
" endfunction
" 
" fu! ArrMaxLenIx(arr)
"   let l=ArrMaxLen(a:arr)
"   let n=ArrLen(a:arr)|let i=0
"   wh i<n
"     let candidate=ArrGet(a:arr,i)
"     if strlen(candidate)==l
"       return i
"       let i=n
"     end
"     let i=i+1
"   endwh
" endf
" 

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
" 
" function! ArrSet(oldarr,setstr,nix) 
"   if a:nix>(ArrLen(a:oldarr)-1) 
"     echo "ERROR in ArrSet(oldarr,setstr,nix): nix exceeds array length." 
"   else 
"     let n1=matchend(a:oldarr,g:arropenexp.a:nix.g:arrcloseexp) 
"     let n2=match(a:oldarr,g:arropenexp.(a:nix-1).g:arrcloseexp) 
"     let newarr=strpart(a:oldarr,0,n1).strpart(a:oldarr,n2,strlen(a:oldarr)) 
"     let n=matchend(newarr,g:arropenexp.a:nix.g:arrcloseexp) 
"     return strpart(newarr,0,n).a:setstr.strpart(newarr,n,strlen(newarr)-n) 
"   endif 
" endfunction 
" 
" function! ArrGet(arr,nix)
"   let n1=matchend(a:arr,g:arropenexp.a:nix.g:arrcloseexp)
"   let n2=match(a:arr,g:arropenexp.(a:nix-1).g:arrcloseexp)
"   return strpart(a:arr,n1,n2-n1)
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
" function! ArrAppend(arr,str)
"   return g:arropen.ArrLen(a:arr).g:arrclose.a:str.a:arr
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
" 
" function! ArrGetItems(str,seppat)
"   let arr=g:arrnew
"   let str=a:str
"   let n=match(str,a:seppat)
"   while n>0
"     let arr=ArrAppend(arr,strpart(str,0,n))
"     let str=strpart(str,n+1,strlen(str)+n-1)
"     let n=match(str,a:seppat)
"   endwhile
"   let arr=ArrAppend(arr,str)
"   return arr
" endfunction
" 
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

" Tests
" let a=""
" let a=ArsNew(a,"first array")
" let a=ArsNew(a,"second array")
" let a=ArsAppend(a,"first array","First entry")
" let a=ArsAppend(a,"first array","Second entry")
" let a=ArsAppend(a,"first array","Third entry")
" let a=ArsAppend(a,"second array","Lah")
" let a=ArsAppend(a,"second array","Di")
" let a=ArsAppend(a,"second array","Dah")
" let a=ArsNew(a,"another one")
" let a=ArsAppend(a,"another one","zipp")
" let a=ArsAppend(a,"another one","zapp")
" echo ArsGet(a,"second array",1)
" let a=ArsSet(a,"first array","Duh",1)
" echo ArsGet(a,"second array",1)
" 

" ----------------------------------------------------------------------------- 
" endif 
" ----------------------------------------------------------------------------- 

