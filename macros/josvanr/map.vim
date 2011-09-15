" **map.vim**
" 
"|SETTINGS|Some maps|Customize some mappings|%|
"|SETTINGS|Some maps||%|
"|SETTINGS|Some maps|Turn of search pattern highlight|map | :nohlsearch<cr>|
map ,/ :nohlsearch<cr>
"|SETTINGS|Some maps|Reset search pattern|nm | /^<cr><c-o>|
nm <cr> /^<cr><c-o>
" Edit _vimrc file.
command! H edit ~/_vimrc
" U (n) Go to next buffer. 
map U :bn<cr>
" [ (n) Save current file.
map [ :w!<cr>
" \ (n) Quit file.
map \ :q!<cr>
" ] (n) Remove buffer.
map ] :bd!<cr>
" ge   Edit any file under cursor.
map ge :e! <cfile><cr>
" gc   Change directory to that of file under cursor.
map gc :execute("cd ".expand("<cfile>:h"))<cr>:pwd<cr>
" <bs> Jump to previous in jumplist and redraw screen in middle.
nmap <bs> <c-o>z.
" <space> Jump to next empty line.
nmap <space> }
" <s-space> Jump to previous empty line.
nmap <s-space> {
" <f2> Add a 'work' tag.
map <f2> /\|WORK\|<cr>zt5<c-y>
" <s-f2> Jump to the 'work' tag.
map <s-f2> :call PrintLineAfter("\|WORK\|")<cr>s
" Screen line-oriented cursor movement.
map j gj
map k gk
" <tab> (i) Complete next keyword.
imap <tab> <c-p>
" <s-tab> (i) Complete previous keyword.
imap <s-tab> <c-n>
" Redraw cursor position in the middle of the screen.
map zm zz
" Insert a , 
imap ,, ,<esc>a
" Always jump to line & column of mark.
map ' `
" Visually select contents of "text contained in double quotes".
vmap i" <esc>T"vt"
" Visually select contents of 'text contained in single quotes'.
vmap i' <esc>T'vt'
" Append if cursor at end of line, else insert.
if !exists("_map_vim_sourced")
  function! IArega()
    if col(".")==LastCol()
      let @a="a"
    else 
      let @a="i"
    endif
  endfunction
endif
" 
map _ia- :call IArega()<cr>@a
" Enclose visually selected area in quotes, braces etc.
vmap q x_ia-""<esc>P
vmap ' x_ia-''<esc>P
vmap ( x_ia-()<esc>P
vmap ) x_ia-()<esc>P
vmap \| x_ia-\|\|<esc>P
vmap ** x_ia-****<esc>hP

" Set textwidth to 20, 30 etc.
map ,,tc :set textwidth=<C-R>=col(".")<C-M>
map ,,t2 :set tw=20<cr>
map ,,t3 :set tw=30<cr>
map ,,t4 :set tw=40<cr>
map ,,t5 :set tw=50<cr>
map ,,t6 :set tw=60<cr>
map ,,t7 :set tw=70<cr>
map ,,t8 :set tw=80<cr>
map ,,t9 :set tw=90<cr>
map ,,t1 :set tw=100<cr>
" Format a paragraph to width tw
if !exists("_map_vim_sourced")
  function! FormatPar(tw)
    let oldtw=&tw
    execute "set tw=".a:tw
    normal gqip
    execute "set tw=".oldtw
  endfunction
endif
" Format a paragraph to width 20, 30 etc.
map ,,f2 :call FormatPar(20)<cr>
map ,,f3 :call FormatPar(30)<cr>
map ,,f4 :call FormatPar(40)<cr>
map ,,f5 :call FormatPar(50)<cr>
map ,,f6 :call FormatPar(60)<cr>
map ,,f7 :call FormatPar(70)<cr>
map ,,f8 :call FormatPar(80)<cr>
" Format a paragraph to width of current cursor column
map ,,fc :call FormatPar(col("."))<cr>
" Save the brackets [ and ]
noremap _[- [
noremap _]- ]
" Translate the current dutch document into danish
" (By Sven Guckes.)
map __translate- :%s/[aeiou]\([aeiou]\)/\1/g<cr>

" Restore mappings from external files, if necessary
" 
" if exists("_bookmark_vim_sourced")|so ~/bookmark.vim|end
" if exists("_buflist_vim_sourced")|so ~/buflist.vim|end
" if exists("_comments_vim_sourced")|so ~/comments.vim|end
" if exists("_compile_vim_sourced")|so ~/compile.vim|end
" if exists("_filebrws_vim_sourced")|so ~/filebrws.vim|end
" if exists("_filebrwsu_vim_sourced")|so ~/filebrwsu.vim|end
" if exists("_fold_vim_sourced")|so ~/fold.vim|end
" if exists("_ftpbrws_vim_sourced")|so ~/ftpbrws.vim|end
" if exists("_funuse_vim_sourced_")|so ~/funuse.vim|end
" if exists("_grep_vim_sourced")|so ~/grep.vim|end
" if exists("_grepu_vim_sourced")|so ~/grepu.vim|end
" if exists("_htmlfun_vim_sourced")|so ~/htmlfun.vim|end
" if exists("_inline_vim_sourced")|so ~/inline.vim|end
" if exists("_josfix_vim_sourced")|so ~/josfix.vim|end
" if exists("_ngmenu_vim_sourced")|so ~/ngmenu.vim|end
" if exists("_setup_vim_sourced")|so ~/setup.vim|end
" if exists("_tab_vim_sourced")|so ~/tab.vim|end
" if exists("_tags_vim_sourced")|so ~/tags.vim|end
" if exists("_userfun_vim_sourced")|so ~/userfun.vim|end

let _map_vim_sourced=1
" 
"|SETTINGS|About|Settings editor by Jos van Riswick. josvanr@xs4all.nl|%|
"|SETTINGS|About||%|
"|SETTINGS|About|   Customize mappings and settings interactively using this editor.|%|
"|SETTINGS|About||%|
"|SETTINGS|About|   For more information see the following files: |%|
"|SETTINGS|About||%|
"|SETTINGS|About|setup_vim|X|:e ~/setup.vim<cr>|
"|SETTINGS|About|map_vim|X|:e ~/map.vim<cr>|
"|SETTINGS|About|settings_vim|X|:e ~/settings.vim<cr>|
"|SETTINGS|About|_vimrc|X|:e ~/_vimrc<cr>|
"|SETTINGS|About||%|
"|SETTINGS|About|   TODO|%|
"|SETTINGS|About|      Speed everything up.|%|
"|SETTINGS|About||%|
"|SETTINGS|About|   BUGS|%|
"|SETTINGS|About|      * You can't use dots in the item names|%|
"|SETTINGS|About|      * All item names in a leaf must be unique|%|
"|SETTINGS|About||%|
"|SETTINGS|About|Remove this 'About' leaf at the end of the file map.vim|%|

