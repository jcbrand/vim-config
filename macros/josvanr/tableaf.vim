" **tableaf.vim**
"
" SUMMARY:
"
"    Display tab leafs using ascii characters, for making a gui. 
"
" FUNCTIONS:
" 
"       string=Tableaf(titlesarray,contentsarray,n)
"
"    Returns a formatted string, containing the tableafs, with the n-th
"    tableaf on the foreground eg. for n=3:
" 
"    _______  _______  _______  _______  _______  
"   / Leaf0 \/ Leaf1 \/ Leaf2 \/ Leaf3 \/ Leaf4 \
"  /________/________/________/         \________\____________________
"
"    The titles 'Leaf0', 'Leaf1' etc. are supplied in the titlesarray, 
"    (see |array.vim|) eg:
" 
"       let titlesarray=Arr("First title","Second")
"
"    The contents of the tab leafs, is supplied through a series of 
"    globally defined strings, the names of which are given in the 
"    contentsarray, eg:
"
"       let contentsarray=Arr("First_string,"Second_string")
"
"    then, calling the Tableaf function with n=0 will display 
"    the first leaf on the foreground, with contents First_string.
"    To display empty leafs, use contentsarray="".
"
"    Note, that when the leaf titles get too wide to fit on the screen, 
"    all titles but the n-th one, are compacted. Eg. calling Tableaf
"    with an array containing the titles "This title is too long to fit"
"    four times, and n=2, results in:
"
"    _______  __________  _______________________________  __________  
"   / This  \/ This tit \/ This title is too long to fit \/ This tit \
"  /________/___________/                                 \___________\
" 
"    The leafs automatically ajust to the number of columns in the screen.
"
" --------------------------------------------------------------------------
if !exists("_tableaf_vim_sourced")
let _tableaf_vim_sourced=1
" --------------------------------------------------------------------------
so ~/array.vim
so ~/strfun.vim

fu! Tableaf(titles,contents,n)
  let topline="   "
  let titline="  "
  let botline=" "
  let titles=a:titles
  let ntits=ArrLen(titles)
  let buf=ArrGet(titles,a:n)|let nbuf=strlen(buf)+ntits
  let titles=ArrSet(titles,"",a:n)
  wh (strlen(titles)+nbuf)>&co
    let ns=ArrMaxLenIx(titles)
    let sstr=ArrGet(titles,ns)
    let titles=ArrSet(titles,strpart(sstr,0,strlen(sstr)-3),ns)
  endwh
  let titles=ArrSet(titles,buf,a:n)
  let i=0
  wh i<ntits
    let ni=strlen(ArrGet(titles,i))
    let topline=topline.StrNTimesChar("_",ni+2)."  "
    let titline=titline."/ ".ArrGet(titles,i)." \\"
    let linekin=StrNTimesChar("_",ni+2)
    let spacekin=StrNTimesChar(" ",ni+2)
    if i==0
      if a:n==0
        let addstr="/  ".spacekin
      else
        let addstr="/_".linekin
      end
    else
      if a:n==i
        let addstr="/  ".spacekin
      elseif i>a:n
        let addstr="\\_".linekin
      elseif i<a:n
        let addstr="/_".linekin
      end
    end
    let botline=botline.addstr
    let i=i+1
  endwh
  let botline=botline."\\".StrNTimesChar("_",&columns-strlen(botline)-2)
  let contents=""
  if strlen(a:contents)>0
    exe "let contents=g:".ArrGet(a:contents,a:n)
  end
  return topline."\n".titline."\n".botline."\n".contents
endf
" --------------------------------------------------------------------------
endif
" --------------------------------------------------------------------------
