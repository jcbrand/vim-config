"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Purpose: Create a menu with most recently used files
" Author: Rajesh Kallingal <RajeshKallingal@email.com>
" Original Author: ???
" Last Modified: Thu Feb 24 11:34:21 2000
"
" Note:
" 	Make sure you have added '!' in 'viminfo' option to save global valiables
"	Global Variables Used:
"		MRU_BUFFERS - keeps the lsit of recent buffers, usedto build the menu
"		MRU_MAX - maximum entries to keep in the list
"		MRU_HOTKEYS - whether to have a hot key of 0-9, A-Z in the menu
"		MRU_MENU - menu name to use, default is '&Recent'
"		spooldir - spool directory of PRFILE32, file activities in this
"				folder is not tracked
"
"	Excludes:
"		help files, files in spooler directory for PRFILE32
" vim ts=4 : sw=4 : tw=0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! MRUInitialize()
	
	call MRUInitializeGlobals ()
	call MRURefresh ()

endfunction

function! MRUInitializeGlobals()
	if !exists('g:MRU_MENU')
		"name of the menu, user can change this later
		let g:MRU_MENU = '&Recent'
	endif
	if !exists('g:MRU_MAX')
		" Maximum entries to remember
		let g:MRU_MAX = 30
	endif
	if !exists('g:MRU_BUFFERS')
		call MRUJoinBufList ()
	endif
	let g:mru_count = 0
endfunction

function! MRUJoinBufList()
	" Join the MRU_BUFFERn into MRU_BUFFERS, apparently when vim is
	" restarted it reads in only first 494 characters of the global buffer.
	" THIS IS JUST A WORK AROUND
	let counter = 1
	let g:MRU_BUFFERS = ''
	while ( counter <= g:MRU_BUF_COUNT )
		execute 'let g:MRU_BUFFERS = g:MRU_BUFFERS . g:MRU_BUFFER' . counter
		execute 'unlet g:MRU_BUFFER' . counter
		let counter = counter + 1
	endwhile
	unlet g:MRU_BUF_COUNT
endfunction

function! MRURefresh()
	" remove the MRU Menu
	execute 'amenu ' . g:MRU_MENU . '.x x'
	execute 'aunmenu ' . g:MRU_MENU

	" use this variable to keep the list of entries in the menu so far
	let menu_list = ''

	let list = g:MRU_BUFFERS
	let g:mru_count = 0
	while list != "" && g:mru_count < g:MRU_MAX
		if g:mru_count % 10 == 0 && g:mru_count / 10 > 0
			execute 'amenu ' . g:MRU_MENU . '.-sep' . g:mru_count / 10 . '- <NUL>'
		endif
		let entry_length = match(list, "\377")
		if entry_length >= 0
			let fullpath = strpart(list, 0, entry_length)
			let list = strpart(list, entry_length+1, strlen(list))
		else
			let fullpath = list
			let list = ""
		endif

		if fullpath != ""
			let filename = fnamemodify (fullpath, ':t')

			" append a space to the filename to enable multiple entries in menu
			" which has the same filename but different path
			while ( match(menu_list, '\<' . filename . "\/") >= 0)
				let filename = filename . ' '
			endwhile

			let menu_list = menu_list . filename . "\/"

			let g:mru_count = g:mru_count + 1
			call MRUAddOneBuffer (fullpath, filename)
		endif

	endwhile

" Add the Option menu entries 
	execute 'amenu ' . g:MRU_MENU . '.-sep0- <NUL>'
	if exists ("g:MRU_HOTKEYS") && g:MRU_HOTKEYS == 1
		execute 'amenu ' . g:MRU_MENU . '.Options.Non\ Numbered\ Menu :call MRUOptionsToggleHotKey()<CR>'
		execute 'tmenu ' . g:MRU_MENU . '.Options.Non\ Numbered\ Menu Remove sequential number/alphabet from the menu entry'
	else
		execute 'amenu ' . g:MRU_MENU . '.Options.Numbered\ Menu :call MRUOptionsToggleHotKey()<CR>'
		execute 'tmenu ' . g:MRU_MENU . '.Options.Numbered\ Menu Add a sequential number/alphabet to the menu entry (0-9/A-Z)'
	endif

	execute 'amenu ' . g:MRU_MENU . '.Options.Set\ Menu\ Size :call MRUOptionsSetMenuSize()<CR>'
	execute 'tmenu ' . g:MRU_MENU . '.Options.Set\ Menu\ Size Allows you to change the number of entries in menu.'
	execute 'amenu ' . g:MRU_MENU . '.Options.Rename\ Menu :call MRUOptionsSetMenuName()<CR>'
	execute 'tmenu ' . g:MRU_MENU . '.Options.Rename\ Menu Allows you to rename the Top Menu Name'

	execute 'amenu ' . g:MRU_MENU . '.Options.-sep0- <NUL>'
	execute 'amenu ' . g:MRU_MENU . '.Options.Remove\ Invalid :call MRUOptionsClearNotFound()<CR>'
	execute 'tmenu ' . g:MRU_MENU . '.Options.Remove\ Invalid Removes files no longer exists from the list'
	execute 'amenu ' . g:MRU_MENU . '.Options.Clear\ List :call MRUOptionsClearAll()<CR>'
	execute 'tmenu ' . g:MRU_MENU . '.Options.Clear\ List Removes all the entries from this menu.'

endfunction

function! MRUAddOneBuffer(fullpath, filename)
	" Add the entry to the menu

	let menu_entry = a:filename . "\t" . fnamemodify(a:fullpath,':h')
	let menu_entry = escape(menu_entry, '\\. 	|\~')
	let menu_entry = substitute (menu_entry, '&', '&&', 'g') "incase there is an & in the filename

	if bufloaded (a:fullpath)
		let menu_command = ' :buffer ' . a:fullpath . '<cr>'
		let tmenu_text = 'Goto Buffer ' . a:fullpath
	else
		let menu_command = ' :edit ' . a:fullpath . '<cr>'
		let tmenu_text = 'Edit File ' . a:fullpath
	endif
	if exists ("g:MRU_HOTKEYS") && g:MRU_HOTKEYS == 1
		 " use hot keys 0-9, A-Z
		 if g:mru_count <= 10
			let alt_key = g:mru_count - 1
		else
			let alt_key = nr2char (g:mru_count + 54) "start with A at 65
		endif
		exe 'am '. g:MRU_MENU . '.' . alt_key . '\.\ ' . menu_entry . menu_command
		exe 'tmenu ' . g:MRU_MENU . '.' . alt_key . '\.\ ' . substitute (escape (a:filename, '\\. 	|\~'), '&', '&&', 'g') . ' ' . tmenu_text
	else
		exe 'am ' . g:MRU_MENU . '.' . menu_entry . menu_command
		exe 'tmenu ' . g:MRU_MENU . '.' . substitute (escape (a:filename, '\\. 	|\~'), '&', '&&', 'g') . ' ' . tmenu_text
	endif
endfunction

function! MRUAddBuffer()
	" add current buffer to list of recent travellers.  Remove oldest if
	" bigger than MRU_MAX
	let filename = expand("<afile>:p")

	" Exclude following files/types/folders
	if &filetype == 'help'
		" do not add help files to the list
		return	
	endif
	if exists("g:spooldir") && filename =~ g:spooldir
		" do not add spooled files to the list
		return	
	endif

	if filename != '' && filereadable (expand ("<afile>"))

		call MRUInitializeGlobals () " incase vim is started with a file

		" Remove the current file entry from MRU_BUFFERS
		let g:MRU_BUFFERS = substitute(g:MRU_BUFFERS, escape(filename,'\\~'). "\377", '', 'g')
		" Add current file as the first in MRU_BUFFERS list
		let g:MRU_BUFFERS = filename . "\377" . g:MRU_BUFFERS

		" Remove oldest entry if > MRU_MAX
		if g:mru_count > g:MRU_MAX
			let trash = substitute(g:MRU_BUFFERS, "\377", "ÿ", "g")
			let trash = matchstr(trash, '\([^ÿ]*ÿ\)\{'.g:MRU_MAX.'\}')
			let g:MRU_BUFFERS = substitute(trash, "ÿ", "\377", "g")
		endif
		call MRURefresh()
	endif

endfunction

" Customizing Options
function! MRUOptionsClearAll()
	" Clear the MRU List
	let choice = confirm("Are you sure you want to clear the list?", "&Yes\n&No", 2, "Question")

	if choice != 1
		return
	endif
	let g:MRU_BUFFERS = ''
	let g:mru_count = 0
	call MRURefresh ()

endfunction

function! MRUOptionsToggleHotKey()
	if exists ("g:MRU_HOTKEYS") && g:MRU_HOTKEYS == 1
		let g:MRU_HOTKEYS = 0
	else
		let g:MRU_HOTKEYS = 1
	endif
	call MRURefresh ()
endfunction

function! MRUOptionsSetMenuName()
	exec 'let menu_name = input ("Enter Menu Name [' . g:MRU_MENU . ']: ")'

	if menu_name == ""
		return
	endif

	" remove current MRU Menu
	execute 'amenu ' . g:MRU_MENU . '.x x'
	execute 'aunmenu ' . g:MRU_MENU

	let g:MRU_MENU = menu_name
	call MRURefresh ()
endfunction

function! MRUOptionsSetMenuSize()
	exec 'let menu_size = input ("Enter Menu Size [' . g:MRU_MAX . ']: ")'

	if menu_size == ""
		return
	endif

	let g:MRU_MAX = menu_size
	call MRURefresh ()
endfunction

function! MRUOptionsClearNotFound()

	" Remove non existing files from the menu

	let list = g:MRU_BUFFERS
	let buf_list = ""
	let buf_count = 0
	while list != ""
		let entry_length = match(list, "\377")
		if entry_length >= 0
			let fullpath = strpart(list, 0, entry_length)
			let list = strpart(list, entry_length+1, strlen(list))
		else
			let fullpath = list
			let list = ""
		endif
		if filereadable (fullpath)
			if buf_count == 0
				let buf_list = fullpath
			else
				let buf_list = buf_list . "\377" . fullpath
			endif
			let buf_count = buf_count + 1
		endif
	endwhile

	let g:MRU_BUFFERS = buf_list
	let g:mru_count = buf_count
	call MRURefresh()

endfunction

function! MRUVimLeavePre()
	" Split the MRU_BUFFERS int to small ones (< 494), apparently when vim is
	" restarted it reads in only first 494 characters of the global buffer.
	" THIS IS JUST A WORK AROUND

	" Remove entries past MRU_MAX
	if g:mru_count > g:MRU_MAX
		let trash = substitute(g:MRU_BUFFERS, "\377", "ÿ", "g")
		let trash = matchstr(trash, '\([^ÿ]*ÿ\)\{'.g:MRU_MAX.'\}')
		let g:MRU_BUFFERS = substitute(trash, "ÿ", "\377", "g")
	endif

	let counter = 0
	while ( strlen ( g:MRU_BUFFERS) > 0)
		let counter = counter + 1
		let temp_str = strpart ( g:MRU_BUFFERS, 0, 400 )
		let g:MRU_BUFFERS = strpart ( g:MRU_BUFFERS, 400, 99999999 )
		exec 'let g:MRU_BUFFER' . counter . '=temp_str'
	endwhile
	unlet g:MRU_BUFFERS
	let g:MRU_BUF_COUNT = counter
	
endfunction

aug MRU
	au!
	au VimEnter * call MRUInitialize()
"	au GUIEnter * call MRUInitialize()
	au BufDelete,BufEnter,BufWritePost,FileWritePost * call MRUAddBuffer()
	au VimLeavePre * nested call MRUVimLeavePre()
aug END
