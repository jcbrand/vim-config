"=============================================================================
" File        : columnize.vim
" Author      : M A Aziz Ahmed (aziz@123india.com)
" Last update : Thu Mar 25 1999
"
" The function Columnize columnizes a range of lines. It puts each word of the
" line in a separate column. The blanks are filled with either spaces or tabs
" depending on the argument passed to the function.
"
" For example, the following lines  
"
"  This is an example.  
" Apples mangoes oranges  
" Tiger Lion Elephant Zebra  
"
" when input to the function will be converted to :  
"
"  This   is      an       example.  
"  Apples mangoes oranges  
"  Tiger  Lion    Elephant Zebra  
"=============================================================================

function! Columnize(useTabs) range
  "First job is to find the line with the maximum number of words
  let maxWords = 0
  let cur = a:firstline
  while (cur <= a:lastline)
    let currWords = CountWords(getline(cur))
    if ( currWords > maxWords )
      let maxWords = currWords
    endif
    let cur = cur + 1
  endwhile

  if (maxWords == 0)
    return
  endif
  "Now Columnize with respect to each word
  let curWord = 1
  while (curWord <= maxWords)
    "Find the column of the farthest curWord
    let cur = a:firstline
    let maxCol = 0
    while (cur <= a:lastline)
      execute (cur)
      if (curWord<=CountWords(getline(".")))
        "Get the virtual column of the curWord'th word
        let curWordPosn = GetWordPosn(curWord)
        if (curWordPosn > maxCol)
          let maxCol = curWordPosn
        endif
      endif
      let cur = cur+1
    endwhile

    "If tabs are to be used, maxCol should be a multiple of tabstop
    let tabStop = &tabstop
    if ((a:useTabs==1) && (maxCol>1) && (maxCol%tabStop!=0))
      let maxCol = maxCol + tabStop - (maxCol%tabStop)
    endif

    "Move all curwords to the right so that they are all aligned in the same
    "column.
    let cur = a:firstline
    while (cur <= a:lastline)
      exe cur
      if (curWord<=CountWords(getline(".")))
        "Move to the word position
        call GetWordPosn(curWord)
        "Insert tabs or spaces till it reaches maxCol
        call MoveTillColumn(maxCol,a:useTabs)
      endif
      let cur = cur+1
    endwhile
    let curWord = curWord + 1
  endwhile
endfunction

"=============================================================================
" Function to count the number of words in a line.
function! CountWords(inputString)
  "Convert all the words to 1's
  let allOnes = substitute(a:inputString,"\\S\\+","1","g")
  "Remove spaces and tabs!
  let allOnes = substitute(allOnes,"\\s","","g")
  return strlen(allOnes)
endfunction

"=============================================================================
" Function to get a word position, also moves the cursor till that word
" Doesn't take care of line boundaries
function! GetWordPosn(word)
  "Goto beginning of line
  normal ^
  if (a:word==0)
    return 0
  elseif (a:word==1)
    return virtcol(".")
  else
    let wordMove = a:word-1
    exe ("normal ".wordMove."W")
    return virtcol(".")
  endif
endfunction

"==============================================================================
" Function which inserts spaces or tabs till cursor reaches the specified
" column
function! MoveTillColumn(colNum,useTabs)
  while (virtcol(".") < a:colNum)
    if (a:useTabs==1)
      normal i  l
    else
      normal i l
    endif
  endwhile
endfunction
"==============================================================================
