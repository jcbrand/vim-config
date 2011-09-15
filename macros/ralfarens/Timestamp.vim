" File: Timestamp.vim
"
" Purpose: insert timestamp into files
"
" Author: Ralf Arens <ralf.arens@gmx.de>
" Last Modified: 2000-03-10 13:49:06 CET


" timestamps
" ¯¯¯¯¯¯¯¯¯¯
fun! Timestamp()
	mark z
	exe ':%s/\(.*Last Modified: \)\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2} \u\{3}\(.*\)$/\1'.strftime("%Y-%m-%d %T %Z").'\2/e'
	'z
endfun

" vim:set noet:tw=8:sw=8
