" **guibufwn.vim**
" 
" Buffer list menu for gui-vim. Source this file to make a menu
" that contains the currently loaded buffers, to choose from. The 
" menu is updated every time when you enter vim, when a buffer is 
" loaded or a new file is created.
"
" Note: when you tear-off the buffer list menu, this works fine, 
" until it is updated, then the menu is emptied (:unmenu Buffers), 
" so the menu dissapears, and you have to tear it off again.
"
" ----------------------------------------------------------------------------- 
if !exists("_guibufwn_vim_sourced_")
let _guibufwn_vim_sourced_=1
" ----------------------------------------------------------------------------- 
so ~\array.vim
so ~\buffun.vim
so ~\strfun.vim

menu Buffers.None <shift>

augroup guibuflist
  au!
  au bufreadpost * :call GuiBufList()<cr>
  au bufnewfile * :call GuiBufList()<cr>
  au vimenter * :call GuiBufList()<cr>
augroup END

let guibuflist_oldnames=""

function! GuiBufList()
  let names=BufNamesArr()
  if names!=g:guibuflist_oldnames
    if match(g:guibuflist_oldnames,"_buflist")<0
      let g:guibuflist_oldnames=names
      let nums=BufNumsArr()
      unmenu Buffers
      let i=0
      while i<=(ArrLen(nums)-1)
        let fn=ArrGet(names,i)
        execute "nmenu &Buffers.".StrFileName(fn)."\\.".StrFileExt(fn)." :b".ArrGet(nums,i)."<cr><c-g>"
        let i=i+1
      endwhile
    endif
  endif
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
