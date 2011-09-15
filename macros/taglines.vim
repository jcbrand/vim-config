" F5: Add a tagline and advance to the next one
" mX			mark where we are
" :sp ~/.fortunes<CR>	open a window on ~/.fortunes
" gg			njj: Go to the top
" d/^--<CR>		delete until the next line starting with "--"
" Gp			Go to the end and put the just deleted text there
" :wq<CR>		Write the ~/.fortunes file and close the window
" 'XG			Go to the last line of the original file
" A<CR><Esc>		Add an empty line
" p			put the fortune text
" `X			return to where we started

map <F5> mX:sp ~/.taglines<CR>ggd/^--<CR>Gp:wq<CR>'XGA<CR><Esc>p`X
