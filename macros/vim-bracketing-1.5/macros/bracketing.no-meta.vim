"	Stephen Riehm's braketing macros for vim
"
"	Last Change: 16.01.2000
"	(C)opyleft: Stephen Riehm 1991 - 2000
"

source ~/bracketing.base.vim

" Jump point macros
" =================
"
"	set a marker (the cursor is left between the marker characters)
"	default: <M-Del>
" imap XXX ¡mark!<ESC>i
" vmap XXX ¡mark!
"	jump to next marker
"	default: <Del>
map  <Del> ¡jump!
imap <Del> ¡jump!

"
"	Quoting/bracketting macros
"	Note: The z cut-buffer is used to temporarily store data!
"
"	double quotes
"	default: <M-">
imap "" ¡"!
vmap "" ¡"!
"	single quotes
"	default: <M-'>
imap '' ¡'!
vmap '' ¡'!
"	stars
"	default: <M-*>
" imap XXX ¡*!
" vmap XXX ¡*!
"	braces
"	default: <M-(>
imap (( ¡(!
vmap (( ¡(!
"	braces - with padding
"	default: <M-)>
imap )) ¡)!
vmap )) ¡)!
"	underlines
"	default: <M-_>
imap __ ¡_!
vmap __ ¡_!
"	angle-brackets
"	default: <M-<>
imap << ¡<!
vmap << ¡<!
"	angle-brackets with padding
"	default: <M->>
imap >> ¡>!
vmap >> ¡>!
"	square brackets
"	default: <M-[>
imap [[ ¡[!
vmap [[ ¡[!
"	square brackets with padding
"	default: <M-]>
imap ]] ¡]!
vmap ]] ¡]!
"	back-quotes
"	default: <M-`>
imap `` ¡`!
vmap `` ¡`!
"	curlie brackets
"	default: <M-{>
imap {{ ¡{!
vmap {{ ¡{!
"	new block bound by curlie brackets
"	default: <M-}>
imap }} ¡}!
vmap }} ¡}!
"	spaces :-)
"	default: <M-Space>
"	(you may have trouble getting this to work - few systems accept it!)
" imap XXX ¡space!
" vmap XXX ¡space!
"	Nroff bold
"	default: <M-f><M-b>
" imap XXX ¡nroffb!
" vmap XXX ¡nroffb!
"	Nroff italic
"	default: <M-f><M-i>
" imap XXX ¡nroffi!
" vmap XXX ¡nroffi!

"
" Extended / Combined macros
"	mostly of use to programmers only
"
"	typical function call
"	default: <M-:>
" imap XXX ¡();!
"	default: <M-;>
imap (; ¡(+);!
"	variables
"	default: <M-4>
imap ${ ¡$!
vmap ${ ¡$!
"	function definition
"	default: <M-\>
imap )( ¡func!
vmap )( ¡func!

"
" Special additions:
"
"	indent mail
"	default: <M-m>
" vmap XXX ¡mail!
" map  XXX ¡mail!
"	comment marked lines
"	default: <M-#>
" imap XXX ¡#comment!
" vmap XXX ¡#comment!
" map  XXX ¡#comment!
"	default: <M-/><M-/>
" imap XXX ¡/comment!
" vmap XXX ¡/comment!
" map  XXX ¡/comment!
"	default: <M-/><M-*>
" imap XXX ¡*comment!
" vmap XXX ¡*comment!
" map  XXX ¡*comment!
"	uncomment marked lines (strip first few chars)
"	doesn't work for /* comments */
"	default: <M-3>
" vmap XXX ¡stripcomment!
" map  XXX ¡stripcomment!

"
" HTML Macros
" ===========
"
"	turn the current word into a HTML tag pair, ie b -> <b></b>
"	default: <M-h>
" imap XXX ¡Htag!
" vmap XXX ¡Htag!
"
"	set up a HREF
"	default: <M-r>
" imap XXX ¡Href!
" vmap XXX ¡Href!
"
"	set up a HREF name (tag)
"	default: <M-n>
" imap XXX ¡Hname!
" vmap XXX ¡Hname!
