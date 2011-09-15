" Vim
" HTMLHCmd $Revision: 2.7 $

" Himgsrc:
" HTML_imgsrc: Change input lines into HTML <img src="input"> tags
"
" Supported options include:
"   n (mneumonic=Name)         use input to also add <a name> tag
"   N (mneumonic=Name no ext)  use input to also add <a name> tag w/o ext
"   h (mneumonic=Href)         use input as href component
"   H (mneumonic=Href no ext)  use input as href component w/o ext
"   s (mneumonic=Src)          use input as src component
"   S (mneumonic=Src no ext)   use input as src component w/o ext
"   a (mneumonic=Alt)          use input as alt component
"   A (mneumonic=Alt no ext)   use input as alt component w/o ext
"   t (mneumonic=Text)         use input as text between tags
"   T (mneumonic=Text no ext)  use input as text between tags w/o ext
"   l (mneumonic=List Item)    do add a leading <li> tag
"   j (mneumonic=Join)         do not add a trailing <br> tag
"   1 (mneumonic=h1)           add surrounding h1 tags
"   2 (mneumonic=h2)           add surrounding h2 tags
"   3 (mneumonic=h3)           add surrounding h3 tags
"   4 (mneumonic=h4)           add surrounding h4 tags
"   5 (mneumonic=h5)           add surrounding h5 tags
"   6 (mneumonic=h6)           add surrounding h6 tags
"
" Input is is assumed to be a range of lines consisting of filespecs
" with no leading whitespace but optional trailing whitespace.  All
" characters from the last period to the optional trailing whitespace
" are considered to be the extension portion of the filespec.
"
" For debugging add the following line after the actual repstr
" definition so the sub-expressions parsed from the input line
" are displayed.
"let repstr='cap1="\1"\rcap2="\2"\rcap3="\3"\rcap4="\4"'
"
function! HTML_imgsrc(...) range abort
  if a:0 == 0
    let mode="s"
  else
    let mode=a:1
  endif
  let patstr='^\(\s*\)\(.\{-}\)\(\.\w\+\)\=\s*$'
  let ind='\1'
  let fnbase='\2'
  let fnfull='\2\3'
  let hrefbeg=''
  let hrefend=''
  let li=''
  let name=''
  let src=fnfull
  let alt=''
  let text=''
  let br='<br>'
  let ic=&ignorecase
  set noignorecase
  if mode =~ 'l' 
    let li='<li>'
  endif
  if mode =~ 'n' 
    let name='<a name="'.fnfull.'"></a>\r'
  endif
  if mode =~ 'N' 
    let name='<a name="'.fnbase.'"></a>\r'
  endif
  if mode =~ 'h' 
    let hreflnk='#'.fnfull
    let hrefbeg='<a href= "'.hreflnk.'">'
    let hrefend='</a>'
  endif
  if mode =~ 'H' 
    let hreflnk='#'.fnbase
    let hrefbeg='<a href= "'.hreflnk.'">'
    let hrefend='</a>'
  endif
  if mode =~ 's' 
    let src=fnfull
  endif
  if mode =~ 'S' 
    let src=fnbase
  endif
  if mode =~ 'a' 
    let alt=' alt="'.fnfull.'"'
  endif
  if mode =~ 'A' 
    let alt=' alt="'.fnbase.'"'
  endif
  if mode =~ 't' 
    let text=fnfull
  endif
  if mode =~ 'T' 
    let text=fnbase
  endif
  if mode =~ '1' 
    let text='<h1>'.text.'</h1>'
  endif
  if mode =~ '2' 
    let text='<h2>'.text.'</h2>'
  endif
  if mode =~ '3' 
    let text='<h3>'.text.'</h3>'
  endif
  if mode =~ '4' 
    let text='<h4>'.text.'</h4>'
  endif
  if mode =~ '5' 
    let text='<h5>'.text.'</h5>'
  endif
  if mode =~ '6' 
    let text='<h6>'.text.'</h6>'
  endif
  if mode =~ 'j' 
    let br=''
  endif
  let &ignorecase=ic
  let repstr=ind.name.li.hrefbeg.'<img src="'.src.'"'.alt.'>'.text.hrefend.br
  let cmd=':s!'.patstr.'!'.repstr.'!'
  exe a:firstline . "," . a:lastline . cmd
endfunction
command! -ra -na=?   Himgsrc <line1>,<line2>call HTML_imgsrc(<f-args>)

" Haname: 
" HTML_aname: Change input lines into HTML <a name="input"> tags
"
" Supported options include:
"   n (mneumonic=Name)         use input as name to use as label
"   N (mneumonic=Name no ext)  use input as name to use as label w/o ext
"   h (mneumonic=Href)         use input as href component
"   H (mneumonic=Href no ext)  use input as href component w/o ext
"   s (mneumonic=Src)          use input as src component
"   S (mneumonic=Src no ext)   use input as src component w/o ext
"   a (mneumonic=Alt)          use input as alt component
"   A (mneumonic=Alt no ext)   use input as alt component w/o ext
"   t (mneumonic=Text)         use input as text between tags
"   T (mneumonic=Text no ext)  use input as text between tags w/o ext
"   j (mneumonic=Join)         do not add a trailing <br> tag
"   1 (mneumonic=h1)           add surrounding h1 tags
"   2 (mneumonic=h2)           add surrounding h2 tags
"   3 (mneumonic=h3)           add surrounding h3 tags
"   4 (mneumonic=h4)           add surrounding h4 tags
"   5 (mneumonic=h5)           add surrounding h5 tags
"   6 (mneumonic=h6)           add surrounding h6 tags
"
" Input is is assumed to be a range of lines consisting of filespecs
" with no leading whitespace but optional trailing whitespace.  All
" characters from the last period to the optional trailing whitespace
" are considered to be the extension portion of the filespec.
"
" For debugging add the following line after the actual repstr
" definition so the sub-expressions parsed from the input line
" are displayed.
"let repstr='cap1="\1"\rcap2="\2"\rcap3="\3"\rcap4="\4"'
"
function! HTML_aname(...) range abort
  if a:0 == 0
    let mode="nj"
  else
    let mode=a:1
  endif
  let patstr='^\(\s*\)\(.\{-}\)\(\.\w\+\)\=\s*$'
  let ind='\1'
  let fnbase='\2'
  let fnfull='\2\3'
  let name=fnfull
  let text=''
  let br='<br>'
  let ic=&ignorecase
  set noignorecase
  if mode =~ 'n' 
    let name=fnfull
  endif
  if mode =~ 'N' 
    let name=fnbase
  endif
  if mode =~ 't' 
    let text=fnfull
  endif
  if mode =~ 'T' 
    let text=fnbase
  endif
  if mode =~ '1' 
    let text='<h1>'.text.'</h1>'
  endif
  if mode =~ '2' 
    let text='<h2>'.text.'</h2>'
  endif
  if mode =~ '3' 
    let text='<h3>'.text.'</h3>'
  endif
  if mode =~ '4' 
    let text='<h4>'.text.'</h4>'
  endif
  if mode =~ '5' 
    let text='<h5>'.text.'</h5>'
  endif
  if mode =~ '6' 
    let text='<h6>'.text.'</h6>'
  endif
  if mode =~ 'j' 
    let br=''
  endif
  let &ignorecase=ic
  let repstr=ind.'<a name="'.name.'">'.text.'</a>'.br
  let cmd=':s!'.patstr.'!'.repstr.'!'
  exe a:firstline . "," . a:lastline . cmd
endfunction
command! -ra -na=?   Haname <line1>,<line2>call HTML_aname(<f-args>)

" Hahref:
" HTML_ahref: Change input lines into HTML <a href="input"> tags
"
" Supported options include:
"   n (mneumonic=Name)         use input as name to use as label
"   N (mneumonic=Name no ext)  use input as name to use as label w/o ext
"   h (mneumonic=Href)         use input as href component
"   H (mneumonic=Href no ext)  use input as href component w/o ext
"   s (mneumonic=Src)          use input as src component
"   S (mneumonic=Src no ext)   use input as src component w/o ext
"   a (mneumonic=Alt)          use input as alt component
"   A (mneumonic=Alt no ext)   use input as alt component w/o ext
"   t (mneumonic=Text)         use input as text between tags
"   T (mneumonic=Text no ext)  use input as text between tags w/o ext
"   l (mneumonic=List Item)    do add a leading <li> tag
"   j (mneumonic=Join)         do not add a trailing <br> tag
"   1 (mneumonic=h1)           add surrounding h1 tags
"   2 (mneumonic=h2)           add surrounding h2 tags
"   3 (mneumonic=h3)           add surrounding h3 tags
"   4 (mneumonic=h4)           add surrounding h4 tags
"   5 (mneumonic=h5)           add surrounding h5 tags
"   6 (mneumonic=h6)           add surrounding h6 tags
"
" Input is is assumed to be a range of lines consisting of filespecs
" with no leading whitespace but optional trailing whitespace.  All
" characters from the last period to the optional trailing whitespace
" are considered to be the extension portion of the filespec.
"
" For debugging add the following line after the actual repstr
" definition so the sub-expressions parsed from the input line
" are displayed.
"let repstr='cap1="\1"\rcap2="\2"\rcap3="\3"\rcap4="\4"'
"
function! HTML_ahref(...) range abort
  if a:0 == 0
    let mode="h"
  else
    let mode=a:1
  endif
  let patstr='^\(\s*\)\(.\{-}\)\(\.\w\+\)\=\s*$'
  let ind='\1'
  let fnbase='\2'
  let fnfull='\2\3'
  let name=''
  let href=fnfull
  let li=''
  let text=''
  let br='<br>'
  let ic=&ignorecase
  set noignorecase
  if mode =~ 'n' 
    let name='#'.fnfull
    if mode !~ '[hH]' 
      let href=''
    endif
  endif
  if mode =~ 'N' 
    let name='#'.fnbase
    if mode !~ '[hH]' 
      let href=''
    endif
  endif
  if mode =~ 'h' 
    let href=fnfull
  endif
  if mode =~ 'H' 
    let href=fnbase
  endif
  if mode =~ 'l' 
    let li='<li>'
  endif
  if mode =~ 't' 
    let text=fnfull
  endif
  if mode =~ 'T' 
    let text=fnbase
  endif
  if mode =~ '1' 
    let text='<h1>'.text.'</h1>'
  endif
  if mode =~ '2' 
    let text='<h2>'.text.'</h2>'
  endif
  if mode =~ '3' 
    let text='<h3>'.text.'</h3>'
  endif
  if mode =~ '4' 
    let text='<h4>'.text.'</h4>'
  endif
  if mode =~ '5' 
    let text='<h5>'.text.'</h5>'
  endif
  if mode =~ '6' 
    let text='<h6>'.text.'</h6>'
  endif
  if mode =~ 'j' 
    let br=''
  endif
  let &ignorecase=ic
  let repstr=ind.li.'<a href="'.href.name.'">'.text.'</a>'.br
  let cmd=':s!'.patstr.'!'.repstr.'!'
  exe a:firstline . "," . a:lastline . cmd
endfunction
command! -ra -na=?   Hahref <line1>,<line2>call HTML_ahref(<f-args>)

" Hskel: Source htmlskel.vim script which will embed the current file in 
" basic web page skeleton.  The current file will be in the body section
" below a simple header section template.
"
if version >= 600
  command! Hskel runtime htmlskel.vim
else
  command! Hskel source $VIM/vimfiles/htmlskel.vim
endif

" Hunquot:
" HTML_unquot: recover input line by deleting everything but the
" first quoted string on each line.
"
function! HTML_unquot() range abort
  let cmd=':s!^[^"]*"\([^"]\+\)".*$!\1!'
  exe a:firstline . "," . a:lastline . cmd
endfunction
command! -ra -na=0   Hunquot <line1>,<line2>call HTML_unquot()

" Hescangbrackets:
" HTML_escangbrackets: Change angle brackets already present in the input
" to the appropriate HTML entities.
"
function! HTML_escangbrackets() range abort
  let range=a:firstline.",".a:lastline
  exe range.'s!>!\&gt;!ge'
  exe range.'s!<!\&lt;!ge'
endfunction
command! -ra -na=0   Hescangbrackets <line1>,<line2>call HTML_escangbrackets()

" Hescampersand:
" HTML_escangbrackets: Change ampersand, '&', already present in the input
" to the appropriate HTML entity.
"
function! HTML_escampersand() range abort
  let range=a:firstline.",".a:lastline
  exe range.'s/&/\&amp;/ge'
endfunction
command! -ra -na=0   Hescampersand <line1>,<line2>call HTML_escampersand()

" Hesc:
" HTML_esc: Change angle brackets and ampersands '&' already present
" in the input to the appropriate HTML entities.
"
function! HTML_esc() range abort
  let range=a:firstline.",".a:lastline
  exe range.'s/&/\&amp;/ge'
  exe range.'s!>!\&gt;!ge'
  exe range.'s!<!\&lt;!ge'
endfunction
command! -ra -na=0   Hesc <line1>,<line2>call HTML_esc()

" Hhn: 
" HTML_hn: Add <h#> and </h#> tags surrounding specified range of
" lines.  Use parameter to specify which header level to use. 
" Default is h2.
"
" Supported options include:
"   1 (mneumonic=h1)           add surrounding h1 tags
"   2 (mneumonic=h2)           add surrounding h2 tags
"   3 (mneumonic=h3)           add surrounding h3 tags
"   4 (mneumonic=h4)           add surrounding h4 tags
"   5 (mneumonic=h5)           add surrounding h5 tags
"   6 (mneumonic=h6)           add surrounding h6 tags
"
function! HTML_hn(...) range abort
  if a:0 == 0
    let mode="h"
  else
    let mode=a:1
  endif
  let ic=&ignorecase
  set noignorecase
  let ind='\1'
  let htag='h2'
  if mode =~ '1' 
    let htag='h1'
  endif
  if mode =~ '2' 
    let htag='h2'
  endif
  if mode =~ '3' 
    let htag='h3'
  endif
  if mode =~ '4' 
    let htag='h4'
  endif
  if mode =~ '5' 
    let htag='h5'
  endif
  if mode =~ '6' 
    let htag='h6'
  endif
  if mode =~ 'i' 
    let ind='\1'
  endif
  if mode =~ 'u' 
    let ind=''
  endif
  let &ignorecase=ic
  let range=a:firstline.",".a:lastline
  exe ':'.a:lastline.'s!^\(\s*\).*!&\r'.ind.'</'.htag.'>!e'
  exe ':'.a:firstline.'s!^\(\s*\).*!'.ind.'<'.htag.'>\r&!e'
endfunction
command! -ra -na=?   Hhn <line1>,<line2>call HTML_hn(<f-args>)

"
" Hprot: Protect spacing by changing all white space to non-breaking
" spaces and using a <br> tag mark the end of lines.  Change characters
" that are reserved in HTML to HTML entities.  Add surrounding
" <tt> tags to force use of a fixed font.  This is suitable where <pre>
" is unreliable because lines may be split/reformatted externally.
"
function! HTML_prot() range abort
  let range=a:firstline.",".a:lastline
  let et=&expandtab
  set expandtab
  exe range.'retab'
  let &expandtab=et
  exe ':'.range.'s/&/\&amp;/ge'
  exe ':'.range.'s/</\&lt;/ge'
  exe ':'.range.'s/>/\&gt;/ge'
  exe ':'.range.'s/ /\&nbsp;/ge'
  exe ':'.range.'v#<br>\s*$#s/$/<br>/e'
  exe ':'.a:lastline.'s!^\(\s*\).*!&\r\1</tt>!e'
  exe ':'.a:firstline.'s!^\(\s*\).*!\1<tt>\r&!e'
endfunction
command! -ra -na=0   Hprot <line1>,<line2>call HTML_prot()

"
" Hpre:
" HTML_pre: Add <pre> and </pre> tags at paragraph scope.  The <pre> tag
" is added immediately after the <p> tag and the </pre> tag is added
" immediately before the </p> tag.
"
function! HTML_pre() range abort
  let range=a:firstline.",".a:lastline
  exe ':'.range.'s!^\(\s*\)</p>!\1</pre>\r&!e'
  exe ':'.range.'s!^\(\s*\)<p\(id="[^"]*"\)\=>!&\r\1<pre>!e'
endfunction
command! -ra -na=0   Hpre <line1>,<line2>call HTML_pre()

"
" Hdiv:
" HTML_division: Add <div> and </div> tags surrounding specified range of
" lines.  Use a parameter to pass the value for the id attribute if one should
" be added.
"
function! HTML_division(...) range abort
  if a:0 >= 0
    let id=a:1
  else
    let id=""
  endif
  if strlen(id) > 0
    let id=' id="'.id.'"'
  endif
  exe ':'.a:lastline.'s!^\(\s*\).*!&\r\1</div>!e'
  exe ':'.a:firstline.'s!^\(\s*\).*!\1<div'.id.'>\r&!e'
endfunction
command! -ra -na=?   Hdiv <line1>,<line2>call HTML_division(<q-args>)

"
" Hpara:
" HTML_paragraph: Add <p> and </p> tags surrounding specified range of lines.
" Use a parameter to pass the value for the id attribute if one should be
" added.
"
function! HTML_paragraph(...) range abort
  if a:0 >= 0
    let id=a:1
  else
    let id=""
  endif
  if strlen(id) > 0
    let id=' id="'.id.'"'
  endif
  exe ':'.a:lastline.'s!^\(\s*\).*!&\r\1</p>!e'
  exe ':'.a:firstline.'s!^\(\s*\).*!\1<p'.id.'>\r&!e'
endfunction
command! -ra -na=?   Hpara <line1>,<line2>call HTML_paragraph(<q-args>)

"
" Hbr: Add trailing <br> tag to each line in input that does not already 
" have one.
"
function! HTML_br() range abort
  let range=a:firstline.",".a:lastline
  exe ':'.range.'v#<br>\s*$#s/$/<br>/e'
endfunction
command! -ra -na=0   Hbr <line1>,<line2>call HTML_br()

" Hli: Add leading <li> tag to each line in input that does not already 
" have one.  No ending tag is added.
"
function! HTML_li() range abort
  let range=a:firstline.",".a:lastline
  exe ':'.range.'v/^\s*<li>/s/^\(\s*\)/\1<li>/e'
endfunction
command! -ra -na=0   Hli <line1>,<line2>call HTML_li()

" Hvisrange: Add specified tag around visually selected area.  If available
" use visualmode() to decide how the tags should be inserted, otherwise only
" per character visual mode is sensibly supported.  Blockwise visual mode is
" switched to per character visual mode if visualmode() is available.
"
if version >= 600
  function! HTML_visualrange(tag) range abort
    let paste=&paste
    set paste
    let hold_a=@a
    let put_a="\<c-r>a"
    let visualmode=visualmode()
    if visualmode ==# 'V'
      let hold_s=@s
      let hold_e=@e
      exe "normal! '<".'"sy0'."'>".'"ey0'
      let beg_tag="\<c-r>s".'<'.a:tag.'>'
      let end_tag="\<c-r>e".'</'.a:tag.'>'
      if line("'>") == line("$")
        exe 'normal! gv"ado'.beg_tag."\<cr>\<c-r>a".end_tag."\<esc>"
      else
        exe 'normal! gv"adO'.beg_tag."\<cr>\<c-r>a".end_tag."\<esc>"
      endif
      let @s=hold_s
      let @e=hold_e
    elseif visualmode ==# "\<c-v>"
      if col("'>") == col("$")-1
        exe 'normal! gvv"ada<'.a:tag.'>'."\<c-r>a".'</'.a:tag.'>'."\<esc>"
      else
        exe 'normal! gvv"adi<'.a:tag.'>'."\<c-r>a".'</'.a:tag.'>'."\<esc>"
      end
    else
      if col("'>") == col("$")-1
        exe 'normal! gv"ada<'.a:tag.'>'."\<c-r>a".'</'.a:tag.'>'."\<esc>"
      else
        exe 'normal! gv"adi<'.a:tag.'>'."\<c-r>a".'</'.a:tag.'>'."\<esc>"
      end
    endif
    let @a=hold_a
    let &paste=paste
  endfunction
else
  function! HTML_visualrange(tag) range abort
    let paste=&paste
    set paste
    let hold_a=@a
    if col("'>") == col("$")-1
      exe 'normal! gv"ada<'.a:tag.'>'."\<c-r>a".'</'.a:tag.'>'."\<esc>"
    else
      exe 'normal! gv"adi<'.a:tag.'>'."\<c-r>a".'</'.a:tag.'>'."\<esc>"
    end
    let @a=hold_a
    let &paste=paste
  endfunction
endif
command! -ra -na=1   Hvisrange call HTML_visualrange(<q-args>)

" Hcf: Source htmlcf.vim which implements mIMG HTML abbreviations and
" menus.  This allows defining the abbreviations only when desired.
"
if version >= 600
  command! Hcf runtime htmlcf.vim
else
  command! Hcf source $VIM/vimfiles/htmlcf.vim
endif
