"	Stephen Riehm's braketing macros for vim
"
"	Last Change: 16.01.2000
"	(C)opyleft: Stephen Riehm 1991 - 2000
"

" njj: source ~/bracketing.base.vim
source <sfile>:h/bracketing.base.vim

" Jump point macros
" =================
"
"	set a marker (the cursor is left between the marker characters)
"	default: <M-Del>
imap <M-Del> ¡mark!<ESC>i
vmap <M-Del> ¡mark!
"	jump to next marker
"	default: <Del>
map  <Del> ¡jump!
imap <Del> ¡jump!

"	Quoting/bracketting macros
"	--------------------------
"	Note: The z cut-buffer is used to temporarily store data!
"
"	double quotes
"	default: <M-">
imap <M-"> ¡"!
vmap <M-"> ¡"!

"	single quotes
"	default: <M-'>
imap <M-'> ¡'!
vmap <M-'> ¡'!

"	stars
"	default: <M-*>
imap <M-*> ¡*!
vmap <M-*> ¡*!

"	braces
"	default: <M-(>
imap <M-(> ¡(!
vmap <M-(> ¡(!

"	braces - with padding
"	default: <M-)>
imap <M-)> ¡)!
vmap <M-)> ¡)!

"	underlines
"	default: <M-_>
imap <M-_> ¡_!
vmap <M-_> ¡_!

"	angle-brackets
"	default: <M-<>
imap <M-<> ¡<!
vmap <M-<> ¡<!

"	angle-brackets with padding
"	default: <M->>
imap <M->> ¡>!
vmap <M->> ¡>!

"	square brackets
"	default: <M-[>
imap <M-[> ¡[!
vmap <M-[> ¡[!

"	square brackets with padding
"	default: <M-]>
imap <M-]> ¡]!
vmap <M-]> ¡]!

"	back-quotes
"	default: <M-`>
imap <M-`> ¡`!
vmap <M-`> ¡`!

"	curlie brackets
"	default: <M-{>
imap <M-{> ¡{!
vmap <M-{> ¡{!

"	new block bound by curlie brackets
"	default: <M-}>
imap <M-}> ¡}!
vmap <M-}> ¡}!

"	spaces :-)
"	default: <M-Space>
"	(you may have trouble getting this to work - few systems accept it!)
imap <M-Space> ¡space!
vmap <M-Space> ¡space!

"	Nroff bold
"	default: <M-f><M-b>
imap <M-f><M-b> ¡nroffb!
vmap <M-f><M-b> ¡nroffb!

"	Nroff italic
"	default: <M-f><M-i>
imap <M-f><M-i> ¡nroffi!
vmap <M-f><M-i> ¡nroffi!

" Extended / Combined macros
" --------------------------
"	mostly of use to programmers only
"
"	typical function call
"	default: <M-:>
imap <M-:> ¡(+);!
"	default: <M-;>
imap <M-;> ¡();!

"	variables
"	default: <M-4>
imap <M-4> ¡$!
vmap <M-4> ¡$!

"	function definition
"	default: <M-\>
imap <M-\> ¡func!
vmap <M-\> ¡func!

" Special additions:
" -----------------
"	indent mail
"	default: <M-m>
vmap <M-m> ¡mail!
map  <M-m> ¡mail!
"	comment marked lines
"	default: <M-#>
imap <M-#> ¡#comment!
vmap <M-#> ¡#comment!
map  <M-#> ¡#comment!
"	default: <M-/><M-/>
imap <M-/><M-/> ¡/comment!
vmap <M-/><M-/> ¡/comment!
map  <M-/><M-/> ¡/comment!
"	default: <M-/><M-*>
imap <M-/><M-*> ¡*comment!
vmap <M-/><M-*> ¡*comment!
map  <M-/><M-*> ¡*comment!
"	uncomment marked lines (strip first few chars)
"	doesn't work for /* comments */
"	default: <M-3>
vmap <M-3> ¡stripcomment!
map  <M-3> ¡stripcomment!

"
" HTML Macros
" ===========
"
"	turn the current word into a HTML tag pair, ie b -> <b></b>
"	default: <M-h>
imap <M-h> ¡Htag!
vmap <M-h> ¡Htag!
"
"	set up a HREF
"	default: <M-r>
imap <M-r> ¡Href!
vmap <M-r> ¡Href!
"
"	set up a HREF name (tag)
"	default: <M-n>
imap <M-n> ¡Hname!
vmap <M-n> ¡Hname!
