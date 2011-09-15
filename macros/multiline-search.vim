" Here is a small script that allows searching for multiline patterns:

   function! Search(pattern)
      let save_report     = &report
      let save_register_a = @a
      set report=999999

      exe 'let pattern="'.a:pattern.'"'

      normal "ay$
      let @a = strpart(@a, 1, 999999)
      if line(".") < line("$")
         +,$ yank A
      endif

      let byte = match(@a, pattern)

      if byte >= 0
         exe 'goto '.(byte + line2byte(line(".")) + col("."))
      else
         echohl ErrorMsg
         echo 'search hit BOTTOM without match for: '.a:pattern
         echohl None
      endif

      let @a      = save_register_a
      let &report = save_report
   endfunction

   command! -nargs=+ Search call Search(<q-args>)

" As you can see the syntax is a bit different from the / search command.
" You can use all special characters like in double quote strings (see
" ":help expr-string"), but other special characters have to be escaped
" with an extra backslash.  Note: With DOS-Files (EOL is <CR>+<NL>) issue
" a ":set ff=unix" command before searching, otherwise you'll be led to
" the wrong position. And commands like "n" doesn't work with this, of
" course.
" 
" Ronald Schild
" at work:  mailto:rs@dps.de
" private:  mailto:rs@scutum.de

