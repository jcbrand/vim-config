" ==================================================================
" Mappings om die omsit van TNA na HTML te vergemaklik
" Actually this is now applies more to the maintainance of the site as a
" whole.
" 
" Author:       Jean Jordaan
" Date:         1998
" Last update:  990306 01:35:52
" ==================================================================
"
"   Edit this file
  nmap ,ta :e$vim/macros/tna.vim<C-M>
"   Done editing this file
  nmap ,tb :w<C-M>:so%<C-M>:bd<C-M>
" 
"   Skuif aan na volgende veld en highlight dit.
  iab  _vv  <Esc>/[<C-M>v/]<C-M>
  nmap _vv  /[<C-M>v/]<C-M>
"
  iab Yafrndl http://www.sun.ac.za/afrndl/
"
  nmap ,stamp / [0-9]\{6}wves<C-R>=strftime("%y%m%d")<CR><Esc>
"
"   Wys 'n hulpskerm
  nmap <F1> :new:so $vim/syntax/html.vim:r $vim/macros/tnahelp.html:set nomod
"
" <F2>   Insert blank nota
" iab Ynota <A HREF="#n"><IMG SRC="nota.gif" width="17" height="15" ALT="[Nota]" border="0"></A>
"   Maak van 'n <B>asdf<P></B> reël 'n opskrif (register o bevat die HTML vir 'n opskrif)
" nmap <F2> "oP/<B>v/>xv/<P></B>h"zxv$x?\[Opskrif\]<C-M>velx"zPO<Esc>jo<Esc>
"   Maak van 'n <H3><B>asdf</B></H3><P> reël 'n opskrif (register o bevat die HTML vir 'n opskrif)
  nmap <F2> "oP/<H3><B>v/>nxv/</B></H3><P>h"zxv$x?\[Opskrif\]<C-M>velx"zPO<Esc>jo<Esc>
"   Formateer 'n gewone paragraaf
  nmap <F3> I	v/<p>gqoj
"   Formateer 'n aangehaalde paragraaf
  nmap <F4> I	<FONT color="#AD5C00">v/<p>gq$hhi</font>oj
"   Maak van 'n geselekteerde blok <b>outeur</b> verwysing<p> 'n bibliografie
  vmap <F5> :s?^<b>\(.\+\)</b>?<FONT color="#4080aa">\1</font>?<C-M>
"   Hernommer notas. Laat register n = 0 om mee te begin.
  nmap <F6>   /#n<C-M>l"np<C-A>?[^1-9]<C-M>lv/[^1-9]<C-M>h"ny
"   Maak van 'n teks-file met n onderdelings n verskillende .html files. Die
"   files word geskei deur hul serial-nommers gevolg deur -=-=-=-=-= en 'n
"   blanko lyn.
  nmap <F7> /-=-=-=0v/-h"syddkddVgg"rx:new <C-R>s.html"rpggdd:w<C-F4>
