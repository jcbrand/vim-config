" **josfix.vim**
"
" Quickfix for use with tex. 
"
" MAPS:
"
"  ,fi   Enter fix mode.
" 
"       When editing a tex file test.tex, compile it, and hit
"       ,fi to view a buffer containing a list of errors. In this
"       _fix file, hit e to edit the file containing the error, 
"       on the indicated line.
"
" NOTE:
" 
"       For now, all the tex files must be in the current directory.
" 
" -----------------------------------------------------------------------------
map ,fi :call FixFile(expand("%:r").".log")<cr>
" -----------------------------------------------------------------------------
if !exists("_josfix_vim_sourced")
let _josfix_vim_sourced=1
" -----------------------------------------------------------------------------
so ~/array.vim

aug fix
  au!
  au bufenter _fix nm e :call FixEdit()<cr>
  au bufleave _fix nun e
  au bufenter _fix :call FixSyntax()<cr>
  au bufleave _fix :so ~/_vimrc
aug END

fu! FixSyntax()
  syn match Fix +^.*:\d*:+
  hi Fix ctermfg=green guifg=green
endf

fu! FixTexGetErr(fn)
  set ch=6|let b=bufnr("%")
  let errm=""|let cfn=g:arrnew
  if filereadable(a:fn)|exe "w!|e!".a:fn|end
  exe "normal ".line("$")."J"
  let s=matchstr(getline("."),"\\( (\\|)\\| ! \\| l\\.\\).*$")
  wh s!=""
    let s2=strpart(s,0,2)
    if s2==" !"
      let em=matchstr(s,"^[^.]*\\.")
      let em=strpart(em,2,strlen(em))
    elseif s2==" ("
      let name=matchstr(strpart(s,2,strlen(s)),"^[^ ^)]*\\( \\|)\\)")
      let cfn=ArrAppend(cfn,strpart(name,0,strlen(name)-1))
    elseif strpart(s,0,1)==")"
      let cfn=ArrPart(cfn,0,ArrLen(cfn)-1)
    elseif s2==" l"
      let m=matchend(s,"l\\.\\d*")
      let errm=errm.ArrGet(cfn,ArrLen(cfn)-1).":".strpart(s,3,m-3).":".strpart(s,m,matchend(s,"l\\.\\d*[^?]*?")-m)." ".em."\n"
    end
    let s=strpart(s,matchend(s," (\\|)\\| ! \\| l\\."),strlen(s))
    let s=matchstr(s,"\\( (\\|)\\| ! \\| l\\.\\).*$")
  endwh
  exe "bd!|b".b
  set ch=1
  return errm
endf

fu! FixFile(fn)
  let errm=FixTexGetErr(a:fn)
  set ch=5
  let b=bufnr("%")
  let @z=errm
  if filereadable("_fix")
    call delete("_fix")
  endif
  exe "w!|e!_fix"
  exe g:bufclear
  exe "norm \"zP"
  exe "w!"
  set ch=1
endf

fu! FixEdit()
  let a=ArrGetItems(getline("."),":")
  exe "e!".ArrGet(a,0)."|".ArrGet(a,1)
endf
" -----------------------------------------------------------------------------
endif
" -----------------------------------------------------------------------------
