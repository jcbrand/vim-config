" **ngmenu.vim**
" 
" Source this file to use menus in the console version of vim.
" 
" FUNCTIONS
" 
" call Menu("File_Open",":w")  Add a menu File, submenu Open, mapped to :w.
" call UnMenu("File_Open",1)   Remove a menu tree or a command say.
" 
" MAPS
"  
"    Normal mode:
" 
"    q    open a window showing the main menu, and open the first submenu.
" 
"    From the menu-window:
" 
"    w,h  open the menu to the right,left of current menu.
"     u   show the top level menu.
"    j,k  move downward,upward in a menu.
"   <cr>  go into a submenu, or execute a command.
" 
" NOTES:
" 
"  * Special symbols: use the following sequences for some special symbols:
" 
"       XXXSLYYY     for /
"       XXXBSLYYY    for \
"       XXXUYYY      for _
" 
"    E.g. if you want an item test\file in the File menu, say:
" 
"       call Menu("File_testXXXBSLYYYfile","themap")
" 
"  * Default menus are defined in the file ngmdef.vim. This file is 
"    sourced in this file. Modify if necessary, or source other
"    menu files. Maybe say: 
" 
"        if has("gui")
"          so guimenu.vim
"        else
"          so ngmenu.vim
"        endif
" 
"    whatever.
"
"  Bad news:
"  
"  * there is only one menu structure for all modes.
" 
"  Good news:
" 
"  * there is a non-gui version of the buffer-menu: a menu
"    containing all currently loaded buffers (see ngbufwn.vim)                  
" 
" -----------------------------------------------------------------------------
nm q :call MenuOpenWin()<cr><cr>j
" ----------------------------------------------------------------------------- 
if !exists("_ngmenu_vim_sourced")
let _ngmenu_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\array.vim

if has("gui")||has("unix")
  let menu_hlinestyle="-"
  let menu_hmenusep="--"
  let menu_vlinestyle="|"
  let menu_lowleftcorner="*"
  let menu_lowrightcorner="*"
else
  let menu_hlinestyle="Ä"
  let menu_hmenusep="ÄÄ"
  let menu_vlinestyle="³"
  let menu_lowleftcorner="À"
  let menu_lowrightcorner="Ù"
endif

let menu_hmenuseplength=strlen(menu_hmenusep)
let menu_linewidth=79
let menu_leftmargin="  "
let menu_rightmargin=" "
let menu_nmargin=3

augroup ngmenu
  au!
  au bufenter _menu set nohlsearch
  au bufleave _menu set hlsearch
  au bufenter _menu nm <cr> :call MenuExecute()<cr>_menucommand-
  au bufleave _menu nun <cr>
  au bufenter _menu nmap <esc> :bd!<cr>
  au bufleave _menu nun <esc>
  au bufenter _menu nm u :call MenuOpenWin()<cr>
  au bufleave _menu nun u
  au bufenter _menu exe "nmap w :let c=col(\".\")<cr>u:call ToCol(c)<cr>/".menu_hmenusep."[a-zA-Z]\r".menu_hmenuseplength."l<cr>j"
  au bufleave _menu nun w
  au bufenter _menu exe "nmap h :let c=col(\".\")<cr>u:call ToCol(c)<cr>?".menu_hmenusep."[a-zA-Z]\rn".menu_hmenuseplength."l<cr>j"
  au bufleave _menu nun h
  au bufenter _menu nm <right> w
  au bufleave _menu nun <right>
  au bufenter _menu nm <left> h
  au bufleave _menu nun <left>
  au bufenter _menu nm <space> w
  au bufleave _menu nun <space>
  au bufleave _menu so ~/_vimrc
augroup END

function! Menu(itemstr,themap)
  if !exists("g:Menus")
    let g:Menus=g:arrnew|let g:Map_Menus=g:arrnew
  endif
  let g:items=fnamemodify(a:itemstr,":gs? ?XXXSYYY?:gs?\\.?XXXDOTYYY?:gs?<?XXXSTYYY?:gs?>?XXXLTYYY?:gs?".g:menu_hlinestyle."?XXXHYYY?")
  let g:items=ArrGetItems("Menus_".g:items,"_")
  let g:lastlevel=ArrLen(g:items)-1
  let g:themap=a:themap
  call MenuRecurse("Menus",1)
endfunction

function! MenuRecurse(curarrname,level)
  let curitname=ArrGet(g:items,a:level)
  execute "let curarr=g:".a:curarrname
  if (a:level==g:lastlevel)
    if ArrFindExact(curarr,curitname)>-1
      echo 'Item already exists.'
    else
      execute "let g:".a:curarrname."=ArrAppend(g:".a:curarrname.",'".curitname."')"
      execute "let g:Map_".a:curarrname."=ArrAppend(g:Map_".a:curarrname.",':bd!<cr>".g:themap."')"
    endif
  else
    let afe=ArrFindExact(curarr,curitname)
    execute "let arrexists=exists(\"g:".a:curarrname."_".curitname."\")"
    if (afe>=0)&&(!arrexists)
      echo 'Item already exists.'
    else
      if afe<0
        execute "let g:".a:curarrname."=ArrAppend(g:".a:curarrname.",'".curitname."')"
        execute "let g:Map_".a:curarrname."=ArrAppend(g:Map_".a:curarrname.",':let g:menu_curmenu=\"".a:curarrname."_".curitname."\"\r:call MenuOpen(".a:curarrname."_".curitname.")\r')"
        execute "let g:".a:curarrname."_".curitname."=g:arrnew"
        execute "let g:Map_".a:curarrname."_".curitname."=g:arrnew"
      else 
      endif
      execute "call MenuRecurse(\"".a:curarrname."_".curitname."\",a:level+1)"
    endif
  endif
endfunction

" Ret a string with formatted horizontal menu 
" ret. horizontal positions in global array menu_colarr
function! MenuDispHStr(menuarr)
  let g:menu_colarr=g:arrnew
  let i=0
  let str=g:menu_hmenusep
  let menuarr=fnamemodify(a:menuarr,":gs?XXXSYYY? ?:gs?XXXSLYYY?/?:gs?XXXBSLYYY?\\?:gs?XXXDOTYYY?.?:gs?XXXUYYY?_?:gs?XXXSTYYY?<?:gs?XXXLTYYY?>?:gs?XXXHYYY?".g:menu_hlinestyle."?")
  while i<=ArrLen(menuarr)-1
    let g:menu_colarr=ArrAppend(g:menu_colarr,strlen(str))
    let str=str.ArrGet(menuarr,i).g:menu_hmenusep
    let i=i+1
  endwhile
  let str=str.StrNTimesChar(g:menu_hlinestyle,g:menu_linewidth-strlen(str))
  return str
endfunction

" Ret a string with formatted vertical menu. add cols nr of whitespace
function! MenuDispVStr(menuarr,cols)
  let padcols=StrNTimesChar(" ",a:cols)
  let menuarr=fnamemodify(a:menuarr,":gs?XXXSYYY? ?:gs?XXXSLYYY?/?:gs?XXXBSLYYY?\\?:gs?XXXDOTYYY?.?:gs?XXXUYYY?_?:gs?XXXSTYYY?<?:gs?XXXLTYYY?>?:gs?XXXHYYY?".g:menu_hlinestyle."?")
  let maxlen=ArrMaxLen(menuarr) 
  let str=""
  let n=ArrLen(menuarr)-1
  let i=0
  while i<=n
    let item=ArrGet(menuarr,i)
    let pad=StrNTimesChar(" ",maxlen-strlen(item))
    let str=str.padcols.g:menu_vlinestyle.g:menu_leftmargin.g:menu_hlinestyle.item.g:menu_hlinestyle.pad.g:menu_rightmargin.g:menu_vlinestyle."\n"
    let i=i+1
  endwhile
  let str=str.padcols.g:menu_lowleftcorner.StrNTimesChar(g:menu_hlinestyle,maxlen+g:menu_nmargin+2).g:menu_lowrightcorner
  return str
endfunction

function! MenuOpen(menu)
  let curcol=col(".")
  execute g:bufclear
  call PrintLineBefore(MenuDispHStr(g:Menus))
  call PrintLineAfter(MenuDispVStr(a:menu,curcol-3),1)
  let n=ArrLen(a:menu)+2
  execute "resize ".n
  execute "normal ".(curcol+3)."|"
endfunction

function! MenuOpenWin()
  if !exists("g:_ngmdef_vim_sourced")
    so ~\ngmdef.vim
  endif
  if expand("%:t")!="_menu"
    1sp! _menu
  endif
  let g:menu_curmenu="Menus"
  execute g:bufclear
  call PrintLineOver(MenuDispHStr(g:Menus))
  let m=ArrGet(g:Menus,0)
  normal 3|
endfunction

function! MenuExecute()
  execute "normal ?".g:menu_hlinestyle."\rlv/".g:menu_hlinestyle."\rh\"zy"
  let select=fnamemodify(@z,":gs? ?XXXSYYY?:gs?/?XXXSLYYY?:gs?\\?XXXBSLYYY?:gs?\\.?XXXDOTYYY?:gs?_?XXXUYYY?:gs?<?XXXSTYYY?:gs?>?XXXLTYYY?:gs?".g:menu_hlinestyle."?XXXHYYY?")
  execute "let curmenu=g:".g:menu_curmenu
  execute "let curmaps=g:Map_".g:menu_curmenu
  let n=ArrFindExact(curmenu,select)
  execute "map _menucommand- ".ArrGet(curmaps,n)
endfunction

" Call this one with second argument=1
function! UnMenu(str,rmcommand)
if a:str==""
    if exists("g:Menus")
      let arr=g:Menus
      let i=0
      while i<ArrLen(arr)
        call UnMenu(ArrGet(arr,i),1)
        let i=i+1
      endwhile
    endif
else 
  let str="Menus_".a:str
  execute "let e=exists(\"g:".str."\")"
  if e
    execute "let e=g:".str
    let i=0
    while i<=(ArrLen(e)-1)
      execute "call UnMenu(\"".a:str."_".ArrGet(e,i)."\",0)"
      let i=i+1
    endwhile
    execute "unlet g:".str
    execute "unlet g:Map_".str
  endif
  if a:rmcommand
    let ix=match(str,"_[^_]*$")
    let n=strlen(str)-1
    let cmdstr=strpart(str,ix+1,n-ix+1)
    let arrstr=strpart(str,0,ix)
    execute "let ix=ArrFindExact(g:".arrstr.",\"".cmdstr."\")"
    execute "let g:".arrstr."=ArrDelIx(g:".arrstr.",".ix.")"
    execute "let g:Map_".arrstr."=ArrDelIx(g:Map_".arrstr.",".ix.")"
  endif
endif
endfunction
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
