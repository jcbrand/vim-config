"=============================================================================
" File : explorer.vim
" Author : M A Aziz Ahmed (aziz@123india.com)
" Last update : Sun Feb 20 2000
" Version : 1.0
"-----------------------------------------------------------------------------
" This file implements a file explorer. Latest version available at:
" http://www.freespeech.org/aziz/vim/my_macros/
"-----------------------------------------------------------------------------
" Just type ,e to launch the file explorer (this file should have been
" sourced) in a separate window. Type ,s to split the current window and
" launch explorer there. If the current buffer is modified, the window is
" anyway split (irrespective of ,e or ,s).
" It is also possible to delete files and rename files within explorer.
" (In UNIX, renaming doesn't seem to work, though!)
"=============================================================================

nmap ,e   :call Initiate(0)<cr>
nmap ,s   :call Initiate(1)<cr>
 
function! Initiate(split)
  if (@%=="_fileExplorer.tmp")
    echo "Already in file explorer"
  else
    let g:oldCh=&ch
    let &ch=2
    call InitializeDirName()
    if ((&modified==1) || (a:split==1))
      sp _fileExplorer.tmp
      let b:splitWindow=1
    else
      e _fileExplorer.tmp
      let b:splitWindow=0
    endif
    call ProcessFile("./")
  endif
endfunction

function! InitializeDirName()
  "let g:currDir=escape(substitute(getcwd(),"\\","/","g"), ' ')."/"
  let g:currDir=(substitute(getcwd(),"\\","/","g"))."/"
  " In case the ending / was already a part of getcwd(), two //s would appear
  " at the end of g:currDir. So remove one of them
  let g:currDir=substitute(g:currDir,"//$","/","g")
endfunction

function! ProcessFile(fileName)
  if (isdirectory(g:currDir.a:fileName))
    "Delete all lines
    1,$d
    let oldRep=&report
    set report=1000
    if (a:fileName=="../")
      let g:currDir=substitute(g:currDir,"/[^/]*/$","/","")
    elseif (a:fileName!="./")
      let g:currDir=g:currDir.a:fileName
    endif
    call AddHeader()
    " Add parent directory if not root
    if (isdirectory(g:currDir."../"))
      t.|s/^.*$/..\//
    endif
    call DisplayFiles(g:currDir)
    normal zz
    echo "Loaded contents of ".g:currDir
    let &report=oldRep
  elseif (filereadable(g:currDir.a:fileName))
    exec("e! ".escape((g:currDir.a:fileName), ' '))
    call CloseExplorer()
    exec("cd ".escape(g:currDir, ' '))
  endif
  let &modified=0
endfunction

function! GetFileName()
  return getline(".")
endfunction

function! AddHeader()
    " Give a very brief help
    " Give a very brief help
       s/^.*$/\"<enter> : open file or directory/
    t.|s/^.*$/\"q : quit file explorer   d : delete file/
    t.|s/^.*$/\"c : change directory     r : rename file/
    " Insert a line below (I am not comfortable using the normal command for
    " insertion :-()
    t.|s/^.*$/\"---------------------------------------------------/
    let @f="\"".g:currDir
    put f
    t.|s/^.*$/\"---------------------------------------------------/
endfunction

function! DisplayFiles(dir)
  let @f=expand(a:dir."*")
  if (@f!="")
    normal mt
    put f
    .,$g/^/call MarkDirs(a:dir)
    normal `t
  endif
endfunction

function! MarkDirs(dir)
  let oldRep=&report
  set report=1000
  "Remove slashes if added
  s;/$;;e  
  "Removes all the leading slashes and adds slashes at the end of directories
  s;^.*\\\([^\\]*\)$;\1;e
  s;^.*/\([^/]*\)$;\1;e
  normal ^
  if (isdirectory(a:dir.GetFileName()))
    s;$;/;
  endif
  let &report=oldRep
endfunction

function! DeleteFile()
  let fileName=g:currDir.GetFileName()
  if (isdirectory(fileName))
    echo "Directory deletion not supported yet"
  else
    let sure=input("Delete ".fileName."?(y/n) ")
    echo " "
    if (sure=="y")
      let success=delete(fileName)
      if (success!=0)
        echo "Cannot delete ".fileName
      else
        echo "Deleted ".fileName
        d
      endif
    else
      echo "Deletion of ".fileName." cancelled"
    endif
  endif
  let &modified=0
endfunction

function! RenameFile()
  let fileName=g:currDir.expand("<cWORD>")
  if (isdirectory(fileName))
    echo "Directory renaming not supported yet"
  elseif (filereadable(fileName))
    let altName=input("Rename ".fileName." to : ")
    echo " "
    let success=rename(fileName, g:currDir.altName)
    if (success!=0)
      echo "Cannot rename ".fileName. " to ".altName
    else
      echo "Renamed ".fileName." to ".altName
      let oldRep=&report
      set report=1000
      exec("s/^\\S*$/".altName."/")
      let &report=oldRep
    endif
  endif
  let &modified=0
endfunction

command! -nargs=+ -complete=dir ChangeDirectory call GotoDir(<f-args>)
function! GotoDir(dummy, dirName)
  if (isdirectory(a:dirName))
    exec "cd ".a:dirName
    call InitializeDirName()
    call ProcessFile("./")
  else
    echo g:currDir.a:dirName." : No such directory"
  endif
endfunction

function! CloseExplorer()
  bd! _fileExplorer.tmp
  let &ch=g:oldCh
endfunction

function! Back2PrevFile()
  if ((@#!="") && (@#!="_fileExplorer.tmp") && (b:splitWindow==0))
    exec("e #")
  endif
  call CloseExplorer()
endfunction

augroup fileExplorer
  au!
  au bufenter _fileExplorer.tmp nm <cr> :call ProcessFile(GetFileName())<cr>
  au bufleave _fileExplorer.tmp nun <cr>
  au bufenter _fileExplorer.tmp nm c :ChangeDirectory to: 
  au bufleave _fileExplorer.tmp nun c
  au bufenter _fileExplorer.tmp nm r :call RenameFile()<cr>
  au bufleave _fileExplorer.tmp nun r
  au bufenter _fileExplorer.tmp nm d :call DeleteFile()<cr>
  au bufleave _fileExplorer.tmp nun d
  au bufenter _fileExplorer.tmp nm q :call Back2PrevFile()<cr>
  au bufleave _fileExplorer.tmp nun q
augroup end
