" ====================================================================
" Macros to massage SvA terminology text file to htmlpp database input
" ====================================================================
" 
" Maintainer: Jean Jordaan
" Last modified: 990314 14:01:10
" 
" Format of original file:
" ------------------------
" 
" term [n] <woordsoort> [ | alternatiewe ]: definisie [{redaksionele 
"                          teks}] [{{sien skakel}}] [ || alternatiewe ] 
" 
" Toeligting: 
"      [n]     as merkers vir betekenisonderskeidings (n = 1,2,3,..);
"      < >     as merkers vir woordsoortelike inligting; 
"      :       as merker tussen term en vertaling; 
"      { }     as merkers vir redaksionele teks; 
"      {{ }}   as merkers vir kruisverwysings; 
"      |       as merker tussen alternatiewe terme. 
"      ||      as merker tussen alternatiewe definisies. 
"      Die gedeeltes tussen [ en ] mag geen of meer kere voorkom.
" 
" Voorbeelde: 
" -----------
" active drive: 1. aktiewe skyf || 2. aktiewe (aan)drywer 
" add-in <b.nw.>: invoeg- ({soos in} invoeggrafiek) 
" ampersand ("&"): ampersand ("&") ({drukkersterm} || {Noot 1: Afr.
"     uitspraak, klem op} am-. || {Noot 2: Eng.} ampersand < and, per
"     se and.  
"
" Format of resulting file:
" ------------------------
" FIELDS: ID|anchor|sortkey|english|afrikaans 
"
" Note:
" ----­
" Lines may be quoted using .- in the first column. The quoted lines are
" processed (mangled) in the conversion to .hdb, but the .- remains intact and
" htmlpp ignores these lines while generating the HTML.
"
" Bewerking (preprocessing) vereis (in hierdie volgorde):
" -------------------------------------------------------
"
" Vir alfabetiese terme, maak die hooflettervorm van die eerste letter van die
" term die eerste veld:  X::
"
" Vir nie-alfabetiese terme -- met die hand: sit die afdeling waaronder die
" definisie resorteer as eerste veld in die rekord (bv. "Nommers" of "Simbole"
" ..)
"
" Die eerste : op 'n reël verander na :: (skeiding tussen definiendum en
" definiens).
"
" <xxx> verander na <em class="T_woordsoort">xxx</em>
" {{xxx}}   "     " <A HREF="#RT_xxx" class="T_kruisverwysing">xxx</A> 
" {xxx}     "     " <em class="T_redaksioneel">xxx</em>
" |  verander na <dt>
" || verander na <dd>
" 
" Verander "&" na &amp;
" Verander extended chars na HTML-entities.
" Verander "< " na "&lt; "
" 
" ====================================================

  function! MassageTerms()

  " Eerste twee velde:  xxx::Xxx* <x.>::
  " Anchor-ID en die definiens.
  "
  %s?:?::?
  " -- Replace the first : on every line of the buffer
  " -- with :: to delimit fields.

  %s?^\([0-9]*\([-A-Z a-z0-9]\+\)[^:]*\)?\L\2::\1\E::\1
  " 1. Make a lowercase field (\2) consisting of the first sequence of
  " alphanumerics, spaces and hyphens, to function as anchor.   
  " (Can't start with a number: see HTML 4.0 spec, 6.2 SGML basic types ) 
  " NB: Strip spaces later as this messes with htmlpp's anchor generation.
  " 
  " TODO This might have as result that similar terms will not have unique
  " anchors. This might be counted a feature.
  "
  " 2. Make a field consisting of the entire term lowercased for sorting. ( \1 )
  " 3. Leave the original term. 

  " Insert _RT-tagged line numbers as ID field.
  normal :g/^/execute 's/^/' . line(".") . "_RT::"

  %s/\s*::\s*/::/g
  " -- strip whitespace from around delimiters.

  g/::.*::/exe 's/::.\{-}::/'.escape(substitute(matchstr(getline('.'),'::.\{-}::'),' ','_','g'),'/')
  " -- replace spaces in anchors with underscores (see below for explanation).

  %s?\s*<.\{-}>\([^:]*\)?\2?e
  " 4. Remove the first sequence between < > (This works because at this stage,
  " there's either no such sequence, or exactly two, one of which is redundant.
  " Include e (ignore errors) options, since absence of < > is legal.)

  %s?\*\*??e
  %s?\*??e
  " 5. Remove the first * or ** from the sortkey (See 4.)

  " Tweede veld (definiens): <xxx>
  " Die woordsoort.
  %s?<\(.\{-}\)>?<em class="T_woordsoort">\1</em>
  " -- Replace the first sequence between < > ...

  " Derde veld (definiendum) (hierdie vervanging moet voor vervanging van
  " {xxx} plaasvind): {{xxx}} 
  " 'n Kruisverwysing na 'n ander term.
" This one commented until anchors for $(*..) get properly generated.
" execute '%s?{{\([^}]\+\)}}?$(*\L\1\E_RT*class="T_kruisverwysing"*=\1)?eg' 
  %s?{{\(.\{-}\)}}?<A href="{{#\L\1\E_RT}}" class="T_kruisverwysing">\1</A>?eg
  " -- Replace all between {{ }} globally, ignoring errors ...

  %s?{{\(.\{-}\)}}?{{\1}}?eg 
  g/^{{/s? ?_?eg 
  g/^{{/norm kgJgJ
  %s?[{}]??eg
  " -- replace spaces in crossrefs with underscores

  " Derde veld (definiendum):
  " Redaksionele teks: {xxx}
  %s?{\(.\{-}\)}?<em class="T_redaksioneel">\1</em>?eg
  " -- Replace all between { } globally, ignoring errors ...

  " Alternatiewe: |, ||
  %s?||?<dd>?eg
  %s?|?<dt>?eg

  " HTML entities:
  %s?&?\&amp;?eg
  %s?<\s?\&lt; ?eg
  " TODO -- fix " >" 
  %s?\([ (]\)>\s?\1\&gt; ?g
  " Hierdie kry " > engels" en " (> engels)" 
  normal ;entities

  " Change filename extension, ready to write out:
  file %:r.db | set modified

  normal gg 
  insert 
COMMENT: Database of pages for English/Afrikaans terminology lexicon.
COMMENT: Author: Jean Jordaan 990314 
COMMENT: Last Modified:
COMMENT:
COMMENT: FIELDS: ID|anchor|sortkey|english|afrikaans
COMMENT:
COMMENT: This database is automatically updated by Htmlpp.
COMMENT: If you modify it by hand, don't forget to replace any pipe and new
COMMENT: line characters in the data by ~p~ and ~nl~ respectively.
COMMENT: 
.

  endfunction
command! MassageTerms call MassageTerms()



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""                                                                   ""
""                        DON'T READ FURTHER                         ""
""                                                                   ""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" From:           	"Jean Jordaan" <rgo_anas@rgo.sun.ac.za>
" To:             	Michael Geddes <mgeddes@cybergraphic.com.au>
" Date sent:      	Mon, 15 Mar 1999 12:30:44 +200
" Subject:        	RE: Regexp question -- rerun
" 
" Thank you, Michael
" 
" .. for tying my brains in a knot. But it certainly works. Let's see: 
" 
" > g/::.*::/
" For all lines containing (a) pair(s) of ::-brackets
" 
" > exe 's/::.\{-}::/' 
" Match everything between the first :: :: pair (pattern.txt: '"\{-}" 
" is the same as "*" but uses the shortest match first algorithm.', and 
" so doesn't get confused with multiple :: :: pairs on a line.)
" 
" > .
" Replace the above match with what follows
" 
" > escape(substitute(matchstr(getline('.'),'::.\{-}::'),' ','_','g'),'/') 
" Broken down:
" 
" > getline('.') 
" Returns for example on one line
"     74_RT::bits per second::bits per second* (bps)::bits per second*
"     (bps)::bisse per sekonde (bps) 
" 
" > matchstr(74_RT...(bps),'::.\{-}::')
" Bites the first ::....:: chunk out, returns ::bits per second:: .
" 
" > substitute(::bits per second::,' ','_','g')
" Replace the spaces in that
" 
" > escape(::bits_per_second::,'/')
" Escape any forward slashes in that (for the sake of s/../../ )
" 
" QED
" 
" Cool. I guess because it traverses the file only once it's at least 
" three times quicker than my three global operations, the first of 
" which roughly doubles the number of lines?
" 
" > 	:%s?^\(.::[^:]\+::\)?\1^M
" > 	:g/^.::/s? ?_?g
" > 	:g/^.::/j
" 
" Let's see .. how about a command that acts on any specified field, 
" with the field delimited by any specified character(s)? Or is this 
" for Perl?
" 
" --jean                                       . .. ..... ///\oo/\\\
"
" =====================================================================
" CHANGELOG
"
" 990315
" ------
" * en ** weggehaal -- daardie informasie hoort by die database, nie by die
" inskrywings nie. 
