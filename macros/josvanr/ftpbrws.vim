" **ftpbrws.vim**
"
"     ,fl         (n) specify login, hostname and password for ftp browser
"     ,fo         (n) open ftp browser, ask for hostname etc. if none 
"                 specified
"     ,fu         upload current file to server
"     <cr>        edit file, or view directory on server 
"      x          delete directory or file on server
"     <cr>        (ft) CD TO DIRECTORY ON CURRENT LINE OR EDIT A FILE. Note   
"                 that the file to be edited is downloaded into a temporary   
"                 directory (see GLOBAL VARS: ftploctempdir).                 
"       u         (ft) GO UP TO PARENT DIRECTORY                              
"       x         (ft) DELETE file or directory on current line               
"       m         (ft) MAKE NEW DIRECTORY                                     
"       gu        (ft) LOWERCASE a file or directory name                     
"       r         (ft) rename a file or directory name                        
"     <esc>       (ft) Quit the browser, but remember the ftp directory.      
"                 (When you press ,fo again go to the same directory, unless  
"                 you are logged in to a different server.                    
" 
" -----------------------------------------------------------------------------
map ,fl :call FTPLogin()<cr>
map ,fo :call FTPBrowseChkLogin()<cr>
map ,fu :call FTPSendCurrent()<cr>
command! Login call FTPLogin()
" ----------------------------------------------------------------------------- 
if !exists("_ftpbrws_vim_sourced")
let _ftpbrws_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\buffun.vim
so ~\fun.vim
so ~\strfun.vim
so ~\txtfun.vim

" Your password (specify default here)
let ftppasswd=""
" Username (specify default here)
let ftpusername=""
" Ftp host (specify default here)
let ftphost=""
" Current directory on the ftp host
let ftpcurrentdir="/"
" Dir for downloading temporary files
let ftploctempdir="c:/ftpdir"
" First time you login, you need to specify username and password
let ftpfirstlogin=1

augroup ftpbrowse
  au!
  au bufenter _ftpbrowse nmap <esc> :call FtpBrowseQuit()<cr>
  au bufleave _ftpbrowse nunmap <esc>
  au bufenter _ftpbrowse nmap <cr> :call FtpFileOrDir()<cr>
  au bufleave _ftpbrowse nun <cr>
  au bufenter _ftpbrowse map u :call FtpCdDir("..")<cr>
  au bufleave _ftpbrowse unmap u
  au bufenter _ftpbrowse map x :call FtpDelete()<cr>
  au bufleave _ftpbrowse unmap x
  au bufenter _ftpbrowse map m :call FtpMakeDir()<cr>
  au bufleave _ftpbrowse unmap m
  au bufenter _ftpbrowse map gu :call FtpLowercase()<cr>
  au bufleave _ftpbrowse unmap gu
  au bufenter _ftpbrowse map r :call FtpRename()<cr>
  au bufleave _ftpbrowse unmap r
  au bufenter _ftpbrowse set noswapfile
  au bufenter _ftpbrowse set swapfile 
  au bufleave _ftpbrowse so ~/map.vim
  " Forget password
  au vimleave let ftppasswd=""
augroup END

" Specify hostname, username and password
function! FTPLogin()
  let a=input("ftp host [".g:ftphost."]: ")
  if a!=""
    let g:ftphost=a
    let g:ftpfirstlogin=1
  endif
  let a=input("username [".g:ftpusername."]: ")
  if a!=""
    let g:ftpusername=a
  endif
  let a=input("password :")
  if a!=""
    let g:ftppasswd=a
  endif
  echo "\rOK, Try ,fo to open the ftp site."
endfunction

" If all info specified, login and view dir, else ask info first
function! FTPBrowseChkLogin()
  if (g:ftppasswd=="")||(g:ftpusername=="")||(g:ftphost=="")
    call FTPLogin()
  endif
  call FTPBrowse()
  call FtpDir()
endfunction

" Send the current ascii file
function! FTPSendCurrent()
  let fn=expand("%:t")
  let path=expand("%:p:h")
  call FTPBrowse()
  call FtpSend(fn,path,"ascii")
  call FtpBrowseQuit()
endfunction 

" Open ftp browser
function! FTPBrowse()
  if g:ftpfirstlogin==1
    call FtpInitialPwd()
    let g:ftpfirstlogin=0
  endif
  set ch=10
  let g:ftpoldbuffer=bufnr("%")
  let fn="_ftpbrowse"
  call delete(fn)
  execute "e!".fn
  set ch=1
endfunction

" Quit ftp browser
function! FtpBrowseQuit()
  set ch=10
  let fn="_ftpbrowse"
  execute "bd!"
  call delete(fn)
  execute "b".g:ftpoldbuffer
  set ch=1
endfunction

" Download a file or view a directory 
function! FtpFileOrDir()
  let str=getline(".")
  execute "normal $hh"
  if strlen(str)>0
    if StrChar(str,0)=="d"
      call FtpCdDir(expand("<cfile>"))
    else
      set ch=10
      call FtpGetnEdit(expand("<cfile>"))
      set ch=1
    endif
  endif
endfunction

" Rename a file or dir on the server.
function! FtpRename()
  execute "normal $hh" 
  let fn=expand("<cfile>")
  let fnnew=input("Rename to: ")
  call FtpCmd("rename ".fn." ".fnnew)
  call FtpDir()
endfunction

" Make a filename on the server lowercase 
function! FtpLowercase()
  execute "normal $hh" 
  let fn=expand("<cfile>")
  execute g:bufclear
  let fnlow=StrLowercase(fn)
  call FtpCmd("rename ".fn." ".fnlow)
  call FtpDir()
endfunction

" Delete a file or directory
function! FtpDelete()
  execute "normal $hh" 
  let fn=expand("<cfile>")
  call FtpCmd("del ".fn)
  call FtpDir()
endfunction

" Make a new directory
function! FtpMakeDir()
  let fn=input("new directory: ")
  call FtpCmd("mkdir ".fn)
  call FtpDir()
endfunction

" Get ascii file to local temporary dir and edit
function! FtpGetnEdit(file)
  set ch=10
  call delete(g:ftploctempdir."/".a:file)
  call FtpGet(a:file,g:ftploctempdir,"ascii")
  call FtpBrowseQuit()
  execute "e!".g:ftploctempdir."/".a:file
  set ch=1
endfunction

" Cd and show dir
function! FtpCdDir(dir)
  call FtpCd(a:dir)
  call FtpDir()
endfunction

" Display contents of current ftp directory
function! FtpDir()
  set ch=10
  execute g:bufclear
  call FtpCmd("dir")
  set ch=1
endfunction
 
" Change current ftp directory
function! FtpCd(dir)
  set ch=10
  execute g:bufclear
  call FtpCmd("cd ".a:dir."\npwd")
  call FindGotoStr("\"")
  execute "normal 1|"
  call FindGotoStr("\"")
  execute "normal lvt\"\"zy"
  let g:ftpcurrentdir=@z
  set ch=1
endfunction

" Set current ftp dir to initial remote dir
function! FtpInitialPwd()
  set ch=10
  execute g:bufclear
  call FtpCmd("pwd")
  call FindGotoStr("\"")
  execute "normal 1|"
  call FindGotoStr("\"")
  execute "normal lvt\"\"zy"
  let g:ftpcurrentdir=@z
  set ch=1
endfunction

" Download a file to local directory, 
" use / for specifying local directories                                        
function! FtpGet(file,localdir,mode)
  call FtpCmd("verbose off\nprompt off\nlcd ".a:localdir."\n".a:mode."\nget ".a:file)
endfunction

" Same for sending a file
function! FtpSend(file,localdir,mode)
  call FtpCmd("verbose off\nprompt off\nlcd ".a:localdir."\n".a:mode."\nsend ".a:file)
endfunction

" Login to site and execute command in current ftp directory
" g:ftpcurrentdir and read results into current buffer
augroup ftpcmd
  au!
  au bufenter _ftpcmd set noswapfile
  au bufleave _ftpcmd set swapfile
augroup END
"
function! FtpCmd(cmdstr)
  set ch=10
  let  bc=bufnr("%")
  let  fn="_ftpcmd"
  call delete(fn)
  execute "e!".fn
  call PrintLineOver("open ".g:ftphost)
  call PrintLineAfter(g:ftpusername, line("$"))
  call PrintLineAfter(g:ftppasswd, line("$"))
  if !g:ftpfirstlogin
    call PrintLineAfter("cd ".g:ftpcurrentdir, line("$"))
  endif
  call PrintLineAfter(a:cmdstr, line("$"))
  call PrintLineAfter("quit", line("$"))
  execute "w!"
  execute "bd!"
  execute "b".bc
  execute "r!ftp -s:_ftpcmd"
  call delete(fn)
  normal gg
  set ch=1
endfunction


" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
