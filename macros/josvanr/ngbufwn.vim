" **ngbufwn.vim**
" 
" Buffer list menu for nongui-vim. Source this file to make a menu
" that contains the currently loaded buffers, to choose from. The 
" menu is updated every time when you enter vim, when a buffer is 
" loaded or a new file is created.
"
" ----------------------------------------------------------------------------- 
if !exists("_ngbufwn_vim_sourced_")
let _ngbufwn_vim_sourced_=1
" ----------------------------------------------------------------------------- 
so ~\array.vim
so ~\buffun.vim
so ~\strfun.vim
so ~\ngmenu.vim

call Menu("Buffers_None","x") 

augroup ngbuflist
  au!
  au bufenter _menu :call NGBufList()<cr>
augroup END

let ngbuflist_oldnames=""
let ngbuflist_dontdisplay="_menu\\|_dir\\|_buflist"

function! NGBufList()
  let names=fnamemodify(BufNamesArr(g:ngbuflist_dontdisplay),":gs?/?XXXSLYYY?:gs?\\?XXXBSLYYY?:gs?_?XXXUYYY?")
  if (names!=g:ngbuflist_oldnames)||(!exists("g:Menus_Buffers"))
    let g:ngbuflist_oldnames=names
    let nums=BufNumsArr(g:ngbuflist_dontdisplay)
    call UnMenu("Buffers",1)
    let i=0
    while i<=(ArrLen(nums)-1)
      let fn=ArrGet(names,i)
      execute "call Menu(\"Buffers_".fn."\",\":b".ArrGet(nums,i)."\\r\")"
      let i=i+1
    endwhile
  endif
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
