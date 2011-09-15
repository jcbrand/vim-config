" -*- vim -*-
" FILE: "D:\vim\matchit.vim"
" UPLOAD: URL="ftp://siteftp.netscape.net/vim/matchit.vim" USER="benjif"
" LAST MODIFICATION: "Sat, 15 Apr 2000 12:47:02 Eastern Daylight Time ()"
" (C) 2000 by Benji Fisher, <benji@member.AMS.org>
" $Id:$

" Function to do percent "%" matching of braces, brackets, and syntax
" structures.  This enhances default VIM functionality for going to matched
" pairs (see :h 'matchpairs'), to allow for syntax structures such as IF, ELSE,
" ENDIF.
"
" 990112  (1999 Ene 12)   Raul Segura Acevedo
" 24-Feb-2000 pottsdl   fixed searching mechanism to check for 'comment' syntax
"                       attribute, keeps it from finding a false match 'inside'
"                       a comment.
" March 8, 2000  Benji Fisher (BF):
"   I added comments, did a few things to simplify it (without changing
"   the function, I hope) and modified the definitions of b:match_words
"   for vim files, added a definition for LaTeX files.  Search for "BF:"
" March 10, 2000  Benji Fisher (BF):
"   I rewrote the function Busca() to make it non-recursive.  I succeeded, but
" it is still very slow.  (On a 900-line LaTeX document, it takes 2 or 3 seconds
" to go from \begin{document} to \end{document}.  This is on a 400-MHz Pentium II.)
" March 19, 2000  Benji Fisher (BF):
"   I cleaned things up:  removed raw <CR> characters, removed redundancy from
" Busca(), and so on.  I added the b:match_comment option.  This speeds it up
" for LaTeX:  on the sample file described above, it takes less than a second.
" April 6, 2000 Benji Fisher (BF):
"   Minor changes:  uncomment autocommands at end of file (some lines that had
" been commented out caused problems), added a test for b:match_words="" to the
" test for exists("b:match_words"), fixed the vim pattern for "aug...aug END".
" Then posted this as the non-beta version.

" To support a new language:
"   1) define the groups of special groups such as:
"      fix <-> endfix
"      if <-> elseif <-> else <-> endif
"      !loopondimensions <-> !endloop
"      !looponselected <-> !endloop
"   2) each groups becomes a comma separated list of patterns of the form:
"      "Initial,Extra1,...ExtraN,Final"
"        Initial: pattern for word(s) that start a nested group
"        Final:   pattern for the word(s) that end a nested group
"        ExtraI:  any pattern for other word(s)
"      groups with common words must be merged, like this:
"      \<fix\>,\<endfix\>
"      \<if\>,\<else\(if\)\=\>,\<endif\>
"      \<!loopondimensions\>\|\<!looponselected\>,\<!endloop\>'
"   3) assign the variable "b:match_words" to the colon separated groups
"      let b:match_words='\<fix\>,\<endfix\>:\<if\>,\<else\(if\)\=\>,\<endif\>:\<!loopondimensions\>\|\<!looponselected\>,\<!endloop\>'
"      (optional)  Assign the variable "b:match_comment" to a regexp matching the
"      comment pattern.  See the example for TeX files below.  This will speed things
"      up since it should be faster to match your regexp than to use the syntax-
"      highlighting mechanism.  It only works with one-line comments (like '//' for
"      C++):  it will turn off the check for multi-line comments (like '/*...*/').
"      If you want to spped things up at the risk of getting confused by comments
"      then you can :let b:match_comment = '^$' .
"
"   4) use autocommands to assign b:match_words automatically.
"      in our example for *.csc files we use:
"      aug Percent
"        au!BufNewFile,BufRead	*.csc let b:match_words='\<fix\>,\<endfix\>:\<if\>,\<else\(if\)\=\>,\<endif\>:\<!loopondimensions\>\|\<!looponselected\>,\<!endloop\>'
"      aug END
"
"   5) you are done, next time you load such a buffer the macro "%" will do the job
"
" BF:  This is now obsolete.
" NOTE, "let percent_search_always=1" to always search for the special word
" under or after the cursor, otherwise vim will check the text starting at the
" cursor position first, this might keep from having to type RETURN but it
" might not do what U expect

" Wrapper to feed the proper arguments to Busca() depending on rules defined on
" variable b:match_words for the word under or after the cursor
" ignore the range
function! Match_wrapper(word) range
  if !exists("b:match_words") || b:match_words == ""
    normal! %
    return
  end
  " BF:  added this to minimize screen jumps and avoid using a global mark
  let mark = line(".") . "normal!" . virtcol(".") . "|"
  normal! H
  let top_of_screen = line(".")
  execute mark
  let ws = &wrapscan
  " let reg = @"
"   let searchnr = histnr("/")

  " quote the special chars in 'matchpairs', replace [,:] with \| and then
  " append the builtin pairs (/*, */, #if, #ifdef, #else, #elif, #endif)
  let default = substitute(escape(&mps, '[$^.*~\\/?]'), '[,:]\+',
    \ '\\|', 'g').'\|\/\*\|\*\/\|#if\>\|#ifdef\>\|#else\>\|#elif\>\|#endif\>'
  " pat = pattern with all the user defined keywords
  let pat = substitute(b:match_words, '[,:]\+', '\\|', 'g')
  " all = pattern with all the keywords
  let all = '\(' . default . '\|' . pat . '\)'

"   set ws
  if a:word != ''
    " word given
    if a:word !~ all
      echohl Error|echo 'Missing rule for word:"'.a:word.'"'|echohl NONE
      return
    endif
    let match = a:word
  " Now the case when "word" is not given
  " elseif getline(".")!~ all || matchend(getline("."), '.*'.all) < col(".")
  " BF:  I think this should work just as well as the above line:
  elseif matchend(getline("."), '.*' . all) < col(".")
    " there is no special word in this line || it is before the cursor
    echohl Error | echo "No matching rule applies here" | echohl NONE
    return
  else	" Find the match that ends on or after the cursor and position the
	" cursor at the start of this match.
    let match = getline(".")
    let curcol = col(".") " column of the cursor in match
    let endmatch = matchend(match, all)
" let g:foo = match
    while endmatch < curcol
      let match = strpart(match, endmatch, strlen(match))
" let g:foo = g:foo . "#" . match
      let curcol = curcol - endmatch
      let endmatch = matchend(match, all)
    endwhile
    let matchcol = strlen(getline(".")) - strlen(match) + match(match, all)
    normal! 0
    if matchcol
      execute "normal!" . matchcol . "l"
    endif
    let match = matchstr(match, all)
" let g:foo = g:foo . "#" . match . "#" . matchcol . "#"
  endif

  set nows
  let errmsg = ''
  " we got a special word in match (a user given rule overrides builtin)
  if match !~ '^\(' . pat . '\)'
    norm! %
  else
    let words = b:match_words
    let pat = substitute(words, ':.*', '', '')
    while match !~ '^\(' . substitute(pat, ',\+', '\\|', 'g') . '\)'
      let words = substitute(words, '[^:]*:\+', '', '')
      let pat = substitute(words, ':.*', '', '')
    endwhile
    " found in this group
    " pick first pattern
    let ini = substitute(pat, ',.*', '', '')
    let fin = substitute(pat, '.*,', '', '')
" let &ch = &ch + 6
    if match !~ '^\(' . fin . '\)'
      let pat = substitute(pat, '^[^,]*,\+', '', '')
      let errmsg = Busca("/", ini, fin, substitute(pat, ',\+', '\\|', 'g'))
    else
      " search backwards
      let errmsg = Busca("?", fin, ini, ini)
    endif
" echon ""
" let &ch = &ch - 6
  endif
  if errmsg != -1 
    " BF:  a hack to deal with "if...end if" situations
    if getline(".")[col(".")-1] =~ '\s'
      normal! w
    endif
    " BF:  Mark the final position.
    let mark = line(".") . "normal!" . virtcol(".") . "|"
    " BF:  Return to original screen.
    execute "normal!" . top_of_screen . "Gz\<CR>"
    " BF:  Now, go to the final position.
  endif
  execute mark
  let &ws = ws
  " let @" = reg
"   while histnr("/") > searchnr
"     call histdel("/", -1)
"   endwhile
endfun

" dir: is either "/" or "?", defines the direction of the search
" ini: pattern for words that indicate the start of a group
" fin: pattern for words that indicate the end of a group
" tail: pattern for special words that are not the beginning of a nested group
"       for example: Busca('/', '\<if\>', '\<end', '\<elseif\>\|\<else\>\|\<end')
" BF:   for example: Busca('?', '\<end', '\<if\>', '\<if\>')
" BF:  I also corrected the first example.
" note that if U R moving backwards ini='\<end', and fin='\<if\>'
" BF:  I am going to try to write a version that is not recursive.
function! Busca(dir, ini, fin, tail) abort
" let g:foo=getline(".")."#".a:dir."#".a:ini."#".a:fin."#".a:tail."#"
" let g:foobar=''
  if has("syntax") && exists("g:syntax_on") &&
    \ synIDattr(synID(line("."),col("."),1),"name") =~? 'comment'
    let skip_comments = 0
  else
    let skip_comments = 1
  endif
  if a:dir == "/"
    let string = strpart(getline("."), col(".")-1, strlen(getline(".")))
    let depth = 1 " nesting depth
    while depth
" let g:foobar=g:foobar."#".depth."#".line(".")."#"
      if depth == 1
	" Search for ini or tail.
	let pattern =  '\(' . a:ini . '\|' . a:tail . '\)'
      else  " depth == 1
	" Search for ini or fin.
	let pattern =  '\(' . a:ini . '\|' . a:fin . '\)'
      endif
      let string = strpart(string, matchend(string, pattern)-1, strlen(string))
      if match(string, pattern) == -1
	execute "/" . pattern
	let string = getline(".")
      endif
      let string = strpart(string, match(string, pattern), strlen(string))
      if skip_comments
	if exists("b:match_comment")
	  let comment = matchend(getline("."), b:match_comment)
	  if comment != -1 && comment <= strlen(getline(".")) - strlen(string)
	    continue  " Comment:  no change to depth.
	  endif
	elseif has("syntax") && exists("g:syntax_on") &&
	  \ synIDattr(synID(line("."),strlen(getline("."))-strlen(string),1),"name")
	  \ =~? 'comment'
	  continue  " Comment:  no change to depth.
	endif
      endif " skip_comments
      if  match(string, '^' . a:ini) != -1  " (found ini)
	let depth = depth + 1
      else  " (found fin or depth == 1 and found tail)
	let depth = depth - 1
      endif
    endwhile
    normal! $
    let i = strlen(string) - 1
    if i
      execute "normal!" . i . "h"
    endif
" if foo | if bar | let bar = 0 | endif | else | let foo=0 | endif
  else	" a:dir == "?"
    let pattern =  '\(' . a:ini . '\|' . a:fin . '\)'
    let string = strpart(getline("."), 0, col(".")-1)
    let depth = 1 " nesting depth
" let g:bar = ""
    while depth
" let g:bar = g:bar . "#".depth."#".string
      if match(string, pattern) == -1
	execute "?" . pattern
	let string = getline(".")
      endif
      let string = strpart(string, 0, matchend(string, '.*' . pattern))
" let g:bar = g:bar . "#".depth."#".string
      if skip_comments
	if exists("b:match_comment") && match(string, b:match_comment) != -1
	  let string = strpart(string, 0, match(string, pattern.'$'))
	  continue  " Comment:  no change to depth.
	elseif has("syntax") && exists("g:syntax_on") &&
	  \ synIDattr(synID(line("."),strlen(string),1),"name") =~? 'comment'
	  let string = strpart(string, 0, match(string, pattern.'$'))
	  continue  " Comment:  no change to depth.
	endif
      endif " skip_comments
      if  match(string, a:ini . '$') != -1  " (found ini)
	let depth = depth + 1
      else  " (found fin or depth == 1 and found tail)
	let depth = depth - 1
      endif
      let string = strpart(string, 0, match(string, pattern.'$'))
    endwhile
    normal! 0
    let i = strlen(string)
    if i
      execute "normal!" . i . "l"
    endif
  endif	" a:dir == "/"
" let g:bar=getline(".")."#".a:dir."#".a:ini."#".a:fin."#".a:tail."#"
endfunction

" dir: is either "/" or "?", defines the direction of the search
" ini: pattern for words that indicate the start of a group
" fin: pattern for words that indicate the end of a group
" tail: pattern for special words that are not the beginning of a nested group
"       for example: Busca('/', '\<if\>', '\<end', '\<elseif\>\|\<else\>\|\<end')
" BF:   for example: Busca('?', '\<end', '\<if\>', '\<if\>')
" BF:  I also corrected the first example.
" note that if U R moving backwards ini='\<end', and fin='\<if\>'
" BF:  I am going to try to write a version that is not recursive.
function! Busca(dir, ini, fin, tail) abort
  let pattern =  '\(' . a:ini . '\|' . a:tail . '\)'
  if a:dir == "?"
    let prefix = '.*'
  else
    let prefix = ''
  endif
  let string = getline(".")
  let start = col(".") - 1
  let end = start + matchend(strpart(string,start,strlen(string)), pattern)
  if exists("b:match_comment")
    let iscomment = 'strpart(string, 0, end) =~ b:match_comment'
  elseif has("syntax") && exists("g:syntax_on")
    let iscomment = 'synIDattr(synID(line("."),end,1),"name") =~? "comment"'
  else
    let iscomment = "0"
  endif
  execute 'let comment =' . iscomment
  if comment
    let iscomment = "0"
  endif
  let depth = 1 " nesting depth

  while depth
    if a:dir == "/"
      let end = matchend(string, '.\{' . end . '}' . pattern)
    else
      let start = match(strpart(string, 0, end), pattern . "$") - 1
      let end = matchend(strpart(string, 0, start), '.*' . pattern)
    endif
    if end == -1
      execute a:dir . pattern
      let string = getline(".")
      let end = matchend(string, prefix . pattern)
    endif
    execute 'let comment =' . iscomment
    if comment
	continue  " Comment:  no change to depth.
    endif
    if  strpart(string, 0, end) =~ a:ini . "$"  " (found ini)
      let depth = depth + 1
      if depth == 2
	let pattern =  '\(' . a:ini . '\|' . a:fin . '\)'
      endif
    else  " (found fin or depth == 1 and found tail)
      let depth = depth - 1
      if depth == 1
	let pattern =  '\(' . a:ini . '\|' . a:tail . '\)'
      endif
    endif
  endwhile

  normal! 0
  let start = match(strpart(string, 0, end), pattern . "$")
  if start
    execute "normal!" . start . "l"
  endif
endfunction

" ****************************************************************************** 
"  Original post used the below autocmd group, I have different
"  ones that take care of this so I don't need them, but YOU might. ;)
"  BF:  I modified and un-commented the vim section.
" ****************************************************************************** 

aug Percent
  " vim 
  " BF:  These could use some refinement.  I'll try to fix if/else/endif for vim.
  " I'll also streamline the pattern for a vimrc and allow vimrc and g-variants.
  au!BufNewFile,BufRead	[_.]\=g\=vimrc,*.vim  let b:match_words=
  \ '\<fun\k*,\<retu\(rn\=\)\=,\<endf\k*:' .
  \ '\<while\>,\<break\>,\<con\k*\>,\<endw\k*:' .
  \ '\<if\>,\<el\(s\=\|sei\=\|seif\)\>,\<en\(d\=\|dif\=\)\>:' .
  \ '\<aug\k*\s\+\([^E]\|E[^N]\|EN[^D]\),\<aug\k*\s\+END\>'
  " essbase
  au!BufNewFile,BufRead *.csc let b:match_words=
  \ '\<fix\>,\<endfix\>:' .
  \ '\<if\>,\<else\(if\)\=\>,\<endif\>:' .
  \ '\<!loopondimensions\>\|\<!looponselected\>,\<!endloop\>'
  " LaTeX
  au! BufNewFile,BufRead *.tex,*.sty,*.dtx,*.ltx let b:match_words =
    \ '\\begin{\a*},\\end{\a*}' | let b:match_comment = '\(^\|[^\\]\)\(\\\\\)*%'
  " pascal
  au!BufNewFile,BufRead *.p,*.pas let b:match_words='\<begin\>,\<end\>'
  " HTML
  au! FileType html let b:match_words =
    \ '<abbr[^>]*>,<\/abbr>:'.
    \ '<acronym[^>]*>,<\/acronym>:'.
    \ '<address[^>]*>,<\/address>:'.
    \ '<applet[^>]*>,<\/applet>:'.
    \ '<area[^>]*>,<\/area>:'.
    \ '<a[^>]*>,<\/a>:'.
    \ '<base[^>]*>,<\/base>:'.
    \ '<basefont[^>]*>,<\/basefont>:'.
    \ '<bdo[^>]*>,<\/bdo>:'.
    \ '<big[^>]*>,<\/big>:'.
    \ '<blockquote[^>]*>,<\/blockquote>:'.
    \ '<body[^>]*>,<\/body>:'.
    \ '<br[^>]*>,<\/br>:'.
    \ '<button[^>]*>,<\/button>:'.
    \ '<b[^>]*>,<\/b>:'.
    \ '<caption[^>]*>,<\/caption>:'.
    \ '<center[^>]*>,<\/center>:'.
    \ '<cite[^>]*>,<\/cite>:'.
    \ '<code[^>]*>,<\/code>:'.
    \ '<colgroup[^>]*>,<\/colgroup>:'.
    \ '<col[^>]*>,<\/col>:'.
    \ '<dd[^>]*>,<\/dd>:'.
    \ '<del[^>]*>,<\/del>:'.
    \ '<dfn[^>]*>,<\/dfn>:'.
    \ '<dir[^>]*>,<\/dir>:'.
    \ '<div[^>]*>,<\/div>:'.
    \ '<dl[^>]*>,<\/dl>:'.
    \ '<dt[^>]*>,<\/dt>:'.
    \ '<em[^>]*>,<\/em>:'.
    \ '<fieldset[^>]*>,<\/fieldset>:'.
    \ '<font[^>]*>,<\/font>:'.
    \ '<form[^>]*>,<\/form>:'.
    \ '<frameset[^>]*>,<\/frameset>:'.
    \ '<frame[^>]*>,<\/frame>:'.
    \ '<h1[^>]*>,<\/h1>:'.
    \ '<h2[^>]*>,<\/h2>:'.
    \ '<h3[^>]*>,<\/h3>:'.
    \ '<h4[^>]*>,<\/h4>:'.
    \ '<h5[^>]*>,<\/h5>:'.
    \ '<h6[^>]*>,<\/h6>:'.
    \ '<head[^>]*>,<\/head>:'.
    \ '<hr[^>]*>,<\/hr>:'.
    \ '<html[^>]*>,<\/html>:'.
    \ '<iframe[^>]*>,<\/iframe>:'.
    \ '<img[^>]*>,<\/img>:'.
    \ '<input[^>]*>,<\/input>:'.
    \ '<ins[^>]*>,<\/ins>:'.
    \ '<isindex[^>]*>,<\/isindex>:'.
    \ '<i[^>]*>,<\/i>:'.
    \ '<kbd[^>]*>,<\/kbd>:'.
    \ '<label[^>]*>,<\/label>:'.
    \ '<legend[^>]*>,<\/legend>:'.
    \ '<link[^>]*>,<\/link>:'.
    \ '<li[^>]*>,<\/li>:'.
    \ '<map[^>]*>,<\/map>:'.
    \ '<menu[^>]*>,<\/menu>:'.
    \ '<meta[^>]*>,<\/meta>:'.
    \ '<noframes[^>]*>,<\/noframes>:'.
    \ '<noscript[^>]*>,<\/noscript>:'.
    \ '<object[^>]*>,<\/object>:'.
    \ '<ol[^>]*>,<\/ol>:'.
    \ '<optgroup[^>]*>,<\/optgroup>:'.
    \ '<option[^>]*>,<\/option>:'.
    \ '<param[^>]*>,<\/param>:'.
    \ '<pre[^>]*>,<\/pre>:'.
    \ '<p[^>]*>,<\/p>:'.
    \ '<q[^>]*>,<\/q>:'.
    \ '<samp[^>]*>,<\/samp>:'.
    \ '<script[^>]*>,<\/script>:'.
    \ '<select[^>]*>,<\/select>:'.
    \ '<small[^>]*>,<\/small>:'.
    \ '<span[^>]*>,<\/span>:'.
    \ '<strike[^>]*>,<\/strike>:'.
    \ '<strong[^>]*>,<\/strong>:'.
    \ '<style[^>]*>,<\/style>:'.
    \ '<sub[^>]*>,<\/sub>:'.
    \ '<sup[^>]*>,<\/sup>:'.
    \ '<s[^>]*>,<\/s>:'.
    \ '<table[^>]*>,<\/table>:'.
    \ '<tbody[^>]*>,<\/tbody>:'.
    \ '<td[^>]*>,<\/td>:'.
    \ '<textarea[^>]*>,<\/textarea>:'.
    \ '<tfoot[^>]*>,<\/tfoot>:'.
    \ '<thead[^>]*>,<\/thead>:'.
    \ '<th[^>]*>,<\/th>:'.
    \ '<title[^>]*>,<\/title>:'.
    \ '<tr[^>]*>,<\/tr>:'.
    \ '<tt[^>]*>,<\/tt>:'.
    \ '<ul[^>]*>,<\/ul>:'.
    \ '<u[^>]*>,<\/u>:'.
    \ '<var[^>]*>,<\/var>'
  au! FileType dtml let b:match_words =
    \ '<dtml-if[^>]*>,<dtml-elif[^>]*>,<dtml-else[^>]*>,<\/dtml-if[^>]*>:'.
    \ '<dtml-unless[^>]*>,<\/dtml-unless[^>]*>:'.
    \ '<dtml-in[^>]*>,<dtml-else[^>]*>,<\/dtml-in[^>]*>:'.
    \ '<dtml-with[^>]*>,<\/dtml-with[^>]*>:'.
    \ '<dtml-let[^>]*>,<\/dtml-let[^>]*>:'.
    \ '<dtml-raise[^>]*>,<\/dtml-raise[^>]*>:'.
    \ '<dtml-try[^>]*>,<dtml-except[^>]*>,<\/dtml-try[^>]*>:'.
    \ '<dtml-comment[^>]*>,<\/dtml-comment[^>]*>:'.
    \ '<dtml-tree[^>]*>,<\/dtml-tree[^>]*>:'.
    \ '<dtml-sendmail[^>]*>,<\/dtml-sendmail[^>]*>'
  au! FileType fortran let b:match_words =
    \ '\<do\>,\<continue\>:'.
    \ '\<if.*then\>,\<else\s*\(if.*then\)\=\>,\<endif\>'
  au! FileType sh,config let b:match_words =
      \ '^\s*\<if\>\|;\s*\<if\>,^\s*\<elif\>\|;\s*\<elif\>,^\s*\<else\>\|;\s*\<else\>,^\s*\<fi\>\|;\s*\<fi\>:'.
      \ '^\s*\<for\>\|;\s*\<for\>\|^\s*\<while\>\|;\s*\<while\>,^\s*\<done\>\|;\s*\<done\>:'.
      \ '^\s*\<case\>\|;\s*\<case\>,^\s*\<esac\>\|;\s*\<esac\>'
aug END

nmap% :call Match_wrapper('')<CR>
vmap% <Esc>%m'gv``
" vim:sts=2:sw=2
