" **funuse.vim**
"
" Search for functions in which a given function is called:
"
"    call FunuseName("MyFunction")
"
" Echo the lines where MyFunction is called and the first lines
" of the functions from where it is called. 
" 
" MAPS:
" 
"      ,ff              Find the functions from which the function under 
"                       the cursor is called.
"                                                                               
" EXAMPLE: 
"
" Hit ,ff on the word 'getline' in this file, and you see:
"
" 42: function! FunuseName(funstr)                                              
" 43:       let use=line(".").": ".getline(".")."\n"                            
"                                                                               
" 42: function! FunuseName(funstr)                                              
" 52:       let out=out.line(".").": ".getline(".")."\n".use."\n"               
"                                                                               
" NOTE: the function uses a search pattern string (g:funuse_patt), for  
" detecting the start of a function. In augroup funuse, search pattern  
" strings are defined for vim-files and for c-files.                                                    
"                                                                       
" -----------------------------------------------------------------------------
map ,ff :echo FunuseName(expand("<cword>"))<cr>
" ----------------------------------------------------------------------------- 
if !exists("_funuse_vim_sourced_")
let _funuse_vim_sourced_=1
" ----------------------------------------------------------------------------- 
augroup funuse
  au!
  au bufenter *.c,*.cc,*.cpp,*.h,*.hpp let funuse_patt="^\\(int\\|long int\\|float\\|double\\|void\\)"
  au bufenter *.vim,_vimrc* let funuse_patt="^function"
augroup END

" Return a string containing all first lines of the functions where funstr is
" called from.
function! FunuseName(funstr)
  let out=""
  execute "normal mzG?^\\s\\+.*".a:funstr."\rma"
  let last=line(".")
  if last<line("$")
    normal gg
    while line(".")<last
      execute "normal /^\\s\\+.*".a:funstr."\rma"
      let use=line(".").": ".getline(".")."\n"
      execute "normal ?".g:funuse_patt."\r"
      let out=out.line(".").": ".getline(".")."\n".use."\n"
      normal `a
    endwhile
  endif
  normal `z
  return out
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
