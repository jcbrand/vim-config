" **buffun.vim**
" 
" SUMMARY:
"
"   Function library for buffer operations.
" 
" FUNCTIONS:
" 
" str=BufNamesStr()     String with the names of the currently loaded buffers. 
"                       Use \n as separation mark.
" str=BufNumsStr()      String the with numbers of the currently loaded buffers.
" arr=BufNamesStr(...)  Array with the names of the currently loaded buffers, 
"                       exclude buffers named in argument list. See |array.vim|.
" arr=BufNumsStr(...)   Array with the numbers of the currently loaded buffers,
"                       exclude buffers named in argument list.
" 
" ----------------------------------------------------------------------------- 
if !exists("_buffun_vim_sourced_")
let _buffun_vim_sourced_=1
" ----------------------------------------------------------------------------- 
so ~\array.vim

" function! BufNamesStr()                                                       
"   let bufnames=""                                                             
"   let bl=bufnr("$")                                                           
"   let i=1                                                                     
"   while i<=bl                                                                 
"     if bufexists(i)                                                           
"       let bufnames=bufnames.bufname(i)."\n"                                   
"     endif                                                                     
"   let i=i+1                                                                   
"   endwhile                                                                    
"   return bufnames                                                             
" endfunction                                                                   

" function! BufNumsStr()                                                        
"   let bufnums=""                                                              
"   let bl=bufnr("$")                                                           
"   let i=1                                                                     
"   while i<=bl                                                                 
"     if bufexists(i)                                                           
"       let bufnums=bufnums.i."\n"                                              
"     endif                                                                     
"   let i=i+1                                                                   
"   endwhile                                                                    
"   return bufnums                                                              
" endfunction                                                                   

function! BufNamesArr(...)
  if a:0==0
    let not="sdfjlsjflksjflshdfiwe"
  else 
    let not=a:1
  endif
  let bufnames=g:arrnew
  let bl=bufnr("$")
  let i=1
  while i<=bl
    if bufexists(i)
      let bn=bufname(i)
      if match(bn,not)<0
        let bufnames=ArrAppend(bufnames,bufname(i))
      endif 
    endif
  let i=i+1
  endwhile
  return bufnames
endfunction

function! BufNumsArr(...)
  if a:0==0
    let not="sdfjlsfhsdlflskfjls"
  else
    let not=a:1
  endif
  let bufnums=g:arrnew
  let bl=bufnr("$")
  let i=1
  while i<=bl
    if bufexists(i)
      if match(bufname(i),not)<0
        let bufnums=ArrAppend(bufnums,i)
      endif
    endif
  let i=i+1
  endwhile
  return bufnums
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
