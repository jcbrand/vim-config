" Vim script file
" Language:	XML
" Maintainer:	Devin Weaver <ktohg@tritarget.com>
" Last Change:	2000 May 31
" Location:	http://tritarget.com/vim/xmledit.vim

" This script provides some convenience when editing XML (and some SGML)
" formated documents.  <M-5> will jupt to the beginning or end of the tag block
" your cursor is in.  % will jump between '<' and '>' within the tag your
" cursor is in.  when in insert mode and you finish a tag (pressing '>') the
" tag will be completed.  if you want to enter a literal '>' without parsing
" use <M-.>

" Options:
" xml_use_autocmds - turn on a few XML autocommands that turn on and off the
"     XML mappings depending on the current buffer. Enter the following in your
"     vimrc before source this file to turn this option on:
"     let xml_use_autocmds = 1
" xml_use_html - Allows HTML tag parsing. It functions the same but won't
"     complete typical short tags like <hr> and <br>. Enter the following in your
"     vimrc before source this file to turn this option on:
"     let xml_use_html = 1
" xml_use_xhtml - Allows HTML tag parsing. This functions the same as if you
"     had xml_use_html except it wil auto close the short tags to make valid XML
"     like <hr /> and <br />. Enter the following in your vimrc before source
"     this file to turn this option on:
"     let xml_use_xhtml = 1
" xml_no_sgml - prevents tag completion and block jumping in sgml documents. By
"     default SGML is parsed but in some cases auto completion can hinder some
"     SGML simplification rules. This will disable SGML parsing. Enter the
"     following in your vimrc before source this file to turn this option on:
"     let xml_no_sqml = 1


if !exists ("did_xmledit_init")
let did_xmledit_init = 1
let is_in_xml_buffer = 0


function NewFileXML( )
	if &filetype == 'xml' || (exists ("g:xml_use_xhtml") && &filetype == 'html')
		if append (0, '<?xml version="1.0"?>')
			normal! G
		endif
	endif
endfunction


function TurnOnXML( )
	if ! g:is_in_xml_buffer
		let g:is_in_xml_buffer = 1
		if &filetype != 'xml'
			if &filetype == 'html' && ! exists ("g:xml_use_html") && ! exists ("g:xml_use_xhtml")
				return ""
			elseif &filetype == 'sgml' && exists ("g:xml_no_sgml")
				return ""
			endif
		endif
		" Have this as an escape incase you want a literal '>' not to run the
		" ParseTag function.
		inoremap <M-.> >

		" parse the tag after pressing the close '>'
		inoremap > ><Esc>:call ParseTag()<Cr>

		" Jump between the beggining and end tags.
		nnoremap <M-5> h/><Cr>y%:call TagMatch(@")<Cr>
		"echo "XML Mappings turned on"
	endif
endfunction


function TurnOffXML( )
	if g:is_in_xml_buffer
		let g:is_in_xml_buffer = 0
		iunmap >
		iunmap <M-.>
		nunmap <M-5>
		"echo "XML Mappings turned off"
	endif
endfunction

function IsParsableTag( tag )
	" the "Should I parse?" flag.
	let parse = 1

	" make sure a:tag has a proper tag in it and is not a instruction or something.
	if a:tag !~ '^</\=\w.*>$'
		let parse = 0
	endif

	" make sure this tag isn't already closed.
	if strpart (a:tag, strlen (a:tag) - 2, 1) == '/'
		let parse = 0
	endif
	
	return parse
endfunction


function ParseTag( )
	let @" = ""
	execute "normal! y%%"
	let ltag = @"
	if exists ("g:xml_use_html") || exists ("g:xml_use_xhtml")
		let html_mode = 1
		"echo "(0:(" . ltag . "))"
		let ltag = substitute (ltag, '[^[:graph:]]\+', ' ', 'g')
		"echo "(1:(" . ltag . "))"
		let ltag = substitute (ltag, '<\s*\([^[:alnum:]_:[:blank:]]\=\)\s*\([[:alnum:]_:]\+\)\>', '<\1\2', '')
		"echo "(2:(" . ltag . "))"
	else
		let html_mode = 0
	endif
	"echo "(html_mode:(" . html_mode . "))"

	if IsParsableTag (ltag)
		" make sure we don't have a closing tag
		if strpart (ltag, 1, 1) == '/'
			return ""
		endif

		" find the break between tag name and atributes (or closing of tag)
		" Too bad I can't just grab the position index of a pattern in a string.
		let index = 1
		while index < strlen (ltag) && strpart (ltag, index, 1) =~ '[[:alnum:]_:]'
			let index = index + 1
		endwhile

		let tag_name = strpart (ltag, 1, index - 1)

		" That (index - 1) + 2    2 for the '</' and 1 for the extra character the
		" while includes (the '>' is ignored because <Esc> puts the curser on top
		" of the '>'
		let index = index + 2

		" print out the end tag and place the cursor back were it left off
		if html_mode && tag_name =~? '^\(img\|input\|param\|frame\|br\|hr\|meta\|link\|base\|area\)$'
			if exists ("g:xml_use_xhtml")
				execute "normal! i /\<Esc>l"
			endif
		else
			execute "normal! a</" . tag_name . ">\<Esc>" . index . "h"
		endif
	endif

	if col (".") < strlen (getline ("."))
		execute "normal! l"
		startinsert
	else
		startinsert!
	endif
endfunction


function TagMatch( tag )
	if IsParsableTag (a:tag)
		let close_tag = 0
		if strpart (a:tag, 1, 1) == '/'
			let close_tag = 1
		endif

		" sneaky trick since booleans are ints. (0 false, >0 true)
		let index = close_tag + 1
		while index < strlen (a:tag) && strpart (a:tag, index, 1) =~ '[:0-9A-Za-z_]'
			let index = index + 1
		endwhile

		" do the search
		if close_tag
			let tag_name = strpart (a:tag, 2, index - 2)
			execute "normal! ?<" . tag_name . "\\>\<Cr>"
		else
			let tag_name = strpart (a:tag, 1, index - 1)
			execute "normal! /<\\/" . tag_name . "\\>\<Cr>"
		endif
	endif
endfunction


" This makes the '%' jump between the start and end of a single tag.
set matchpairs+=<:>

if exists ("xml_use_autocmds")
	" Auto Commands
	augroup xml
		au!
		au BufNewFile * call NewFileXML()
		au BufEnter * call TurnOnXML()
		au BufLeave * call TurnOffXML()
	augroup END
else
	call TurnOnXML()
endif


endif
