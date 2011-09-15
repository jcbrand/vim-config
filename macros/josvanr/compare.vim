" **compare.vim**
" 
" SUMMARY
" 
"   Compare two files by synchronizing the displaying position of files 
"   in split windows. 
" 
" FUNCTIONS
" 
"   CompAlign(): Synchronize windows.
"   CompMode():  Toggle synchronization mode.
" 
" MAPPINGS
" 
"   ,sy  Toggle Synchronization mode.
" 
" NOTE: EXPERIMENTAL
" 
so ~/array.vim

map ,sy :call CompMode()<cr>

let comp_keys=Arr("j","k","h","l","<page-up>","<page-down>","<c-e>","<c-y>")
let comp_nkeys=ArrLen(comp_keys)-1
let comp_mode=0

fu! CompMode()
  if g:comp_mode==0
    let g:comp_mode=1
    let i=0
    wh i<=g:comp_nkeys
      let k=ArrGet(g:comp_keys,i)
      exe "noremap ".k." ".k.":call CompAlign()<cr>"
      let i=i+1
    endwh
"     echo "Entering compare mode!"
  else
    let g:comp_mode=0
    so ~/_vimrc
    echo "Leaving compare mode!"
  end
endf

fu! CompAlign()
  let cl=line(".")
  let cc=col(".")
  norm H
  let hl=line(".")
  let hc=col(".")
  norm wH
  exe hl."|norm ".hc."|zt"
  exe cl."|norm ".cc."|"
  norm w
  exe cl."|norm ".cc."|"
endf
