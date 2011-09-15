""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pushd/popd implementation for VIM
" Maintainer:	Hari Krishna DSV (hari@india.dharma.com)
" Last change:	1999 Jan 31
"
" TODO:
"	Fix the possible problems (search for PROBLEM).
"	Cache nDirs and let PushDir () and PopDir () manage it.
"	Better implementation for Pushd () without arguments.
"       Check if any inconsistencies exist wrt to csh.
"       Provide work-around for command, popd without arguments not working.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Define the commands to conveniently access them. Use the same commands as
" that provided by csh.
" PROBLEM: why is this passing the string "  " if no arguments are given ???
:command! -nargs=? -complete=command Pushd call Pushd(<q-args>)
:ca pushd Pushd
:command! -nargs=? -complete=command Popd call Popd(<q-args>)
:ca popd Popd
:ca dirs call Dirs ()

"
" The front-end functions.
"

" List out all the directories in the stack.
:function! Dirs ()
    echo substitute (g:dirStack, g:dirSep, " ", "g")
:endfunction

" Pushd.
:function! Pushd (...)
    if a:0 == 0
	let nDirs = NoOfDirs ()
	" First check if there are two entries.
	if nDirs == 1
	    echo "pushd: No other directory"
	    return
	endif

	" Exchange the first two entries.
	" Pop the first two directories and push them in reverse order.
	" This is an inefficient way, as this is going to change the directory
	" thrice. What is the better way ???
	let firstDir = PopDir ("pushd")
	let secondDir = PopDir ("pushd")
	call PushDir (firstDir)
	call PushDir (secondDir)
    elseif a:0 == 1
    " If a directory name is given, then push it on to the stack and cd to it.
    if match (a:1, "+") != 0
	    if ! isdirectory (a:1)
		echo a:1 " -- Not a directory"
		return
	    endif

	    call PushDir (a:1)
	else
	    " PROBLEM: How do I find if the number is a valid number ???
	    let dirToChange = PopDir ("pushd", a:1)
	    if dirToChange == ""
		return; " On error.
	    else
		call PushDir (dirToChange)
	    endif
	endif
    else
	" Too many arguments.
    endif
:endfunction


" A fron-end to PopDir ()
" Prevents the stack to be emptied.
:function! Popd (...)
    let nDirs = NoOfDirs ()
    " Don't let the stack to be emptied. For us one having one directory itself
    " is like it is already empty.
    if nDirs == 1
	echo "popd: Directory stack empty"
	return
    endif
    " PROBLEM: How do I pass all the arguments as they are ???
    if a:0 == 0
	call PopDir ("popd")
    elseif a:0 == 1
	call PopDir ("popd", a:1)
    endif
:endfunction

"
" Helper functions.
" These only read the datastructure.
"

:function! ChDir (dir)
    echo ":cd" a:dir
    exec ":cd" a:dir
:endfunction


" Peek at the top directory.
:function! PeekDir ()
    let index = match (g:dirStack, g:dirSep)
    if index == -1
	return ""
    endif

    let topDir = strpart (g:dirStack, 0, index)
    return topDir
:endfunction

" Count the number of directories in the stack.
:function! NoOfDirs ()
:   if g:dirStack == ""
:	return 0
:   endif
:
:   let nOccur = 0
:   let dirStackStr = g:dirStack
:   let len = strlen (g:dirStack)
:   let sepLen = strlen (g:dirSep)
:   let index = match (dirStackStr, g:dirSep)
" :   echo "index = " index
:   while index != -1
:	let nOccur = nOccur + 1
:	let tmplen = len - (index + sepLen)
" :	echo "tmplen = " tmplen
:	let index = index + sepLen
:	let dirStackStr = strpart (dirStackStr, index, tmplen)
" :	echo "new string " . dirStackStr
:	let len = tmplen
" :	echo "new length " len
:	let index = match (dirStackStr, g:dirSep)
" :	echo "index = " index
:   endwhile
:   return nOccur
:endfunction

"
" Low-level functions.
" These are the functions which actually manipulate the stack.
" These also take care to match the first entry with the current directory,
" except when the stack is emptied.
"

" Configure the separator string for storing the directories.
" PROBLEM: what if the directory name contains this string ? If VIM has arrays
" this problem would not have come.
:let dirSep = ";"

" Initialize the directory stack. A private data structure to be manipulated
" exclusively by PushDir () and PopDir (), though others can read this.
:let dirStack=getcwd () . dirSep


" Pop the first directory and return it.
:function! PopDir (for, ...)
    " echo "PopDir: no. of args" a:0
    let nDirs = NoOfDirs ()
    if nDirs == 0
	echo "PopDir: stack empty"
	return
    endif

    let removedDir = ""
    if a:0 == 0
	" echo "PopDir: No args"
	" PROBLEM: match should accept a starting index.
	let index = match (g:dirStack, g:dirSep)
	let removedDir = strpart (g:dirStack, 0, index)
	" remaining stack
	let g:dirStack = strpart (g:dirStack, index + 1, strlen (g:dirStack) -
strlen (removedDir))
	" If this is not the last one which is popped.
	if nDirs != 1
	    let topDir = PeekDir ()
	    call ChDir (topDir)
	endif
	" PROBLEM: Why is it going to elseif if I don't return here ???
	return removedDir
    elseif match (a:1, "+") != 0
	echo a:for . ": Invalid argument"
	return ""
    else
	" PROBLEM: How do I find if the number is a valid number ???
	let dirNo = strpart (a:1, 1, strlen (a:1)) + 1 " 0 means 1.
	if dirNo > nDirs
	    echo a:for . ": Directory stack not that deep"
	    " echo "PopDir: Done 2"
	    return ""
	else
	    " Collect the top (dirNo - 1) directories and then remove the next
	    " directory.
	    " PROBLEM: a command such as "set" in sh would have simplified the
	    " job.
	    let collectStack = ""
	    let copyStack = g:dirStack " This is where we will work.
	    let i = 0
	    while i != dirNo
		let index = match (copyStack, g:dirSep)
		let nextDir = strpart (copyStack, 0, index)
		let copyStack = strpart (copyStack, index + 1, strlen
(copyStack) - strlen (nextDir))
		" The last pop should not be collected.
		if i != (dirNo - 1)
		    if i != 0 " If not the first one to be popped.
			let collectStack = collectStack . nextDir . g:dirSep
			" echo "collecting" nextDir
		    else
			let collectStack = nextDir . g:dirSep
			" echo "collecting" nextDir
		    endif
		endif
		let i = i + 1
	    endwhile
	    " echo "collectStack" collectStack
	    " Reconstrcut the stack.
	    if copyStack == ""
		let g:dirStack = collectStack
	    else
		if collectStack == ""
		    let g:dirStack = copyStack
		else
		    let g:dirStack = collectStack . copyStack
		endif
	    endif
	    return nextDir
	endif
    endif
    " echo "PopDir: Done 3"
    return removedDir
:endfunction


" Push the directory on to the stack and change directory to it.
:function! PushDir (dir)
    if g:dirStack == ""
	let g:dirStack = a:dir . g:dirSep
    else
	let g:dirStack = a:dir . g:dirSep . g:dirStack
    endif
    call ChDir (a:dir)
:endfunction

