"=============================================================================
" File : findfile.vim
" Author : M A Aziz Ahmed (aziz@123india.com)
" Last update : Mon Dec 06 1999
" Version : 1.0
"-----------------------------------------------------------------------------
" This file implements a macro to find a file starting from a directory.
" Usage:  :FF startDirectory filePattern
" Latest version available at: http://www.freespeech.org/aziz/vim/my_macros/
"-----------------------------------------------------------------------------
" Send bugs, suggestions to : aziz@123india.com
"=============================================================================

func! SearchFile(dir, filePat)
  let files=expand(a:dir."/*")."\n"
  let files=substitute(files,"\\","/","g")
  let files=substitute(files,"//","/","g")
  while (files!="")
    let nextFile=Pop(files, "\\n")
    if (match(substitute(nextFile, ".*/\\(.\\+\\)", "\\1", ""), a:filePat)!=-1)
      echo nextFile
    endif
    if (isdirectory(nextFile))
      call SearchFile(nextFile, a:filePat)
    endif
    let files=substitute(files, ".\\{-}\n", "", "")
  endwhile
endfunction

func! Pop(array, fieldSep)
  let firstEntry=substitute(a:array, "\n.*", "", "")
  return firstEntry
endf

func! FindFile(startDir, pat)
  let noLastSlash=substitute(a:startDir,"/$","\\1","")
  call SearchFile(noLastSlash, a:pat)
endf

com! -nargs=* FF call FindFile(<f-args>)
