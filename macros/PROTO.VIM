" This script creates a prototype file containing javadoc comments and
" minimal method bodies for a Java source file.
"
" This is useful in many cases:
" 1. It speeds up the javadoc parsing process
" 2. Only methods/data members documented in the javadoc style will be used.
"    Therefor it's easy to exclude methods by using '/*' or '//' commenting style
" 3. If you're developing an API, you can give the prototype file to your users
"    without having to remove the method bodies manually. This may be necessary
"    for javadoc-enabled source code browser to work properly (e. g. the Microsoft
"    IntelliSense stuff).
"
" The prototype file will contain all methods and data members preceeded
" by a javadoc comment.
" The method body is substituted by a minimal body containing only a return
" statement where necessary.
"
" The prototype file will be created in the directory ../proto, which must exist.
"
" The parsing is not foolproof, it exspects a certain format.
" Especially there *must* be a javadoc comment preceeding the class definition
" (this should be the first javadoc comment in the file)


" Performs the prototype creation process
:function! MakeProto()
:  " Get the prototypes in buffer @p
:  let retCode = CollectProto()
:
:  " Edit the prototype file; directory must exist!
:  e ../proto/%
:
:  " Delete it's contents and insert the prototypes
:  normal 1GdG"pp
:
:  " Post-process the prototypes: insert return values
:  if retCode != -1
:    call InsertReturns()
:  endif
:endfunction


" Creates a skeleton prototype for the class contained in the current file
" The skeleton is copied to buffer @p
" The function also changes the buffer @r
" Contained classes are skipped as well as all methods and data members
" that are not preceeded by a javadoc comment.
:function! CollectProto()
:  " Get the class name from the filename
:  let @p = ""
:  let lastline = line("$")
:
:  " First collect any package and import statements
:  let i = 1
:  while i <= lastline
:    let currLine = getline(i)
:    if match(currLine, '^\s*\<package\>.*') != -1
:      call CPAddLine (currLine)
:    endif
:    if match(currLine, '^\s*\<import\>.*') != -1
:      call CPAddLine (currLine)
:    endif
:    let i = i + 1
:  endwhile
:  if @p != ""
:    call CPAddLine ("")
:  endif
:
:  " Now get the javadoc comment for the class
:  let i = 1
:  let i = CPCollectComment(i)
:  if i == -1
:    " No comment for the class found, exit
:    return -1
:  endif
:
:  " Find the class body
:  let i = CPCollectHeader(i)
:  if i == -1
:    " No body found
:    return -1
:  endif
:
:  " Copy the classes' javadoc comment and header to the output buffer
:  let @p = @p . @r
:  " Read the line containing the '{'
:  call CPAddLine (getline(i))
:
:  let i = i + 1
:
:  " Search for methods and data members
:  while i <= lastline
:    let @r = ""
:
:    " Find the next javadoc comment
:    let i = CPCollectComment(i)
:    if i == -1
:      break
:    endif
:
:    " Read the line following the comment
:    let currLine = getline(i)
:
:    if match(currLine, '.*\<class\>.*') != -1
:      " Skip contained classes
:
:      let i = CPCollectHeader(i)
:      if i == -1
:        " No header found
:        return -1
:      endif
:
:      " Skip it
:      exec 'normal ' . i . 'G0f{%'
:      let i = line(".") + 1
:      continue
:    endif
:
:    " Collect the data/method definition
:    if ((match(currLine, '.*;.*') != -1) || (match(currLine, '.*=.*') != -1))
:      " Data member definition
:
:      " Copy the javadoc comment to the output buffer
:      let @p = @p . @r
:
:      " Add the definition
:      while i <= lastline
:        call CPAddLine (currLine)
:        if match(currLine, '.*;.*') != -1
:          break
:        endif
:        let i = i + 1
:        let currLine = getline(i)
:      endwhile
:
:    else
:      " Method definition
:
:      " Collect the method header
:      let i = CPCollectHeader(i)
:      if i == -1
:        " No header found
:        return -1
:      endif

:      " Copy the javadoc comment and header to the output buffer
:      let @p = @p . @r
:
:      " Read the line with the '{' following the header
:      let currLine = getline(i)
:
:      let lineStart = matchstr(currLine, '^\s*')
:      call CPAddLine (lineStart . "{")
:      call CPAddLine (lineStart . "}")
:
:      " Skip the method body by executing a normal mode %
:      exec 'normal ' . i . 'G0f{'
:      normal %
:      let i = line(".")
:
:      " Add an empty line
:      call CPAddLine ("")
:    endif
:
:  let i = i + 1
:  endwhile
:
:  " Add the closing } for the class
:  call CPAddLine ("}")
:  return 0
:endfunction
 
" Finds the next javadoc comment starting at line 'line' and returns the number
" of the first line after the comment. Returns -1 if no comment is found.
" The comment text is saved in buffer @r
:function! CPCollectComment(line)
:  let i = a:line
:  let lastline = line("$")
:  while i <= lastline
:    let currLine = getline(i)
:
:    " Check if there is a javadoc comment starting in this line
:    if match(currLine, '.*\/\*\*.*') != -1
:      " Collect the javadoc comment
:      let @r = ""
:      while i <= lastline
:        let @r = @r . currLine . "\n"
:        if match(currLine, '.*\*\/.*') != -1
:          " End of comment detected
:          return i + 1
:        endif
:        let i = i + 1
:        let currLine = getline(i)
:      endwhile
:    endif
:
:    let i = i + 1
:  endwhile
:  return -1
:endfunction

" Finds the next '{' and collects any lines up to this. Returns the number
" of the line the '{' is found in. Returns -1 if no '{' is found.
" The header text is saved in buffer @r
:function! CPCollectHeader(line)
:  let i = a:line
:  let lastline = line("$")
:  while i <= lastline
:    let currLine = getline(i)
:
:    " Check if there is a javadoc comment starting in this line
:    if match(currLine, '.*{.*') != -1
:       return i
:    endif
:
:    let @r = @r . currLine . "\n"
:    let i = i + 1
:  endwhile
:  return -1
:endfunction

" Adds the string 'currLine' to the buffer @p as a new line
:function! CPAddLine(currLine)
:      let @p = @p . a:currLine . "\n"
:endfunction


" Works on the prototype file and inserts return statements where necessary.
:function! InsertReturns()
:  let className = expand("%:t:r")
:
:  " First skip the class header
:  normal 1G/^{
:
:  let i = line(".") + 1
:  while i <= line("$")
:    let currLine = getline(i)
:
:    " Check if there is a javadoc comment starting in this line
:    if match(currLine, '.*\/\*\*.*') != -1
:      " Yes, skip it
:      while 1
:        if match(currLine, '.*\*\/.*') != -1
:          " End of comment detected
:          break
:        endif
:        let i = i + 1
:        let currLine = getline(i)
:      endwhile
:      let i = i + 1
:      let currLine = getline(i)
:    endif
:
:    if match(currLine, '.*(.*).*') != -1 && match(currLine, '.*;.*') == -1
:      " Check if there is a known return type preceding the function
:      if match(currLine, '.*\[\].*(.*') != -1
:        " Array type
:        call InsertReturn(i, "null")
:      elseif match(currLine, '.*\<int\>.*(.*') != -1
:        call InsertReturn(i, "0")
:      elseif match(currLine, '.*\<long\>.*(.*') != -1
:        call InsertReturn(i, "0")
:      elseif match(currLine, '.*\<short\>.*(.*') != -1
:        call InsertReturn(i, "0")
:      elseif match(currLine, '.*\<byte\>.*(.*') != -1
:        call InsertReturn(i, "0")
:      elseif match(currLine, '.*\<double\>.*(.*') != -1
:        call InsertReturn(i, "0")
:      elseif match(currLine, '.*\<float\>.*(.*') != -1
:        call InsertReturn(i, "0")
:      elseif match(currLine, '.*\<boolean\>.*(.*') != -1
:        call InsertReturn(i, "false")
:      elseif match(currLine, '.*\<void\>.*(.*') == -1 && match(currLine, '.*\<' . className . '\>.*(.*') == -1
:        " It's not returning void and is not a constructor, use null; works in most cases
:        call InsertReturn(i, "null")
:      endif
:    endif
:    let i = i + 1
:  endwhile
:endfunction

" Inserts a return statement returning 'value' below the next line containing '{'
:function! InsertReturn(line, returnValue)
:  let j = a:line + 1
:  while j <= line("$")
:    let currLine = getline(j)
:    if match(currLine, '.*{.*') != -1
:      " Found '{'
:      " Get the indentation
:      let str = matchstr(currLine, '^\s*') . "\treturn " . a:returnValue . ";"
:      call InsertLine (j + 1, str)
:      return
:    endif
:    let j = j + 1
:  endwhile
:endfunction

" Inserts a single line 'lineString' before the line 'lineNum'
:function! InsertLine (lineNum, lineString)
:  se paste
:  exe 'normal' . a:lineNum . "GO" . a:lineString . "\<ESC>"
:  " exe 'normal' . ":" . a:lineNum . "insert\<CR>" . a:lineString . "\<CR>.\<CR>"
:endfunction


" Define a command calling the functions
:command! MakeProto call MakeProto()


" This mapping does it for all buffers
:map ;mp :MakeProto:n;mp


" :map ;y. :MakeProto
" :map ;q :w:so proto.vim

