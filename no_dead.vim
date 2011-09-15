
" unmap dead keys

" make sure the mapping exists (to avoid error messages)
source /home/jc/.vim/html_dead.vim

:imap <F9>      <ESC><F9>a
:map <F9>      :source /home/jc/.vim/text_dead.vim<CR>

:iunmap "a
:iunmap "A
:iunmap "e
:iunmap "E
:iunmap "i
:iunmap "I
:iunmap "o
:iunmap "O
:iunmap "u
:iunmap "U
:iunmap "y
:iunmap "<space>

:iunmap 'a
:iunmap 'A
:iunmap 'e
:iunmap 'E
:iunmap 'i
:iunmap 'I
:iunmap 'o
:iunmap 'O
:iunmap 'u
:iunmap 'U
:iunmap 'y
:iunmap '<space>

:iunmap 'c
:iunmap 'C

:iunmap `a
:iunmap `A
:iunmap `e
:iunmap `E
:iunmap `i
:iunmap `I
:iunmap `o
:iunmap `O
:iunmap `u
:iunmap `U
:iunmap `<space>

:iunmap ^a
:iunmap ^A
:iunmap ^e
:iunmap ^E
:iunmap ^i
:iunmap ^I
:iunmap ^o
:iunmap ^O
:iunmap ^u
:iunmap ^U
:iunmap ^y
:iunmap ^<space>

:iunmap ~n
:iunmap ~N
:iunmap ~<space>

