" **grep.vim**
"
" Find the occurences of a string "myfunction" in all files of 
" the current directory, and put the filenames, linenumbers and 
" lines in a file _grep_myfunction_ in the &backupdir directory:
"
"    call Grep("myfunction")
"
" In the _grep file use
"
"    call GrepOpen()
" 
" to edit the file on the current line, at the position where 
" "myfunction" occurs.
"
" If you use filebrws.vim, the files in the _grep file are colored,
" the same way as in the filebrowser.
"
" MAPS:
" 
"   gr
"
"       Find occurences of the word under the cursor, if no word
"       under the cursor, prompt for a search word.
"       Hit gr in visual mode to search for the visually selected
"       word
"
"    e  In a _grep file: edit the file on the current line, at the
"       position where the search string occurs.
" 
"   gs
" 
"       Split the window, and display the hits there.
" 
"    w  In the grep-window: open the file on the current line in the 
"       other widow, keep displaying grep window
" 
"   gl
" 
"       Split-open the last grep-window.
" 
" <esc> Quit the grep window.
"
" EXAMPLE:
" 
" Hit gr with the cursor on bufenter and a file _grep_bufenter is 
" opened containing lines like:
"                                                                               
"  bookmark.vim:14:au bufenter bookmarks nmap <cr> __loadfile-                  
"  bookmark.vim:16:au bufenter bookmarks nmap <esc> :bd<cr>:b <c-r>e<cr>        
"  buflist.vim:16:  au bufenter _buflist nmap <cr> :call BuflistEdit()<cr>      
"  buflist.vim:17:  au bufenter _buflist nmap <esc> :call BuflistClose()<cr>    
"  buflist.vim:20:  au bufenter _buflist nmap x :call BuflistDelete()<cr>       
"  comment.vim:164:au bufenter * let commentlinestyle="-"                       
"  comment.vim:165:au bufenter *.html let commentlinestyle="="                  
" 
" Now position the cursor on the second line and hit e, to open
" the file bookmark.vim at line 16.
" 
" NOTE: 
" 
" The functions need the grep programme (or grep.exe for windows 95).
" Gnu grep for windows 95 is available from
" 
"     http://www.coffeecomputing.com/free/index.html
"
" and other locations.

" -----------------------------------------------------------------------------
nm gr :cal Grep(expand("<cword>"))<cr>
vm gr "zy:cal Grep(@z)<cr>
nm gs :let b=bufnr("%")<cr>gr:exe b."sbuffer"\|res17<cr><c-w>w
vm gs "zy:let b=bufnr("%")\|cal Grep(@z)\|exe b."sbuffer"\|res17<cr><c-w>w
nm gl :exe "sp ".grep_fn<cr>:res 7<cr>
" ----------------------------------------------------------------------------- 
if !exists("_grep_vim_sourced")                                               
let _grep_vim_sourced=1                                                       
" ----------------------------------------------------------------------------- 
so ~\array.vim

aug grep
  au!
  au bufenter _grep_* nm e :exe "e!".GrepFile()."\|".GrepLine()<cr>
  au bufleave _grep_* nun e
  au bufenter _grep_* nn w :let gf=GrepFile()\|let gl=GrepLine()<cr><c-w>w:exe "e!".gf."\|".gl<cr>zz<c-w>w
  au bufleave _grep_* nun w
  au bufenter _grep_* nm <esc> :bd!<cr>
  au bufleave _grep_* nun <esc>
  if exists("g:_filebrws_vim_sourced")
    au bufenter _grep_* cal FilebrowserSyn("")
  endif
  au bufenter _grep_* normal M
  au bufleave _grep_* so ~/_vimrc
aug END

let grep_dir=ArrGet(ArrGetItems(&backupdir,","),0)

fu! Grep(str)
  let ch=&ch|let &ch=10
  if a:str==""
    let str=input("Search: ")
  else 
    let str=a:str
  endif
  let g:grep_fn=g:grep_dir."\\_grep_".str
  cal delete(g:grep_fn)
  exe "e! ".g:grep_fn
  exe "r! grep -n ".str." *.*"
  if exists("g:_filebrws_vim_sourced")
    exe "%s/^/ "
  endif
  w!
  let &ch=ch
  norm gg
endf

fu! GrepLine()
  return ArrGet(ArrGetItems(getline("."),":"),1)
endf

fu! GrepFile()
  return ArrGet(ArrGetItems(getline("."),":"),0)
endf
" ----------------------------------------------------------------------------- 
endif                                                                         
" ----------------------------------------------------------------------------- 
