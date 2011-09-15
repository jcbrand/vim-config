" Terminologielys syntax file
" Language:	None
" Maintainer:	Jean Jordaan <rgo_anas@rgo.sun.ac.za>
" Last change:	990209 01:21:04

" Remove any old syntax stuff hanging around.
syn clear

syn case match

syn keyword termeSymbol     n.     ww.     b.nw.   s.nw.    transparent contained

syn match termeTerm 	    "^.[^:*<|]\+"
syn match termeIsWoord	    "<.\+>"                         contains=termeSymbol
syn match termeIsHTML	    "<[^>]\+>"
syn match termeRedaksioneel +{\{1}[^}]\+}\{1}+
syn match termeVerwysing	+{\{2}[^}]\+}\{2}+
syn match termeNuut         "\*{1,2}"
syn match termeDbField		"|"
syn match termeTak          "\|"

hi link termeTerm	        String
hi link termeIsWoord	    Type
hi link termeIsHTML         String
hi link termeVerwysing      PreProc
hi link termeRedaksioneel	Comment
hi link termeNuut           Special
hi link termeDbField        Todo
hi link termeTak            Delimiter

let b:current_syntax = "Termelys"

syn case ignore

" vim: ts=4
