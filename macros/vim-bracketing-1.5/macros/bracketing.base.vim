"	Stephen Riehm's braketing macros for vim
"
"	Last Change: 16.01.2000
"	(C)opyleft: Stephen Riehm 1991 - 2000
"
version 5.5

"	you MAY want to change some settings, or the characters used for the
"	jump marks - if so, make your changes here

" Settings
" ========
"njj: I'm turning off the indenting settings.
"
"	These settings are required for the macros to work.
"	Essentially all you need is to tell vim not to be vi compatible,
"	and to do some kind of groovy autoindenting.
"
"	indent to previous line's indentation automatically
"njj set autoindent
"
"	turn on automatic code indenting
"	(you may want to turn this off if you don't normally edit code)
"njj set cindent
"
"	reformat when the following special keys have been typed
"njj set cinkeys=0{,0},!^F,o,O
"	how to format C code
"		> normal indent (1 shiftwidth)
"		e indent for braces starting at the end of a line
"		n indent after a keyword when NOT in braces (don't do
"		    this, it's non-standard)
"		f indent of the first opening brace (braces that are
"		    not in other braces)
"		{ indent of opening brace for braces in other braces
"		} indent of closing brace (relative to matching open brace)
"		^ indent inside braces (relative to current indent)
"		: indent of case labels relative to the switch statement
"		= indent after a case label
"		p indent of K&R style paramter declarations
"		t indent for a function's type declaration
"		+ indentation of a continuation line
"		c indentation of a comment line
"		( indentation when in an unclosed () block
"		) how far to look for an unclosed bracket (5 lines)
"		* how far to look for an unclosed comment (15 lines)
"
" This is the style I use at work - change it if you want another style
"njj set cinoptions=>s,e0,n0,}0,^0,:s,=s,ps,ts,(2s,)5,*15,+s,f0,{0
"
" The following style indents curlies with the indented code, ie:
" if( blah )
"    {
"    blah;
"    }
" set cinoptions=>s,e0,n0,}0,^0,:s,=s,ps,ts,(2s,)5,*15,+s,fs,{s
"
" since the indenting is handle by the macros, you
" don't need vim to do anything special.
" trust me :-)
"njj set cinwords=
"
"	status line is exactly that, one line.
"njj set comments=sr:/*,mb:*,el:*/,://,n:#
"
"	tell vim not to do screwy things when searching
"	(This is the default value, without c)
"njj set cpoptions=BeFs

" Jump point macros
" =================
"
"	set a marker (the cursor is left between the marker characters)
"	This is the place to change the jump marks if you want to
imap ¡mark! <C-V>«<C-V>»
vmap ¡mark! "zc<C-V>«<C-R>z<C-V>»<ESC>
"	jump to next marker
map ¡jump! /«.\{-}»/<C-M>a:"<ESC>h"myt»h@m<C-M>cf»
imap ¡jump! <ESC>¡jump!

"
" ========== You should not need to change anything below this line ==========
"

"
"	Quoting/bracketting macros
"	Note: The z cut-buffer is used to temporarily store data!
"
"	double quotes
imap ¡"! <C-V>"<C-V>"¡mark!<ESC>F"i
vmap ¡"! "zc"<C-R>z"<ESC>
"	single quotes
imap ¡'! <C-V>'<C-V>'¡mark!<ESC>F'i
vmap ¡'! "zc'<C-R>z'<ESC>
"	stars
imap ¡*! <C-V>*<C-V>*¡mark!<ESC>F*i
vmap ¡*! "zc*<C-R>z*<ESC>
"	braces
imap ¡(! <C-V>(<C-V>)¡mark!<ESC>F)i
vmap ¡(! "zc(<C-R>z)<ESC>
"	braces - with padding
imap ¡)! <C-V>(  <C-V>)¡mark!<ESC>F i
vmap ¡)! "zc( <C-R>z )<ESC>
"	underlines
imap ¡_! <C-V>_<C-V>_¡mark!<ESC>F_i
vmap ¡_! "zc_<C-R>z_<ESC>
"	angle-brackets
imap ¡<! <C-V><<C-V>>¡mark!<ESC>F>i
vmap ¡<! "zc<<C-R>z><ESC>
"	angle-brackets with padding
imap ¡>! <C-V><  <C-V>>¡mark!<ESC>F i
vmap ¡>! "zc< <C-R>z ><ESC>
"	square brackets
imap ¡[! <C-V>[<C-V>]¡mark!<ESC>F]i
vmap ¡[! "zc[<C-R>z]<ESC>
"	square brackets with padding
imap ¡]! <C-V>[  <C-V>]¡mark!<ESC>F i
vmap ¡]! "zc[ <C-R>z ]<ESC>
"	back-quotes
imap ¡`! <C-V>`<C-V>`¡mark!<ESC>F`i
vmap ¡`! "zc`<C-R>z`<ESC>
"	curlie brackets
imap ¡{! <C-V>{<C-V>}¡mark!<ESC>F}i
vmap ¡{! "zc{<C-R>z}<ESC>
"	new block bound by curlie brackets
imap ¡}! <ESC>o{<C-M>¡mark!<ESC>o}¡mark!<ESC>^%¡jump!
vmap ¡}! >'<O{<ESC>'>o}<ESC>^
"	spaces :-)
imap ¡space! .  ¡mark!<ESC>F.xa
vmap ¡space! "zc <C-R>z <ESC>
"	Nroff bold
imap ¡nroffb! \fB\fP¡mark!<ESC>F\i
vmap ¡nroffb! "zc\fB<C-R>z\fP<ESC>
"	Nroff italic
imap ¡nroffi! \fI\fP¡mark!<ESC>F\i
vmap ¡nroffi! "zc\fI<C-R>z\fP<ESC>

"
" Extended / Combined macros
"	mostly of use to programmers only
"
"	typical function call
imap ¡();!  <C-V>(<C-V>);¡mark!<ESC>F)i
imap ¡(+);! <C-V>(  <C-V>);¡mark!<ESC>F i
"	variables
imap ¡$! $¡{!
vmap ¡$! "zc${<C-R>z}<ESC>
"	function definition
imap ¡func! ¡)!¡mark!¡jump!¡}!¡mark!<ESC>kk0¡jump!
vmap ¡func! ¡}!'<kO¡)!¡mark!¡jump!<ESC>I

"
" Special additions:
"
"	indent mail
vmap ¡mail! :s/^[^ <TAB>]*$/> &/<C-M>
map  ¡mail! :%s/^[^ <TAB>]*$/> &/<C-M>
"	comment marked lines
imap ¡#comment! <ESC>0i# <ESC>A
vmap ¡#comment! :s/^/# /<C-M>
map  ¡#comment! :s/^/# /<C-M>j
imap ¡/comment! <ESC>0i// <ESC>A
vmap ¡/comment! :s,^,// ,<C-M>
map  ¡/comment! :s,^,// ,<C-M>j
imap ¡*comment! <ESC>0i/* <ESC>A<TAB>*/<ESC>F<TAB>i
vmap ¡*comment! :s,.*,/* &	*/,<C-M>
map  ¡*comment! :s,.*,/* &	*/,<C-M>j
"	uncomment marked lines (strip first few chars)
"	doesn't work for /* comments */
vmap ¡stripcomment! :s,^[ <TAB>]*[#>/]\+[ <TAB>]\=,,<C-M>
map  ¡stripcomment! :s,^[ <TAB>]*[#>/]\+[ <TAB>]\=,,<C-M>j

"
" HTML Macros
" ===========
"
"	turn the current word into a HTML tag pair, ie b -> <b></b>
imap ¡Htag! <ESC>"zyiwciw<<C-R>z></<C-R>z>¡mark!<ESC>F<i
vmap ¡Htag! "zc<¡mark!><C-R>z</¡mark!><ESC>`<¡jump!
"
"	set up a HREF
imap ¡Href! <a href="¡mark!">¡mark!</a>¡mark!<ESC>`[¡jump!
vmap ¡Href! "zc<a href="¡mark!"><C-R>z</a>¡mark!<ESC>`<¡jump!
"
"	set up a HREF name (tag)
imap ¡Hname! <a name="¡mark!">¡mark!</a>¡mark!<ESC>`[¡jump!
vmap ¡Hname! "zc<a name="¡mark!"><C-R>z</a>¡mark!<ESC>`<¡jump!
