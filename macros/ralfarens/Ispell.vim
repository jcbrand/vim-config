" File: Ispell.vim
"
" Purpose: mappings and functions for using ispell
"
" Author: Ralf Arens <ralf.arens@gmx.net>
" Last Modified: 2000-03-12 05:35:48 CET
" + the main functions take now language as argument
" + deleted now superfluous functions
" + improved IspellWordAndChoose(...)
" + added American and British


" Usage:
"
" There are four functions:
" IspellBuffer(language)	check the whole buffer
" IspellWord(language)		check a single word
" IspellWordAndChoose(language)	check a single word and open a menu to choose
"				from
" IspellHiErrors(language)	highlight the errors, filetype mail is handled
"				specially (don't spell quoted text)
"
" The parameter "language" is optional. If it is not given, defaults or last
" employed will used. At the moment "American", "British", "English" and
" "German" are available.
"
" Adding a new language is quite simple, let my examples guide you.


" Ispell
" ØØØØØØ
" options for ispell
"	-S: sort result by probability
"	-t: TeX/LaTeX
"	-n: nroff/troff
"	-d deutsch: use german dictionary
"		$DICTIONARY is the according env-variable in ispell
"	-T latin1: use charset Latin1 (Westeurope)
"		$CHARSET is the according env-variable in ispell


" Default Options
" ØØØØØØØØØØØØØØØ
" set defaults, they'll be overwritten by calling
highlight Debug term=reverse ctermfg=Green ctermbg=Red
let g:IspellOps = "-S"
if (exists("$DICTIONARY"))
	let g:IspellDic = $DICTIONARY
else
	let g:IspellDic = "english"
endif
if (exists("$CHARSET"))
	let g:IspellChar = $CHARSET
else
	let g:IspellChar = "latin1"
endif


" Functions
" ØØØØØØØØØ

" set general ispell options
fun! IspellOps()
	if (&ft == "tex")
		let g:IspellOps = "-t -S"
	elseif (&ft == "nroff")
		let g:IspellOps = "-n -S"
	else
		let g:IspellOps = "-S"
	endif
endfun


"check word
fun! IspellWord(...)
	if (a:0 > 0)
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	let com = "!echo <cword> \| ispell -a -d ".g:IspellDic." -T ".g:IspellChar
	exe com
endfun


" check whole file
"	writes file, checks it, reads it, no undo possible
"	does it work in GUI Version?
fun! IspellBuffer(...)
	if (a:0 > 0)
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	write
	let com = "!ispell ".g:IspellOps." -d ".g:IspellDic." -T ".g:IspellChar." %"
	exe com
	edit %
endfun


" highlight spelling errors
"	by (Smylers) smylers@scs.leeds.ac.uk Fri Sep  3 05:11:59 1999
"	edited by Ralf Arens
fun! IspellHiErrors(...)
	if (a:0 > 0)
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	let ErrorsFile = tempname()
	let co = 'write ! '
	if (&ft == "mail")
		let co = co.'grep -v "^> " | egrep -v "^[[:alpha:]]-]+: " | '
	endif
	let co = co."ispell -l ".g:IspellOps." -d ".g:IspellDic." -T ".g:IspellChar
	let co = co.' | sort | uniq > '.ErrorsFile
	exe co
	exe 'split ' . ErrorsFile
	% substitute /^/syntax match SpellError #\\</
	% substitute /$/\\>#/
	exit
	syntax case match
	exe 'source ' . ErrorsFile
	hi link SpellError Debug
	call delete(ErrorsFile)
endfun


" check word under curosor
"	for testing purposes, "ispell -a gon" has 23 corrections
fun! IspellWordAndChoose(...)
	if (a:0 > 0)
		exe "call Ispell".a:1."Ops()"
	endif
	call IspellOps()
	let tmpfile = tempname()
	let word = expand("<cword>")
	exe "!echo <cword> | ispell ".g:IspellOps." -d ".g:IspellDic." -T ".g:IspellChar" -a >".tmpfile
	exe "split ".tmpfile
	let spell = getline(2)
	bdelete
	call delete(tmpfile)
	if (spell =~ "^*")
		echo "\n".word." is correct."
	elseif (spell =~ "^+")
		let spell = substitute(spell, "^+ ", "", "")
		echo "\n".word." is correct because of root ".spell
	elseif (spell =~ "^#")
		echo "\nNo guess for ".word
	elseif (spell =~ "^&")
		" how many possibilities
		let amount = substitute(spell, "^& [0-9A-Za-z]* ", "", "")
		let amount = substitute(amount, " .*$", "", "")
		" construct string for asking
		"		remove everything but possible answers
		let spell = substitute(spell, "^&.*: ", "", "")
		"		apend ", foo"
		let spell = spell.", foo"
		"	OK, now have something like
		"		eg: "con, don, gin, foo"
		"	construct string "ask" for confirm()
		let loop = 1
		let ask = ""
		while (loop <= amount)
			if (loop <= 9)
				" insert identifier
				let ask = ask."\n&".loop." "
			else
				let ask = ask."\n&".nr2char(loop+87)." "
			endif
			" append possibility to ask
			let ask = ask.substitute(spell, ",.*$", "", "")
			" delete possibility from spell
			let spell = substitute(spell, "^\[0-9A-Za-z]*, ", "", "")
			let loop = loop+1
		endwhile
		let ask = "&0 Leave unchanged".ask
		" get choice
		let choice = confirm(word, ask, 1, "Q") - 1
		if (choice > 0)
			if (choice <= 9)
				let ask = substitute(ask, "^.*\n&".choice." ", "", "")
				let ask = substitute(ask, "\n&.*$", "", "")
			else
				let ask = substitute(ask, "^.*\n&".nr2char(choice+87)." ", "", "")
				let ask = substitute(ask, "\n&.*$", "", "")
			endif
			let ask = ask.""
			exe "normal ciw".ask
		endif
	endif
endfun


"	Language Options
"	Ø Ø Ø Ø Ø Ø Ø Ø
" german
fun! IspellGermanOps()
	let g:IspellDic = "german"
	let g:IspellChar = "latin1 -w '‰ˆ¸ﬂƒ÷‹'"
endfun

" english
fun! IspellEnglishOps()
	let g:IspellDic = "english"
	let g:IspellChar = "latin1"
endfun

" british
fun! IspellBritishOps()
	let g:IspellDic = "british"
	let g:IspellChar = "latin1"
endfun

" american
fun! IspellAmericanOps()
	let g:IspellDic = "american"
	let g:IspellChar = "latin1"
endfun



" mappings
" ØØØØØØØØ
" conventions:
"	all mappings for ispell start with `‰'
map ‰wa :call IspellWordAndChoose("American")<CR><CR>
map ‰wb :call IspellWordAndChoose("British")<CR><CR>
map ‰we :call IspellWordAndChoose("English")<CR><CR>
map ‰wg :call IspellWordAndChoose("German")<CR><CR>

map ‰ta :call IspellBuffer("American")<CR>
map ‰tb :call IspellBuffer("British")<CR>
map ‰te :call IspellBuffer("English")<CR>
map ‰tg :call IspellBuffer("German")<CR>

map ‰a :call IspellHiErrors("American")<CR><CR>
map ‰b :call IspellHiErrors("British")<CR><CR>
map ‰e :call IspellHiErrors("English")<CR><CR>
map ‰g :call IspellHiErrors("German")<CR><CR>

map ‰‰ :syntax clear SpellError<CR>


" vim:noet:ts=8:sw=8:sts=8
