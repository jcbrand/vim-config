" **inline.vim**
" 
" SUMMARY:
"
" Use 'inline functions' in your html documents, and include files.
"  
" 
" INCLUDE FILES:
" 
" In an html file you want to insert your address, sometimes with your work 
" email and sometimes with your home email added. To do this, in the file 
" address.txt put:
" 
"   <pre>
"   Here is my address:
"     Jos van Riswick,
"     Galileistraat 35,
"     Eindhoven.
"     EMAIL
"   </pre>
" 
" In your file myfile.html.html, now you can put:
" 
"   <file|address.txt|EMAIL|josvanr@xs4all.nl>
"   <file|address.txt|EMAIL|j.g.a.v.riswick@tue.nl>
" 
" and upon hitting ,E a file myfile.html will be made, in which the 
" above lines are replaced by the address.txt, where EMAIL is replaced
" by the given arguments:
" 
"   <pre>
"   Here is my address:
"     Jos van Riswick,
"     Galileistraat 35,
"     Eindhoven.
"     josvanr@xs4all.nl
"   </pre>
" 
"   <pre>
"   Here is my address:
"     Jos van Riswick,
"     Galileistraat 35,
"     Eindhoven.
"     j.g.a.v.riswick@tue.nl
"   </pre>
" 
"
" INLINE FUNCTIONS.
"
" For use in your html file myfile.html, declare the functions in a 
" the file myfile.comms as follows:
"
"   bigheader
"   afile.htm
"   anothercomm
"   anotherfile.htm
"
" ie. myfile.comms contains pairs of lines, containing the new command
" name (<tag> name) and the file where the command is defined. Define
" the command in afile.htm, eg:
" 
"   <h1 name="ARG_1">
"   ARG_2
"   </h1>
" 
" Then in myfile.html.html you can use
"
"   <bigheader|test|A test header>
" 
" which upon hitting ,E will be expanded as
"   
"   <h1 name="test">
"   A test header
"   </h1>
" 
" into the file myfile.html
" 
" 
" MAPS: 
"  
"    ,E  :call Expand()      Include files and expand inline functions in 
"                            current file
"
"    ,x  :                   From visual mode: write selected text to file,
"                            and replace by <file|... statement.
" 
" NOTES: 
"                                                                       
"   * For now, only linewise substitutions are possible, ie.  <file ...> has
"     to be at the start of a line.                                         
"                                                                       
"   * For a | use the escape sequence XXXYYY: "testXXXYYYabc" expands to 
"     "test|abc" (Sorry for that.)
"
"   * Make shure there are no empty lines in the .comms files.
"
" BUGS:
"
"   * Problem with <file|... or <mycommand|... on the first line of a .html 
"     file. Dont put it there, for now.
"
"   * Don't choose your commands to have the same name as genuine html tags.
"
" TODO:
"
"   * Make ,E work on all loaded .html.html buffers.
"
"   * Make possible recursive macro substitution: 
" 
"     Eg when a command <mytag> is linked to the file mytag.html.html,
"     first process the file mytag.html.html->mytag.html, and then 
"     include it.
"
" -----------------------------------------------------------------------------
map ,E :call Expand()<cr>
vmap ,x "zy:call Collapse()<cr>
" -----------------------------------------------------------------------------
if !exists("_inline_vim_sourced")                                      
let _inline_vim_sourced=1                                             
" -----------------------------------------------------------------------------
so ~\array.vim
so ~\buffun.vim

let patt="<[^<^|.]*\\(>\\||\\)"

fu! Expand()
  set ch=15                                                          
  let og=&gdefault|let &gdefault=1
  let fn=expand("%")
  if fnamemodify(fn,":e:e")=="html.html"
    let fn=fnamemodify(fn,":r")
  endif
  let commsfile=fnamemodify(fn,":r").".comms"
  exe "w!|w!".fn."|e!".fn
  let oic=&ic|set noic
  call ExpandFiles()
  call ExpandInlines(commsfile)
  let &ic=oic
  exe "w!"
  set ch=1
  if exists("_vimpp_vim_sourced")
    call PP()
  endif
  let &gdefault=og
endf

fu! ExpandInlines(commsfile)
  if filereadable(a:commsfile)
    let b=bufnr("%")
    let comms=ArrLoad(a:commsfile)
    let i=1
    wh i<=line("$")
      exe i
      let a=matchstr(getline("."),"<[^<^|.]*\\(>\\||\\)")
      let a=strpart(a,1,strlen(a)-2)
      let f=ArrFindExact(comms,a)
      if f>-1
        let f=ArrGet(comms,f+1)
        let s=matchstr(getline("."),"<.*>")
        let a=ArrGetItems(strpart(s,1,strlen(s)-2),"|")
        let a=substitute(a,"XXXYYY","|","g")
        let a=fnamemodify(a,":gs?\/?\\\\/?:gs?\\~?\\\\~?")
        let @a="CUTHERE<><><><>\n"
        norm ddk"apk
        exe "r ".f."|bd! ".f."|b ".b
        let n=ArrLen(a)
        if n>1
          let cl=line(".")
          let j=1
          while j<n
            exe cl
            exe "norm V/CUTHERE<><><><>\r:s/ARG_".j."/".ArrGet(a,j)."\r"
            let j=j+1
          endwh
        end
        exe "norm /CUTHERE<><><><>\rdd"
      else
        let i=i+1
      end
    endwh
    normal gg
  endif
endf

fu! ExpandFiles()
  let b=bufnr("%")
  let i=1
  while i<=line("$")
    exe i
    let s=matchstr(getline("."),"<file.*>[^>a-z]*")
    if s!=""
      let s=strpart(s,6,strlen(s)-7)
      let a=ArrGetItems(s,"|")
      let a=substitute(a,"XXXYYY","|","g")
      let @a="CUTHERE<><><><>\n"
      norm ddk"apk
      let fn=ArrGet(a,0)
      exe "r ".fn."|bd! ".fn."|b ".b
      let n=ArrLen(a)
      let cl=line(".")
      let j=1|let J=(n-1)/2
      while j<=J
        exe cl
        exe "norm V/CUTHERE<><><><>\r:s/".ArrGet(a,2*j-1)."/".ArrGet(a,2*j)."\r"
        let j=j+1
      endwh
      exe "norm /CUTHERE<><><><>\rdd"
    end
    let i=i+1
  endwh
  normal gg
endf

" Collapse contents of register z
fu! Collapse()
    let fn=input("Filename [.htm]: ").".htm"
    exe "norm gv:w! ".fn."\rgvx"
    let @z="<file|".fn.">\n"
    norm "zP
    w!
endf

" -----------------------------------------------------------------------------
endif                                                                 
" -----------------------------------------------------------------------------
