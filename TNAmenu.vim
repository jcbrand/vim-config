" Make sure the '<' flag is not included in 'cpoptions', otherwise <CR> would
" not be recognized.  See ":help 'cpoptions'".
"
let cpo_save = &cpo
let &cpo = ""
"
" ===================================================================
" TNA menu. Jean Jordaan (rgo_anas@rgo.sun.ac.za)
" ===================================================================
"
" Hierdie menu en toetskombinasies is bedoel vir die redigeer van
" die hiperteks-versie van die Tydskrif vir Nederlands en Afrikaans.
"
" ===================================================================
"
"      Selekteer volgende veld (die velde word aangegee deur [teks])
"        
  40nmenu TNA.Volgende\ Veld\ (_vv)       /[<C-M>v/]<C-M>
  40imenu TNA.Volgende\ Veld\ (_vv)       <Esc>/[<C-M>v/]<C-M>
" Gebruik die n register
" 40nmenu TNA.Hernommer\ notas            /#n<C-M>l"np<C-A>
" Vervang <blok> met <FONT color="#AD5C00"> en voeg by </FONT> aan die einde van die paragraaf
  40nmenu TNA.Maak\ langer\ aanhaling     /<blok><C-M>vels<FONT color="#AD45C00"><Esc>A</FONT><Esc>0
  40nmenu TNA.Maak\ opskrif               /<opskrif><C-M>vels<H2><FONT SIZE="+3" COLOR="#4080aa"><Esc>A</FONT></H2><Esc>0
" Vervang spesiale karakters met entiteit-kodes (werk tans net met nomagic en noignorecase)
" NB: _entities mapped in html.vim
  40nmenu TNA.Entiteit-kodes ;entities
" Voeg markup by note
  40nmenu TNA.Note          :%s?#n\([1-9]\+\)?<A HREF="#n\1"><IMG SRC="nota.gif" width="17" height="16" ALT="[Nota \1]" border="0"></A>?g<C-M>
" Fix note aan einde van die teks
"
" Restore the previous value of 'cpoptions'.
let &cpo = cpo_save
unlet cpo_save
