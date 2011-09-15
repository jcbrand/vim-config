"  **setup.vim**   
"                                                                       
"                                                                       
" SUMMARY:                                                              
"                                                                       
"      Edit your settings, using a tab-leafe setup editor.  Collect     
"      settings from multiple files.                                    
"                                                                       
" 
" MAPS:                                                                 
"                                                                       
"      Normal mode:                                                     
"                                                                       
"          ,s       Open the setup editor.                              
"                                                                       
"      In the editor window:                                            
"                                                                       
"          Normal mode:                                                 
"                                                                       
"          r,R      Enter replace mode,                                 
"           s       Save changes and quit the editor,                   
"           q       Quit, don't save,                                   
"         <space>   Cycle tab leafs,                                    
"           j,k     Browse items,                                       
"          <tab>    Show alternative values,                            
"          <cr>     Accept change on current line,                      
"          <cr>     On a PRESS_RETURN label: execute command,           
"          <esc>    Redraw tab leaf.                                    
"                                                                       
"                                                                       
"          Insert and replace mode:                                     
"                                                                       
"          <esc>    Discard change (hit <esc> again from normal mode,   
"                   to redraw the tab leaf, or hit <cr> to accept the   
"                   change anyway),                                     
"          <cr>     Accept the change (but don't save yet).             
"                                                                       
"                                                                       
" EDITOR:                                                               
"                                                                       
"       Hit ,s from normal mode, to open a window containing a 'user    
"       interface' for editing your settings and mappings, that looks   
"       something like:                                                 
"                                                                       
"    _________  _______  _________  ___________  ___________  ________  
"   / Scripts \/ Files \/ Editing \/ Apperance \/ Behaviour \/ Colors \ 
"  /__________/________/__________/             \____________\_________\_____
"  |                                                                    
"  | A comment                                                          
"  |                                                                    
"  |    Show a ruler............................:1                      
"  |    Show current mode.......................:1                      
"  |    Abbreviate messages.....................:at                     
"  |                                                                    
"  |    An executable command...................:PRESS_RETURN           
"  |                                                                    
"  | Press ,? for help, q=quit, s=save & quit.                          
"                                                                       
"       In this window, browse the tab leafs using the MAPS listed      
"       above, and edit the values of the settings. These are colored   
"       cyan. <Tab> lets you cycle pre defined alternate settings.      
"       Hitting return, causes modified settings to be stored in memory,
"       hitting escape cancels an edit.  Save changes to file using s,  
"       or quit with q. Hitting return on a PRESS_RETURN label, causes
"       a command to be executed.
" 
"                                                                       
" SETUP FILES:                                                          
"                                                                       
"   Import files                                                    
"                                                                       
"       Settings can be imported from a number of different files,      
"       customize the global variable setup_files for this: (See HERE.) 
"                                                                       
"             let setup_files=Arr("settings.vim","filex.vim")           
"                                                                       
"       to modify settings in two files.                                
"
"                                                                       
"   Leaf items                                                      
"                                                                       
"       To use the setup editor on your files, add a commented line before
"       the settings like this:                                         
"                                                                       
"            "|ID|Leaf|Item|set tw=||40|50|60|                             
"            set tw=50                                                    
"                                                                       
"       |ID|       is an identifier, given as a parameter to the        
"                  SetupEditor. The editor only processes lines         
"                  containing this ID.  This enables you to separately  
"                  edit groups of settings, or eg.  SETTINGS and        
"                  MAPPINGS.                                            
"                                                                       
"       |Leaf|     is the leaf, where this setting is to be put, eg.    
"                  |Apperance|.                                         
"                                                                       
"       |Item|     is the text appearing with the setting, eg.          
"                  |Show a ruler|.                                      
"                                                                       
"       |set tw=|  use this to specify the format of the setting. The   
"                  editor leaves this in the settings file, and uses    
"                  everything that appears after it as an argument.     
"
"       ||         This is put after the 'set tw='. Use this eg. for 
"                  mappings. Example: |ID|Leaf|My map|map | dd|x|y|z|
"                  for the command 'map x dd', with alternatives y and z
"                  to be put in place for the x.
"                                                                       
"       |40|50|60| are alternate values that can be cycled using the    
"                  <tab> key.                                            
"
"       With this syntax in a commented line before a setting in your
"       setup file, the value of the setting will be read upon starting
"       the setup editor, and displayed in the specified leaf. It can 
"       then be edited, and written back to the settings file.
"                                                                       
"                                                                       
"   Executable items                                                
"                                                                       
"       To add an executable item, use the syntax:                      
"                                                                       
"            "|ID|Leaf|Display a friendly message|X|:echo "Hello!"<cr>|  
"                                                                       
"       and in the leaf, the item is displayed, with a PRESS_RETURN      
"       label.  Hit return on this label to execute the command (:echo  
"       "Hello!"<cr>) in this case. The command is a normal mode map.
"       Upon hitting return, the editor is leaft, and the map is executed.
"                                                                       
"                                                                       
"   Leaf comments                                                   
"                                                                       
"       To show a comment in the leaf (like 'A comment' in the leaf     
"       displayed above, use the syntax:                                
"                                                                       
"          "|ID|Leaf|A comment|%|                                       
"                                                                       
"       Ie: use |%| for the setting format. This will cause 'A comment' 
"       to be displayed in the leaf, as a comment. To make an empty line,
"       just use:
"          
"          "|ID|Leaf||%|
"                                                                       
"                                                                       
"   Comments in setup file                                          
"                                                                       
"       Lines that don't start with :ID: are ignored, which allows you  
"       to add comments, or conditional statements like 'if has("unix")'
"       etc.                                                            
"                                                                       
" NOTES:                                                                
"                                                                       
"       * After leaving the editor, the file ~/_vimrc is sourced, to     
"         restore your normal mappings. Customize this HERE1.           
"                                                                       
"       * Some .vim files are included HERE2, get them from             
"         http://www.dse.nl/~josvanr                                    
"                                                                       
" BUGS:                                                                 
"                                                                       
"       * For now, item names on one leaf must be unique. Work-around:  
"         to use the    same names anyway, use an extra space after the 
"         item, ie.     |This item| and |This item | are distinct, but  
"         almost look the same. Will change later.                                      
"       * Don't use a . in an item name, unless it's a comment.
"                                                                       
" TODO:                                                                 
"                                                                       
"       * Clean up variables after usage!                               
"       * De-spaghettify code.                                          
"       * Make ArrAppendG function.                                     
"                                                                       
" ----------------------------------------------------------------------------
map ,s :call SetupEditor(setup_files,setup_group,"\\\"")<cr>j
" Note: the j after the mapping is for positioning the cursor at the 
" first item after entering the editor. Doesn't work when I put it in 
" the function itself.
" ----------------------------------------------------------------------------
if !exists("_setup_vim_sourced")
let _setup_vim_sourced=1
" ----------------------------------------------------------------------------
" Source some files HERE2
so ~/array.vim
so ~/arrayg.vim
so ~/fun.vim
so ~/strfun.vim
so ~/tableaf.vim

" Import settings from these files HERE:
let setup_files=Arr("settings.vim","_vimrc","map.vim")                
let setup_group="SETTINGS"
let setup_alt=0
let g:setup_altit=""

fu! SetupRead(fn,id,cp)
  let id_leafs=g:arrnew
  let b=bufnr("%")
  let nf=ArrLen(a:fn)|let f=0
  wh f<nf
    let ch=&ch|set ch=10
    let fnf=ArrGet(a:fn,f)
    exe "e! ".fnf
    let n=line("$")|let i=1
    wh i<=n
      let s=getline(i)
      if match(s,"^".a:cp."|".a:id."|")==0
        let a=ArrGetItems(s,"|")
        let la=ArrLen(a)
        let lu=fnamemodify(ArrGet(a,2),":gs? ?_?")
        let x=a:id."_".lu
        if ArrFindExact(id_leafs,lu)<0
          let id_leafs=ArrAppend(id_leafs,lu)
          call ArrNewG(x."_item",x."_val",x."_com",x."_file",x."_line",x."_post")
        end
        let post=ArrGet(a,5)
        let com=ArrGet(a,4)
        call ArrAppendG(x."_item",ArrGet(a,3))
        call ArrAppendG(x."_com",com)
        call ArrAppendG(x."_file",fnf)
        call ArrAppendG(x."_post",post)
        let com1=strpart(com,0,1)
        if com1=="%"
          let val=""
        elseif com1=="X"
          let val="PRESS_RETURN"
        else
          let i=i+1|let s=getline(i)
          let ncom=strlen(com)
          let ns=strlen(s)
          let val=fnamemodify(strpart(s,ncom,ns),":gs?\\?\\\\?")
          let val=strpart(s,ncom,ns-strlen(post)-ncom)
        end
        call ArrAppendG(x."_line",i)
        call ArrAppendG(x."_val",val)
        if la>7
          let nth=ArrLenG(x."_val")-1
          call ArrNewG(x."_alt_".nth)
          let nn=la-1
          let ii=6
          wh ii<nn
            let alt=ArrGet(a,ii)
            call ArrAppendG(x."_alt_".nth,alt)
            let ii=ii+1
          endwh
        endif
      end
      let i=i+1
    endwh
    exe "bd!".fnf
    let f=f+1
    let &ch=ch
  endwh
  exe "let g:".a:id."_leafs=id_leafs"
  exe "b ".b
endf

fu! SetupWrite(id)
  let files=g:arrnew|let leafs=a:id."_leafs"
  let n=ArrLenG(leafs)|let i=0
  wh i<n
    let leaf=ArrGetG(leafs,i)
    let x=a:id."_".leaf."_"
    let val=x."val"|let com=x."com"|let line=x."line"|let post=x."post"|let file=x."file"
    let m=ArrLenG(val)|let j=0
    wh j<m
      let comj=ArrGetG(com,j)
      if (comj!="%")&&(comj!="X")
        let fnj=ArrGetG(file,j)
        if fnj!=expand("%")
          let ch=&ch|let &ch=10
          exe "w!|e!".fnj
          let &ch=ch
          if ArrFindExact(files,fnj)<0
            let files=ArrAppend(files,fnj)
          end
        end
        call setline(ArrGetG(line,j),comj.ArrGetG(val,j).ArrGetG(post,j))
      endif
      let j=j+1
    endwh
    let i=i+1
  endwh
  let ch=&ch|set ch=5
  w!
  let &ch=ch
  let n=ArrLen(files)|let i=0
  let ch=&ch|let &ch=10
  wh i<n
    exe "w!|bd! ".ArrGet(files,i)
    let i=i+1
  endwh
  let &ch=ch
endf

fu! SetupLeafs(id)
  let leafs=a:id."_leafs"|let leafc=a:id."_leafc"
  call ArrNewG(leafc)
  let n=ArrLenG(leafs)|let i=0
  wh i<n
    let leaf=ArrGetG(leafs,i)
    let x=a:id."_".leaf."_"|let val=x."val"|let com=x."com"|let item=x."item"
    call ArrAppendG(leafc,x."leaf")
    let m=ArrLenG(val)|let j=0
    let w=" |\n"
    wh j<m
      let itemj=ArrGetG(item,j)
      if ArrGetG(com,j)=="%"
        let w=w." | ".itemj."\n"
      else
        let w=w." |    ".itemj.StrNTimesChar(".",40-strlen(itemj)).":".ArrGetG(val,j)."\n"
      end
      let j=j+1
    endwh
    let w=w.g:setup_help
    exe "let g:".x."leaf=w"
    let i=i+1
  endwh
  exe "let g:".a:id."_nleafs=ArrLenG(leafs)"
endf

fu! SetupChange(cln)
  let leafs=g:setup_id."_leafs"
  exe "let id_leafs=g:".g:setup_id."_leafs"
  let leaf=ArrGetG(leafs,a:cln)
  let x=g:setup_id."_".leaf."_"|let val=x."val"|let item=x."item"
  let s=getline(".") 
  let itemj=matchstr(s,"\\<[^.]*")
  let valj=matchstr(s,":.*$")
  let valj=strpart(valj,1,strlen(valj))
"   let valj=fnamemodify(valj,":gs?\\?\\\\\\?") "?
  let valj=fnamemodify(valj,":gs?\"?\\\\\"?")
  if valj=="PRESS_RETURN"
    exe "let mapstr=g:".g:setup_id."_".leaf."_post"
    let mapstr=ArrGet(mapstr,ArrFindExactG(item,itemj))
    exe "map _setupexe- :bd!<cr>".mapstr
  else
    nm _setupexe- <nop>
    call ArrSetG(val,valj,ArrFindExactG(item,itemj))
    echo "Value has been changed."
  end
endf

fu! SetupAlt(cln)
  let leafs=g:setup_id."_leafs"
  let leaf=ArrGetG(leafs,a:cln)
  let x=g:setup_id."_".leaf."_"|let item=x."item"
  let itemj=matchstr(getline("."),"\\<[^.]*")
  let j=ArrFindExactG(item,itemj)
  let alt=x."alt_".j
  if exists("g:".alt)
    if g:setup_altit!=j
      let g:setup_alt=0
      let g:setup_altit=j
    endif
    if g:setup_alt==ArrLenG(alt)-1
      let g:setup_alt=0
    else
      let g:setup_alt=g:setup_alt+1
    end
    let @z=ArrGetG(alt,g:setup_alt)|norm 0f:lD"zp0f:l
    echo "Press return to accept change or escape to discard."
  else
    echo "No alternatives available."
  endif
endf

fu! SetupEditor(fn,id,cp)
  let g:setup_d=getcwd()
  let g:setup_f=expand("%")
  let g:setup_id=a:id
  exe "cd ".expand("~")
  e!_setup
  call SetupRead(a:fn,a:id,a:cp)
  call SetupLeafs(a:id)
  call SetupDispLeaf(0)
endf

fu! SetupQuitEditor()
  let ch=&ch|set ch=15
  bd! _setup
  if filereadable("_setup")
    call delete("_setup")
  end
  let &ch=ch
  let n=ArrLen(g:setup_files)|let i=0
  wh i<n
    exe "so ~/".ArrGet(g:setup_files,i)
    let i=i+1
  endwh
  let ch=&ch|set ch=15
  exe "cd ".g:setup_d
  if exists(g:setup_f)
    exe "e ".g:setup_f
  end
  let &ch=ch
endf

fu! SetupDispLeaf(n)
  exe "let id_nleafs=g:".g:setup_id."_nleafs"
  if a:n==id_nleafs
    let g:setup_curleaf=0
  else
    let g:setup_curleaf=a:n
  endif
  exe g:bufclear
  exe "let @z=Tableaf(g:".g:setup_id."_leafs,g:".g:setup_id."_leafc,g:setup_curleaf)"
  norm "zP
endf

fu! SetupSyntax()
  syn match Setup_titles /\/ [^/^\.]* \\/hs=s+1,he=e-1
  hi Setup_titles ctermfg=yellow
  syn match Setup_items /|.*:/hs=s+1 contains=Setup_values
  hi Setup_items ctermfg=white
  syn match Setup_values /:.*$/hs=s+1 
  hi Setup_values ctermfg=cyan
endf

aug setted
  au!
  au bufenter _setup let setup_hl=&hlsearch|let &hlsearch=0
  au bufleave _setup let &hlsearch=setup_hl
  au bufenter _setup nm <space> :call SetupDispLeaf(setup_curleaf+1)<cr>j
  au bufleave _setup nun <space>
  au bufenter _setup nnoremap j j0/:<cr>l
  au bufleave _setup nun j
  au bufenter _setup nnoremap k 0?:<cr>0f:l
  au bufleave _setup nun k
  au bufenter _setup im <cr> <esc>:call SetupChange(setup_curleaf)<cr>
  au bufleave _setup iu <cr>
  au bufenter _setup inoremap <esc> <esc>:echo "Press escape to undo or return to accept anyway."<cr>
  au bufleave _setup iun <esc>
  au bufenter _setup nm <esc> :call SetupDispLeaf(setup_curleaf)<cr>j
  au bufleave _setup nun <esc>
  au bufenter _setup nm <cr> :call SetupChange(setup_curleaf)<cr>_setupexe-
  au bufleave _setup nun <cr>
  au bufenter _setup nm s :call SetupWrite(setup_id)<cr>:call SetupQuitEditor()<cr>
  au bufleave _setup nun s
  au bufenter _setup nm q :call SetupQuitEditor()<cr>
  au bufleave _setup nun q
  au bufenter _setup nm ,? :echo setup_helpx<cr>
  au bufleave _setup nun ,?
  au bufenter _setup nm r R
  au bufleave _setup nun r
"   au bufenter _setup nm n :call SetupAlt(setup_curleaf)<cr><cr>
  au bufenter _setup nm n :call SetupAlt(setup_curleaf)<cr>
  au bufleave _setup nun n
  au bufenter _setup nm <tab> n
  au bufleave _setup nun <tab>
  au bufenter _setup call SetupSyntax()
" Customize HERE1 to restore your mappings after leaving the editor.
  au bufleave _setup so ~/_vimrc
aug END

let w=" |\n"
let w=w." |\n"
let w=w." |  Press ,? for help, space=next leaf, q=quit, s=save & quit.\n |\n |\n"
let setup_help=w

let w="\n"
let w=w." -----------------------------------------------------------------\n"
let w=w."  Setup editor help.\n"
let w=w." -----------------------------------------------------------------\n"
let w=w."\n"
let w=w."    From normal mode: \n"
let w=w."\n"
let w=w."                <space>  Cycle leafs,\n"
let w=w."                 <tab>   Cycle items,\n"
let w=w."                  j,k    Browse items,\n"
let w=w."                   s     Save changes to file and quit, \n"
let w=w."                   q     Quit editor, discard changes.\n"
let w=w."\n"
let w=w."    From insert or replace mode:\n"
let w=w."\n"
let w=w."                  <cr>   Accept change (but don't save yet),\n"
let w=w."                 <esc>   Discard change.\n"
let w=w."\n"
let w=w."   Cycle tab leafs and items, and customize the settings. Take care,\n"
let w=w."   not to remove the : and not to change any of the labels.\n"
let w=w." ------------------------------------------------------------------\n"
let setup_helpx=w
" ----------------------------------------------------------------------------
endif
" ----------------------------------------------------------------------------
