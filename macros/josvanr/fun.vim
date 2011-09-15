" **fun.vim**
" 
" SUMMARY:
"
"   General purpouse functions.
"
" FUNCTIONS:
"
" exe g:bufclear          Clear the current buffer.
" call AsciiTab(n1,n2)    Print an ascii table, from n1 to n2.
" call AsciiRuler(n1,n2)  Print an ascii ruler, from n1 to n2.
" isnum = IsNum(str)      Check if contents of a string is a number or not.
" call Save(a,fn)         Save contents of variable a to file "fn"
" 
" ----------------------------------------------------------------------------- 
if !exists("_fun_vim_sourced")
let _fun_vim_sourced=1
" ----------------------------------------------------------------------------- 
let bufclear="normal ggdG"

fu! Save(a,fn)
  let ch=&ch|let &ch=&lines-1
  exe "redir! > ".a:fn
  echo a:a
  redir END
  let &ch=ch
endf

" function! AsciiTab(n1,n2)                                                     
"   let i=a:n1                                                                  
"   while i<=a:n2                                                               
"     call PrintLineAfter(i." ".nr2char(i),line("$"))                           
"     let i=i+1                                                                 
"   endwhile                                                                    
" endfunction                                                                   

function! AsciiRuler(n1,n2)
  let str=""
  let i=a:n1
  while i<=a:n2
    let str=str.nr2char(i)
    let i=i+1
  endwhile
  call PrintLineAfter(str)
endfunction

" function! IsNum(str)                                                          
"   let str=a:str                                                               
"   let n1=49                                                                   
"   let n2=57                                                                   
"   let i=0                                                                     
"   let n=strlen(str)-1                                                         
"   let isnum=1                                                                 
"   while i<=n                                                                  
"     let c=char2nr(StrChar(str,i))                                             
"     if (c<=n1)||(c>=n2)                                                       
"       let isnum=0                                                             
"     endif                                                                     
"   let i=i+1                                                                   
"   endwhile                                                                    
"   return isnum                                                                
" endfunction                                                                   

" function! OptGet(name)                                                        
"   let name=a:name                                                             
"   execute("let val=&".name)                                                   
"   return val                                                                  
" endfunction                                                                   

" function! OptSet(name,value)                                                  
"   let name=a:name                                                             
"   let value=a:value                                                           
"   execute("set ".name."=".value)                                              
" endfunction                                                                   

" function! OptAppend(name,value)                                               
"   let name=a:name                                                             
"   let value=a:value                                                           
"   call OptSet(name,OptGet(name).value)                                        
" endfunction                                                                   

" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
