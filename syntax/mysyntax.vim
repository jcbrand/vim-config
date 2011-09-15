augroup syntax

" Add XXX to vimCommentGroup  
  au  BufNewFile,BufRead *vimrc*,*.vim,.exrc,_exrc           so ~/.vim/syntax/vim.vim

" For Zope DTML
  au! BufNewFile,BufReadPost *.dtml
  au  BufNewFile,BufReadPost *.dtml                          so ~/.vim/syntax/dtml.vim

" For CMF Controler Scripts
  au! BufNewFile,BufReadPost *.cpy
  au  BufNewFile,BufReadPost *.cpy                          so ~/.vim/syntax/python.vim

" For CMF Controler Templates
  au! BufNewFile,BufReadPost *.cpt
  au  BufNewFile,BufReadPost *.cpt                          so ~/.vim/syntax/xml.vim

" For ZCML
  au! BufNewFile,BufReadPost *.zcml
  au  BufNewFile,BufReadPost *.zcml                          so $VIMRUNTIME/syntax/xml.vim

" 'n Bietjie kleur vir die rekenaartermelys in sy verskillende vorme.
" 
  if has ("unix")
    au! BufNewFile,BufReadPost *.db*,*.hdb
    au  BufNewFile,BufReadPost *.db*,*.hdb                   so ~/.vim/syntax/termelys.vim
  else
    au! BufNewFile,BufReadPost *.db*,*.hdb
    au  BufNewFile,BufReadPost *.db*,*.hdb                   so ~/.vim/syntax/termelys.vim
  endif

" Modify Lisp-file recognition to include emacs files.
"
  au! BufNewFile,BufRead *.el,.emacs
  au  BufNewFile,BufRead *.el,.emacs                         so $VIMRUNTIME/syntax/lisp.vim

" Add mapping to fix whitespace in Python code
"
" au! BufNewFile,BufRead *.py
" au  BufNewFile,BufRead *.py                                so ~/.vim/syntax/python.vim
augroup END 
