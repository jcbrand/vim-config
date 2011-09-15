" **hiarg.vim**
"
" SUMMARY
"
"    Higlight arguments of current function.
" 
" MAPS
"
"    ,h  Toggle highlight on arguments of vim or c function in which 
"        cursor is positioned.
"
" USAGE
"
"     Put your cursor inside a c or vim function, and press ,h to call
"     the function Hiarg(). This looks for the head of the function, 
"     searches for all arguments, and colors them green.
" 

" ------------------------------------------------------------------------------ 
if !exists("_hiarg_vim_sourced")
let _hiarg_vim_sourced=1
" ------------------------------------------------------------------------------ 
let hiarg_toggle=0

aug hiarg
  au!
  au bufenter *.vim,*vimrc* let hiarg_f="\\(fu!\\|function!\\)"
  au bufenter *.vim,*vimrc* let hiarg_a="\\<[^,^ .]*\\>"
  au bufenter *.vim,*vimrc* let hiarg_p="a:"
  au bufenter *.c,*.cc let hiarg_f="\\(int\\|long int\\|float\\|double\\|void\\)"
  au bufenter *.c,*.cc let hiarg_a="\\<[^,^ .]*\\>"
  au bufenter *.c,*.cc let hiarg_p=""
  au bufenter *.vim,*vimrc* nm ,h :call Hiarg()<cr>
  au bufenter *.c,*.cc nm ,h :call Hiarg()<cr>
  au bufleave *.vim,*vimrc* nun ,h
aug END

fu! Hiarg()
  let g:hiarg_toggle=!g:hiarg_toggle
  let histr=""
  let l=line(".")|let c=col(".")
  exe "?".g:hiarg_f
  let s=getline(".")|let ls=strlen(s)
  let s=strpart(s,matchend(s,g:hiarg_f."[^(.]*("),ls)
  let n=matchend(s,g:hiarg_a)
  wh n>-1
    let histr=histr.g:hiarg_p.matchstr(s,g:hiarg_a)."\\|"
    let s=strpart(s,n+1,ls)
    let n=matchend(s,g:hiarg_a)
  endwh
  let histr=strpart(histr,0,strlen(histr)-2)
  if hlexists("Hiarg")
    syn clear Hiarg
  endif
  if (strlen(histr)>0)&&g:hiarg_toggle
    exe "syn match Hiarg +".histr."+"
    hi Hiarg ctermfg=green
  end
  exe l."|norm ".c."|"
endf
" ------------------------------------------------------------------------------ 
endif
" ------------------------------------------------------------------------------ 
