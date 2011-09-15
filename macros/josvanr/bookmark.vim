" **bookmark.vim**
" 
" SUMMARY:
" 
"   Bookmark your favorite files, and easy-access them later.
"
" MAPS:
" 
"   ,w     Add current file to the bookmarks file.
"   ,b     Open the bookmarks file.
"
"   From the bookmarks file:
" 
"  <cr>   Edit the file on the current line.
"  <esc>  Quit the bookmarks file.
" 
" NOTES:
" 
"   * The bookmarks file can be edited: ie. listed files can be 
"     deleted, or moved to other lines.
"   * The bookmarks file is called ~/bookmarks.
" 
" -----------------------------------------------------------------------------
map ,w :let @a=expand("%:p")<cr>:sp ~/bookmarks<cr>:put a<cr>:w<cr>:bd<cr>
map ,b :let @e=bufnr(bufname("%"))<cr>:e ~/bookmarks<cr>:echo '--FAVORITES MODE --'<cr>
" ----------------------------------------------------------------------------- 
if !exists("_bookmark_vim_sourced")
let _bookmark_vim_sourced=1
" ----------------------------------------------------------------------------- 
so ~\buflist.vim

map __bookmarks_load- :let @a=expand("<cfile>:p")<cr>:bd!<cr>:exe("e ".@a)<cr>

aug bookmarks
  au bufenter bookmarks nm <cr> __bookmarks_load-
  au bufleave bookmarks nun <cr>
  au bufenter bookmarks nm <esc> :bd<cr>:b <c-r>e<cr>
  au bufleave bookmarks nun <esc>
  au bufleave bookmarks so ~/_vimrc
aug END
" ----------------------------------------------------------------------------- 
endif
" ----------------------------------------------------------------------------- 
