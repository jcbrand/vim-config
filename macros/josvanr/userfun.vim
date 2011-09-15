" **userfun.vim**
" 
" Generate a syntax file for highlighting your own functions.
" 
" MAPS: 
" 
"  ,,s   Update the syntax file ~/mysyntaxfile.vim for the function! s 
"        occurring in the current .vim file.

" -----------------------------------------------------------------------------
map ,,s :call SynFileUpdate()<cr>
" ----------------------------------------------------------------------------- 
if !exists("_userfun_vim_sourced")
let _userfun_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\buffun.vim
so ~\fun.vim
so ~\strfun.vim
so ~\txtfun.vim

let synfile="~/mysynfile.vim"

au bufenter *.vim,_vimrc* execute "so ".synfile

hi VimUserfuns guifg=darkblue gui=NONE cterm=NONE ctermfg=darkcyan
hi link VimUserfun VimUserfuns

" Syntax files for current file
map ,,h :call SynUserFunHi()<cr>
map ,,H :call SynUserFunHiUpdate()<cr>


" Return an array with commands for highlighting the 
" userfuncions of the current .vim file
function! SynUserFuns()
  let ol=line(".")
  let oc=col(".")
  let syncoms=""
  let i=1
  wh i<line("$")
    call ToCol(1)
    exe i
    exe "normal viW\"zy"
    if ((@z=="function!")||(@z=="fu!"))
      exe "normal Wviw\"zy"
      let syncoms=syncoms."syn keyword VimUserFun ".@z."\n"
    endif
    let i=i+1
  endwh
  exe ol
  call ToCol(oc)
  return syncoms
endfunction

" Make a syntax file for highlighting the user functions
" in the current myfile.vim file. Syntax file is called 
" myfile.syn and is located in the same dir as the file.
function! SynUserFunFile()
  let a=SynUserFuns()
  let fn=expand("%:p:r").".syn"
  let bn=bufnr("%")
  call delete(fn)
  execute "e!".fn
  call PrintLineAfter(a)
  execute "w!"
  execute "bd!"
  execute "b".bn
endfunction

" Do highlight the user functions of the current file. 
" Use existing syntax file if possible.
function! SynUserFunHi()
  let fn=expand("%:p:r").".syn"
  if !filereadable(fn)
    call SynUserFunFile()
  endif
  execute "so ".fn
endfunction
"
function! SynUserFunHiUpdate()
  let fn=expand("%:p:r").".syn"
  call SynUserFunFile()
  execute "so ".fn
endfunction

function! SynFileUpdate()
  let fn=expand("%:t")
  let str1='"<'.fn."\n"
  let str2='">'.fn."\n"
  let comstr=str1.SynUserFuns().str2
  let bn=bufnr("%")
  execute "e!".g:synfile
  let str1='"<'.fn
  let str2='">'.fn
  execute "normal /".str1."\r"
  if getline(".")==str1
    execute "normal dd"
    while getline(".")!=str2
      execute "normal dd"
    endwhile
    execute "normal dd"
  endif
  execute "normal G"
  call PrintLineAfter(comstr)
  execute "w!"
  execute "bd!"
  execute "b".bn
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
