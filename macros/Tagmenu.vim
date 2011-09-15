"
" TagMenu -- build a vim menu from a tags file
"
" Usage: call TagMenu(mode)
"        where mode = "-p" -- parse an existing tag file
"                     "-s" -- with submenus
"                     "-r" -- build tags recursively
"                     "-d" -- current directory only
"                     ""   -- current file only
"
"        you can combine some of these also.  check out lines 61-66 for little
"        more explanation.
"
function! TagMenu(mode)
   let ctagsProg = "!ctags --lang=java"
"   let ctagsProg = "ctags --lang=java --java-types=cmC"
"   let ctagsProg = "!jtags -c -iF"
   
   if(expand("%") == "")
      return
   endif

   "--- Save the current buffer number
   "
   let curBufNum = bufnr("%")

   "--- Call ctags to generate a new tags file
   "
   if(a:mode !~ "-p")
      if(a:mode =~ "-d")
         "execute '!ctags --lang=java --java-types=fm *'
         execute ctagsProg.' *'
      elseif(a:mode =~ "-r")
         "execute '!ctags --lang=java --java-types=fm -R'
         execute ctagsProg.' -R'
      else 
         "execute '!ctags --lang=java --java-types=fm %'
         execute ctagsProg.' %'
      endif
   endif

   "--- If there's no tags file then there's no point continuing
   "
   if(!filereadable('tags'))
      echo "No readable tags file!"
      return
   endif

   "--- Build the new tags menu
   "
   " open the tags file
   "
   execute 'edit tags'
   execute 'buffer tags'

   " remove the old menu
   "
   unmenu Tags
   unmenu! Tags

   " write the menu reproduction items
   "
   execute '9000amenu T&ags.&(Re)Generate\ Tags.&This\ File\ Only :call TagMenu("")<CR>'
   execute 'amenu T&ags.&(Re)Generate\ Tags.T&his\ File\ Only\ w/\ Submenus :call TagMenu("-s")<CR>'
   execute 'amenu T&ags.&(Re)Generate\ Tags.&Directory :call TagMenu("-d")<CR>'
   execute 'amenu T&ags.&(Re)Generate\ Tags.D&irectory\ w/\ Submenus :call TagMenu("-d-s")<CR>'
   execute 'amenu T&ags.&(Re)Generate\ Tags.&Recurse :call TagMenu("-r")<CR>'
   execute 'amenu T&ags.&(Re)Generate\ Tags.&Parse\ Only :call TagMenu("-p")<CR>'

   " process the tags file
   "
   let curLineNum = 0
   let endLineNum = line("$")
   while(curLineNum < endLineNum)
      let curLineNum = curLineNum + 1
      let curLine    = getline(curLineNum)

      if((curLine =~ '^!') || (curLine =~ '^1'))
         continue
      endif

      let i = 0
      while(curLine[i] != "\t")
         let i = i+1
      endwhile
      let tagname = strpart(curLine, 0, i)

"      let i = i+1
"      let j = i
"      while(curLine[i] != "\t")
"         let i = i+1
"      endwhile
"      let filename = strpart(curLine, j, i-j)

      let tagcmd = "amenu T&ags"
      if((a:mode =~ "-s") || (a:mode =~ "-r"))
         if(char2nr(tagname[0]) <= char2nr('Z'))
            let num  = char2nr(tagname[0]) + 32
            let char = nr2char(num)
            let tagcmd = tagcmd.".".char
         else
            let tagcmd = tagcmd.".".tagname[0]
         endif
      endif
      let tagcmd = tagcmd.".".tagname."   :tag ".tagname."<CR><BAR>z<CR>"
      execute tagcmd
   endwhile

   execute 'bd'
   execute 'b '.curBufNum
endfunction

