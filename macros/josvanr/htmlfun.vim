" **htmlfun.vim**
"
" SUMMARY:
"
"   Functions for html editing.
"
" -----------------------------------------------------------------------------
imap ,h <c-o>:call HtmlTag()<cr>
" ----------------------------------------------------------------------------- 
if !exists("_htmlfun_vim_sourced")
let _htmlfun_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\buffun.vim
so ~\fun.vim
so ~\strfun.vim
so ~\txtfun.vim

" Generate a html tag pair
function! HtmlTag()
  let x=input("HTML Tag:")
  let @b="<".x.">"
  let @c="<\/".x.">"
  normal "bp"cpbhh
endfunction

" Enclose some words in a pair of html tags
let htmltagpairclose=""
function! HtmlTagPairOpen()
  let x=input("HTML Tag:")
  let g:htmltagpairclose=x
  normal b
  call InsertWord("<".x.">")
endfunction

function! HtmlTagPairClose()
  let x=g:htmltagpairclose
  call AppendWord("</".x.">")
endfunction

" Specify the tagname, and put the open-tag
nmap ,< :call HtmlTagPairOpen()<cr>
" Put the close-tag
nmap ,> :call HtmlTagPairClose()<cr>

" Smaller than and greater than sign.
augroup htmledit
  au!
  au bufenter *.htm,*.html imap ,< &lt
  au bufleave *.htm,*.html iunmap ,<
  au bufenter *.htm,*.html imap ,> &gt
  au bufleave *.htm,*.html iunmap ,>
augroup END
" Add a html link to the location stored in the windows clipboard
" (external link)                                                               
map ,al :let @a='<a href="'.@*.'" target="_top"></a>'<cr>"ap
map ,aL :let @a='<li><a href="'.@*.'" target="_top"></a>'<cr>"ap
" Add internal link to loc. in reg 0
map ,il :let @a='<a href="#'.@".'"></a>'<cr>"ap

" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
