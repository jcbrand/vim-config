" **compile.vim**
"
" SUMMARY:
"
"   Compile programs in various languages.
"
" MAPS:
"
"  ,;   Compile current project file.
"  ,,;  Execute the compiled file. 
"
" NOTE:
"
"  The project file is the currently loaded file, unless
"  the global variable 'project' is defined:
" 
"    let project="test.c"
"
"  in which case that is the file to be compiled.
"
" -----------------------------------------------------------------------------
if !exists("_compile_vim_sourced")
let _compile_vim_sourced=1
" -----------------------------------------------------------------------------
let project=""
let compile_file=""

augroup compiletex
  au!
  au bufenter *.tex nm ,; :call CompileLatex()<cr>
  au bufenter *.tex nm ,,; :exe "!gv ".compile_file<cr>
  au bufenter *.c, nm ,; :call CompileC()<cr>
  au bufenter *.cc,*.cpp nm ,; :call CompileCC()<cr>
  au bufenter *.c nm ,,; :!./a.out<cr>
  au bufenter *.cc,cpp nm ,,; :!./a.out > out<cr>:e out<cr>
  au bufenter *.pl,*.pm nm ,; :call CompilePerl()<cr>
  au bufenter *.vim,*vimrc* nm ,; :so % <cr>
  au bufenter *.htm* nm ,; :so go.vim<cr>
augroup END

fu! CompileFile()
  if g:project==""
    let g:compile_file=expand("%")
  else
    let g:compile_file=g:project
  end
endf

fu! CompileLatex()
  w!
  call CompileFile()
  let fn=fnamemodify(g:compile_file,":r")
  exe "!latex --interaction nonstopmode ".fn
  exe "!dvips ".fn.".dvi"
endf

fu! CompileC()
  w!
  call CompileFile()
  set makeprg=gcc
  set errorformat=%f:%l:\ %m
  exe "make ".g:compile_file
endf

fu! CompileCC()
  w!
  call CompileFile()
  set makeprg=g++
  set errorformat=%f:%l:\ %m
  exe "make ".g:compile_file
endf

fu! CompilePerl()
  w!
  call CompileFile()
  exe "!./".g:compile_file
endf

fu! CompileHtml()
  w!
  so go.vim
endf
" -----------------------------------------------------------------------------
endif
" -----------------------------------------------------------------------------
