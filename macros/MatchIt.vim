" 990112  (1999 Ene 12)   Raul Segura Acevedo

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
"
"   4) use autocommands to assign b:match_words automatically.
"      in our example for *.csc files we use:
"      aug Percent
"        au!BufNewFile,BufRead	*.csc let b:match_words='\<fix\>,\<endfix\>:\<if\>,\<else\(if\)\=\>,\<endif\>:\<!loopondimensions\>\|\<!looponselected\>,\<!endloop\>'
"      aug END
"
"   5) you are done, next time you load such a buffer the macro "%" will do the job
"
" NOTE, "let percent_search_always=1" to always search for the special word
" under or after the cursor, otherwise vim will check the text starting at the
" cursor position first, this might keep from having to type RETURN but it
" might not do what U expect

" Wrapper to feed the proper arguments to Busca() depending on rules defined on
" variable b:match_words for the word under or after the cursor
" ignore the range
function! Match_wrapper(word) range
	" create b:match_words and/or assign a default value
	if !exists("b:match_words")
		let b:match_words=''
	end
	if b:match_words==''
		norm!%
		return
	end

	" quote the special chars in 'matchpairs', replace [,:] with \| and then
	" append the builtin pairs (/*, */, #if, #ifdef, #else, #elif, #endif)
	let default=substitute(escape(&mps, '[$^.*~\\/?]'), '[,:]\+', '\\|', 'g').'\|\/\*\|\*\/\|#if\>\|#ifdef\>\|#else\>\|#elif\>\|#endif\>'
	" pat = pattern with all the user defined keywords
	let pat=substitute(b:match_words, '[,:]\+', '\\|', 'g')
	" all = pattern with all the keywords
	let all=default.'\|'.pat

	let ws=&wrapscan
	let reg=@"
	se ws
	if a:word!=''
		" word given
		if a:word!~all
			echohl Error|echo 'Missing rule for word:"'.a:word.'"'|echohl NONE
			return
		end
		let @"=a:word
	" Now the case when "word" is not given
	elseif getline(".")!~ all || matchend(getline("."), '.*\('.all.'\)') < col(".")
		" there is no special word in this line || the it is before the cursor
		echohl Error | echo "No matching rule applies here" | echohl NONE
		return
	else
		" OK, theres a special word under or after the cursor, grab it
		norm!msy$
		if &co*&ch>=strlen(all)+2 || exists("g:percent_search_always") || @"!~'^\('.all.'\)'
			exe 'norm!?./'.all.'/e/.?'.all.'y$'
		end
	end

let g:word=all
	se nows
	let errmsg=''
	" we got a special word at the beginning of @" (a user given rule overrides builtin)
	if @"=~'^\('.pat.'\)'
		let words=b:match_words
		while words!=''
			let pat=substitute(words, ':.*', '', '')

			if @"=~'^\('.substitute(pat, ',\+', '\\|', 'g').'\)'
				" found in this group
				" pick first pattern
				let ini=substitute(pat, ',.*', '', '')
				let fin=substitute(pat, '.*,', '', '')
				if @"!~'^\('.fin.'\)'
					let pat=substitute(pat, '^[^,]*,\+', '', '')
					let errmsg=Busca("/", ini, fin, substitute(pat, ',\+', '\\|', 'g'))
				else
					" search backwards
					let errmsg=Busca("?", fin, ini, ini)
				end
				break
			end
			let words=substitute(words, '[^:]*:\+', '', '')
		endwhile
	else
		norm!%
	end
	let &ws=ws
	let @"=reg
	if errmsg == -1 
		norm`s
	else
		echon ''
	end
endf

" dir: is either "/" or "?", defines the direction of the search
" ini: pattern for words that indicate the start of a group
" fin: pattern for words that indicate the end of a group
" tail: pattern for special words that are not the beginning of a nested group
"       for example: Busca('/', '\<if\>', '\<end', '\<elseif\>\|\<else\>')
" note that if U R moving backwards ini='\<end', and fin='\<if\>'
function! Busca(dir, ini, fin, tail) abort
	while 1
		" jump to next match and yank 'til the end of the line
		exe "norm!".a:dir.a:ini.'\|'.a:tail."y$"
		if @"=~'^\('.a:tail.'\)'
			" body, we are done
			break
		else
			" we found a nested group, call Busca to skip it (jump to it's a:fin)
			call Busca(a:dir, a:ini, a:fin, a:fin)
			" try again
		end
	endwhile
endf

aug Percent
	" vim 
	au!BufNewFile,BufRead	_vimrc,.vimrc,*.vim	let b:match_words='\<fun\k*,\<endf\k*:\<while\>,\<break\>,\<endw\k*:\<if\>,\<elseif\>,\<else\>,\<end\k*:\<a'.'ug\k*,\<a'.'ug\k*\s\+END\>'
	" essbase
  au!BufNewFile,BufRead	*.csc let b:match_words='\<fix\>,\<endfix\>:\<if\>,\<else\(if\)\=\>,\<endif\>:\<!loopondimensions\>\|\<!looponselected\>,\<!endloop\>'
	" pascal
  au!BufNewFile,BufRead	*.p,*.pas let b:match_words='\<begin\>,\<end\>'
  " njj: DTML
  au!BufNewFile,BufRead	*.dtml let b:match_words='\<<dtml-if\>,\<<dtml-elif\>,\<<dtml-else\>,\<<\/dtml-if\>:\<<dtml-unless\>,\<<\/dtml-unless\>:\<<dtml-in\>,\<<dtml-else\>,\<<\/dtml-in\>:\<<dtml-with\>,\<<\/dtml-with\>:\<<dtml-let\>,\<<\/dtml-let\>:\<<dtml-raise\>,\<<\/dtml-raise\>:\<<dtml-try\>,\<<dtml-except\>,<\/dtml-try\>:\<<dtml-comment\>,\<<\/dtml-comment\>:\<<dtml-tree\>,\<<\/dtml-tree\>:\<<dtml-sendmail\>,\<<\/dtml-sendmail\>'
aug END

nm% :call Match_wrapper('')<CR>
vm% <Esc>%m'gv``
" vim:ts=2:sw=2
