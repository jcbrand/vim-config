" This is the beginning of a function for taking an input string and
" returning the value after "special characters" have been evaluated:
" <C-U> erases all previous input.  One might also want to implement
" <C-W> and others.
fun! DoSp(str)
  let s = substitute(a:str, '.*\<C-U>', "", "")
  return s
endfun

" This function evaluates the input string in Input mode.  Special
" characters, such as <C-U> and <C-N> will be executed in Input mode.
" Raw <Esc> characters will produce unpredictable results.
fun! EvalInput(string)
  new
  execute "normal a" . a:string . "\<Esc>ggyG"
  q!
  return @"
endfun

" Use with  :nmap % :call HTMLmatch()
" If the cursor is on a non-alphabetic character then invoke the normal
" behavior of %.  If the cursor is on an alphabetic character, attempt to
" jump from <tag> to </tag> and back.  This is just a quick demo; it does
" not deal with nesting.  For a more complete version, see matchit.vim .
fun! HTMLmatch()
  if getline(".")[col(".")-1] !~ "\\a"
    normal! %
    return
  endif
  execute "normal ?\\A\<CR>"
  normal lye
  if getline(".")[col(".")-2] == '/'
    execute 'normal ?<\s*' . @" . "\<CR>l"
  else
    execute 'normal /<\s*\/' . @" . "\<CR>ll"
  endif
endfun

augroup CPP
  autocmd BufEnter *.cpp,*.h inoremap { {<Esc>:call ClassHeader("-")<CR>a
  autocmd BufLeave *.cpp,*.h iunmap {
  " Keep your braces balanced!}}
augroup END

" With the above autocommands, this will insert a header every time you
" begin a new class in C++ .
fun! ClassHeader(leader)
  if getline(".") !~ "^\\s*class"
    return
  endif
  normal yyP$x
  let width = 80
  if exists("&tw")
    let width = &tw
  endif
  execute "normal " . (width-virtcol(".")-3) . "I" . a:leader . "\<Esc>"
  execute "normal a \<Esc>"
  execute "normal I//\<Esc>"
  " Keep your braces balanced!{
  execute "normal! jo};\<Esc>"
  normal k$
endfun

" This is my first user-defined command.  Unlike a user-defined function,
" a command can be called from the function Foo() and have access to the
" local variables of Foo().
" Usage:  :let foo = 1 | Line foo s/foo/bar
" Usage:  :let foo = 1 | let bar = 3 | Line foo,bar s/foo/bar
" There must be no spaces in "foo,bar".
command! -nargs=* Line
	\ | let Line_arg = matchstr(<q-args>, '\S\+')
	\ | let Line_arg = substitute(Line_arg, ",", " . ',' . ", "")
	\ | execute "let Line_range = " . Line_arg
	\ | let Line_cmd = substitute(<q-args>, '\S\+', "", "")
	\ | execute Line_range . Line_cmd
	\ | unlet Line_arg
	\ | unlet Line_range
	\ | unlet Line_cmd

" Usage:  :let foo = 1 | let bar = 3 | Range foo bar s/foo/bar
command! -nargs=* Range
	\ | execute substitute(<q-args>, '\(\S\+\)\s\+\(\S\+\)\(.*\)',
		\ 'let Range_range=\1.",".\2', "")
	\ | execute Range_range . substitute(<q-args>, '\S\+\s\+\S\+', "", "")
	\ | unlet Range_range

" Usage:  let ma = Mark() ... execute ma
" has the same effect as  normal ma ... normal 'a
" without affecting global marks.
" You can also use Mark(17) to refer to the start of line 17 and Mark(17,34)
" to refer to the 34'th (screen) column of the line 17.  The functions
" Line() and Virtcol() extract the line or (screen) column from a "mark"
" constructed from Mark() and default to line() and virtcol() if they do not
" recognize the pattern.
fun! Mark(...)
  if a:0 == 0
    return line(".") . "normal!" . virtcol(".") . "|"
  elseif a:0 == 1
    return a:1 . "normal!" . 0 . "|"
  else
    return a:1 . "normal!" . a:2 . "|"
  endif
endfun

" See comments above Mark()
fun! Line(mark)
  if a:mark =~ '^\d\+normal!\d\+|$'
    return matchstr(a:mark, '\d\+')
  else
    return line(a:mark)
  endif
endfun

" See comments above Mark()
fun! Virtcol(mark)
  if a:mark =~ '^\d\+normal!\d\+|$'
    return substitute(a:mark, '.*!\(.*\)|', '\1', "")
  else
  return col(a:mark)
  endif
endfun
