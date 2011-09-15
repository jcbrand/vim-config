" **filebrws.vim**                                                           "
"                                                                            "
" Browse directories, load files and perform file operations from an         "
" interactive file browser.                                                  "
"                                                                            "
" MAPS:                                                                      "
"                                                                            "
"    ,d    Open the browser                                   
"                                                                            "
"    From the browser:                                                       "
"                                                                            "
"       q    Open the file browser menu (non-gui menu).                      "
"      <cr>  On a directory: cd to the dir and display the contents.         "
"            On a file: edit the file, leave the browser.                    "
"       u    Go up one directory level.                                      "
"     <esc>  Leave the browser.                                              "
"       a    Add file to the bufferlist, stay in browser.                    "
"       x    Delete file, or directory tree.                                 "
"       m    Make new directory.                                             "
"       e    Edit a file (type the name).
"       G    Execute the program under the cursor.
"       v    View file or enter directory. When in the file, hit <esc> to 
"            return to the browser, or hit <enter> to edit the file.
"       *    Enter a wildcart expression, show dir.
"
" -----------------------------------------------------------------------------
nm ,d :call FilebrowserOpen()<cr>
" ----------------------------------------------------------------------------- 
if !exists("_filebrws_vim_sourced")
let _filebrws_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\buffun.vim
so ~\fun.vim
so ~\strfun.vim
so ~\txtfun.vim

let filebrowser_dirpat="*.*"

" Filename colors

" Define colors for several file types (...=multiple extentions)
"   match="fe" : highlight the filename with specified extention
"   match="ls" : highlight the entire line containing specified string
"   match="ws" : highlight the word containing the specified string
fu! FilebrowserFiletype(syngroup,highlighprops,match,...)
  exe "hi ".a:syngroup." ".a:highlighprops
  let i=1
  if a:match=="fe"
    let pat1=" \\<[a-zA-Z0-9_-]*\\."
    let pat2="\\>"
  elseif a:match=="ls"
    let pat1="^.*"
    let pat2=".*$"
  elseif a:match=="ws"
    let pat1=" \\<[a-zA-Z0-9_.-]*"
    let pat2="[a-zA-Z0-9_.-]*\\>"
  endif
  wh i<=a:0
    exe "let ext=a:".i
    let uext=StrUppercase(ext)
    exe "syn match ".a:syngroup." +".pat1.ext.pat2."+"
    exe "syn match ".a:syngroup." +".pat1.uext.pat2."+"
    let i=i+1
  endwh
endf

" Filetypes for filebrowser
fu! FilebrowserSyn(current_syntax)
  let Src="gui=NONE guifg=darkcyan ctermfg=cyan"
  let SrcCur="gui=bold guifg=darkcyan term=bold ctermfg=cyan"
  cal FilebrowserFiletype("FiletypeVim",Src,"fe","vim","syn")
  cal FilebrowserFiletype("FiletypeHtm",Src,"fe","htm","html")
  cal FilebrowserFiletype("FiletypeCpp",Src,"fe","c","cc","cpp","cxx","h","hpp")
  cal FilebrowserFiletype("FiletypeTex",Src,"fe","tex","sty")
  cal FilebrowserFiletype("FiletypeFor",Src,"fe","f")
  cal FilebrowserFiletype("FiletypeVrc",Src,"ws","vimrc","viminfo")
  cal FilebrowserFiletype("FiletypeExe","guifg=orange ctermfg=yellow","fe","com","exe","bat")
  cal FilebrowserFiletype("FiletypeBat","guifg=orange ctermfg=yellow","fe","bat")
  cal FilebrowserFiletype("FiletypePdf","guifg=yellow ctermfg=yellow","fe","ps","dvi","pdf","gif","jpg","bmp","pxl","mpg","mp","mp2","mp3","wav","au","snd")
  cal FilebrowserFiletype("FiletypeDir","guifg=blue ctermfg=blue","ls","<DIR>")
  cal FilebrowserFiletype("FiletypeTxt","guifg=darkgreen ctermfg=green","fe","nfo","new","txt","doc","me")
  cal FilebrowserFiletype("FiletypeZip","guifg=brown ctermfg=brown","fe","zip","arj","gz","cab","rar")
  cal FilebrowserFiletype("FiletypeInf","guifg=darkblue ctermfg=blue","fe","dll","ico","hlp","ini","inf","sys")
  " Make current type files bold
  if a:current_syntax=="vim"
    exe "hi "."FiletypeVim ".SrcCur
    exe "hi "."FiletypeVrc ".SrcCur
  elseif a:current_syntax=="html"
    exe "hi "."FiletypeHtm ".SrcCur
  elseif a:current_syntax=="tex"
    exe "hi "."FiletypeTex ".SrcCur
  elseif a:current_syntax=="fortran"
    exe "hi "."FiletypeFor ".SrcCur
  elseif a:current_syntax=="c"
    exe "hi "."FiletypeCpp ".SrcCur
  elseif a:current_syntax=="dosbatch"
    exe "hi "."FiletypeCpp "."gui=bold guifg=orange term=bold ctermfg=yellow"
  endif
endf

" Load directory into new buffer                                                
fu! FilebrowserOpen()
  so ~\ngmfile.vim
  set ch=10
  let g:filebrowserLastEditedBuffer=bufnr("%")
  if exists("b:current_syntax")
    let g:old_current_syntax=b:current_syntax
  else
    let g:old_current_syntax=""
  endif
  let fn="_dir"
  cal delete(fn)
  exe "e!".fn
  exe "r !dir/o"
  exe "1"
  exe "normal 4dd"
  exe "w!"
  set ch=1
  exe "1"
  exe "normal zt3j"
  if exists("g:filebrowserDir")&&exists("g:filebrowserLine")
    let dir=expand("%:p:h")
    if dir==g:filebrowserDir
      exe g:filebrowserLine
    endif
  endif
  normal 45|
endf

" Execute command dir str
fu! FilebrowserDir(...)
  let in=input("[".g:filebrowser_dirpat."]: ")
  if in!=""
    let g:filebrowser_dirpat=in
  endif
  exe g:bufclear
  exe "r !dir ".g:filebrowser_dirpat."/o"
  exe "1"
  exe "normal 4dd"
  exe "w!"
  set ch=1
  exe "1"
  exe "normal zt3j"
endf

" Leave filebrowser
fu! FilebrowserClose()
 let g:filebrowserLine=line(".")
 let g:filebrowserDir=expand("%:p:h")
 set ch=10
  let fn="_dir"
  cal delete(fn)
  exe "bd!"
  if bufexists(g:filebrowserLastEditedBuffer)
    exe "b".g:filebrowserLastEditedBuffer
  endif
  so ~\ngmdef.vim
  set ch=1
endf

" Up one directory
fu! FilebrowserUp()
  cal FilebrowserClose()
  exe "cd .."
  cal FilebrowserOpen()
endf

" Delete file or directory structure (be careful)
fu! FilebrowserDel()
  let fn=expand("<cfile>")
  exe "r! deltree/y ".fn
  set ch=10
  cal FilebrowserClose()
  cal FilebrowserOpen()
  set ch=1
endf

" Make new directory
fu! FilebrowserMd()
  let dn=input("New directory: ")
  if dn!=""
    exe "r!md ".dn
    set ch=10
    cal FilebrowserClose()
    cal FilebrowserOpen()
    set ch=1
  endif
endf

" Load file on current line, or view directory
fu! FilebrowserLoad() 
  exe "normal $"
  let fd=expand("<cfile>")
  if isdirectory(fd)
    cal FilebrowserClose()
    exe "cd ".fd
    cal FilebrowserOpen()
  else
    cal FilebrowserClose()
    set ch=10
    exe "e!".fd
    set ch=1
    normal gg
  endif
endf

" Add file to bufferlist and open filebroser again.
fu! FilebrowserAdd()
  let fd=expand("<cfile>")
  if !isdirectory(fd)
    cal FilebrowserClose()
    set ch=10
    exe "e!".fd
    cal FilebrowserOpen()
    set ch=1
  endif
endf

" View a file or directory, press <esc> to return to 
" filebrowser (neat huh?)                                                       
" 
" Don't edit the viewed file after all
fu! FilebrowserEditNo()
  bd!
  cal FilebrowserOpen()
endf
"
" Edit the viewed file
fu! FilebrowserEditYes()
  nun<esc>
  nm <cr> cal BuflistOpen()
  nun J
  nun K
  set cmdheight=1
endf
"                                                                               
" View a file (or directory)
fu! FilebrowserView()
  let fd=expand("<cfile>")
  if isdirectory(fd)
    cal FilebrowserClose()
    exe "cd ".fd
    cal FilebrowserOpen()
  else
    cal FilebrowserClose()
    set cmdheight=6
    exe "e!".fd
    nm <esc> :cal FilebrowserEditNo()<cr>
    nm <cr> :cal FilebrowserEditYes()<cr>
    set cmdheight=6
    echo "<return>=edit file, J=Next, K=Prev, <esc>=back to file browser"
  endif
endf

aug filebrowser
  au!
  au bufenter _dir nm <cr> :cal FilebrowserLoad()<cr>
  au bufleave _dir nun <cr>
  au bufenter _dir nm w W
  au bufleave _dir nun w
  au bufenter _dir map h B
  au bufleave _dir unm h
  au bufenter _dir map l W
  au bufleave _dir unm l
  au bufenter _dir map b B
  au bufleave _dir unm b
  au bufenter _dir map <esc> :cal FilebrowserClose()<cr>
  au bufleave _dir unm <esc>
  au bufenter _dir map a :cal FilebrowserAdd()<cr>
  au bufleave _dir unm a
  au bufenter _dir nm u :cal FilebrowserUp()<cr>
  au bufleave _dir nun u
  au bufenter _dir nm X :cal FilebrowserDel()<cr>
  au bufleave _dir nun X
  au bufenter _dir nm m :cal FilebrowserMd()<cr>
  au bufleave _dir nun m
  au bufenter _dir cab e e!
  au bufleave _dir cunab e
  au bufenter _dir nm e :e \|bd!_dir<left><left><left><left><left><left><left><left>
  au bufleave _dir nun e
  au bufenter _dir map v :cal FilebrowserView()<cr>
  au bufleave _dir unm v
  au bufenter _dir cal FilebrowserSyn(old_current_syntax)
  au bufenter _dir nm * :cal FilebrowserDir()<cr>
  au bufleave _dir nun *
  au bufenter _dir nm G :exe "! ".expand("<cfile>")<cr>
  au bufleave _dir unm G
  au bufleave _dir so ~/_vimrc
aug END
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
