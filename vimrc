set runtimepath+=$HOME/.vim/addons/vim-addon-manager
<<<<<<< HEAD
let addons_to_activate = [
                'snipmate', 
                'snipmate-snippets', 
                'jslint', 
                'vcscommand', 
                'TaskList', 
                'python_match', 
                'pythoncomplete', 
                'Flake8-vim']
let addons_to_activate = ['snipmate', 'snipmate-snippets', 'jslint', 'vcscommand', 'TaskList', 'python_match']

call vam#ActivateAddons(addons_to_activate, {
        \ 'auto_install': 1,
        \ 'plugin_root_dir': $HOME.'/.vim/addons',
        \ 'scm_merge_stategy': 'force',
        \ 'known_repos_activation_policy': 'ask',
        \ })
" End VAM

behave xterm
colorscheme desert

let loaded_vimspell=1
let loaded_product=1
let mysyntaxfile = "~/.vim/syntax/mysyntax.vim"

let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

map T :TaskList<CR>
map P :TlistToggle<CR>

" Obvious mappings 
map <PageUp>   <C-B>
map <PageDown> <C-F>
" Browse quickfix hits
nmap <f8> :cp<cr>
nmap <f9> :cn<cr>

"" set digraph                                    " required for those umlauts
set autoindent                                    " as I use VIM for writing code.
set background=dark
set backspace=2                                   " allow backspacing over everything in insert mode
set backup                                        " set autowrite
set backupdir=./.backup,.,/tmp
set comments=b:#,:%,fb:-,n:>,n:),nb:\",n:.-       " default: sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,fb:-  {See 'formatoptions' below.}  {".-" added for editing htmlpp input.}
set complete=.,w,b,u,t,k                          " complete current buffer, windows, buffers, unloaded buffers, tag completion, 'dictionary' files
set define=^\\.\\s*define\\|block\\|macro         " Definitions of terms in htmlpp input. Backslashes doubled since being used in a set command.
set dictionary=~/.vim/dict/english,~/.vim/dict/all-word,~/.vim/dict/allwords "  dictionary: english words first
set directory=.,./.backup,/tmp,c:\temp            " where to create the swap file.
set display=lastline                              " when "lastline": show the last line even if it doesn't fit
set errorbells
set esckeys                                       " allow usage of cursor keys within insert mode
set expandtab                                     " use spaces instead of ^I characters
set fileformat=unix 
set formatoptions=tcroq2l                         " Options for the "text format" command ("gq") I need all those options (but 'o')!  TODO: {Override this in autocommands for .vim (code) files}
set grepformat=%f:%l:%m                           " TODO (default "%f:%l%m,%f  %l%m")
set grepprg=grep\ -n                              " Output: "filename:linenumber:match"
set hidden                                        " Abandon windows without prompting to save them (save them yourself later).
set history=100                                   " Value used for viminfo too. 
set icon                                          " Only works in X
set ignorecase                                    " Ignore the case in search patterns?
set include=^\\.\\s*include                       " For htmlpp input. Backslashes doubled since being used in a set command.
set incsearch
set keymodel=startsel,stopsel                     " Typing replaces selection in Select mode (<S-movement>)
set laststatus=1                                  " show status line? the last window will have a status line only if there are at
set linebreak
set listchars=tab:`\ ,extends:+,trail:~
set matchpairs=(:),{:},[:],<:>                    " I tried to match `:' and ":" but no go
set maxfuncdepth=10000                            " For the Sort function below ..
set mouse=a
set noea                                          " don't automatically make the windows of equal size
set noinsertmode                                  " Start in insert mode?  Naah.
set nojoinspaces                                  " insert two spaces after a period with every joining of lines.  
set nonumber
set nostartofline
set path=.,~/.vim/syntax                          " The list of directories to search when you specify a file with an edit command.
set report=0                                      " Show a report when N lines were changed. report=0 thus means "show all changes"!
set ruler                                         " show cursor position?  Yep!
set scrolljump=5
set scrolloff=5                                   " Keep at least n lines of context above/below cursor
set selectmode=mouse,key
set sessionoptions=options,globals,buffers
set shiftround                                    " Rounds > and < to multiple of shiftwidth.
set shiftwidth=4                                  " Number of spaces to use for each insertion of (auto)indent.
set shortmess=at                                  " Kind of messages to show.   Abbreviate them all!
set showbreak=++\ \ 
set showcmd                                       " Show current uncompleted command?  Absolutely!
set showmatch                                     " Show the matching bracket for the last ')'?
set softtabstop=4
set smartcase                                     " For searches.
set suffixes=.bak,~,.o,.h,.info,.swp,.swo,.swn    " Lower priority when multiple files match a wildcard
set switchbuf=useopen,split                       " Behavior when switching between buffers
set tabstop=4
set tags+=$HOME/.vim/tags/python.ctags
set textwidth=79
set title                                         " Windowtitle. Only on X
set ttybuiltin
set ttyfast                                       " Are we using a fast terminal?
set ttyscroll=1                                   " This will make Vim redraw the screen instead of scrolling, when there are more than 3 lines to be scrolled.
set viminfo=%,'500,\"1000,:100,n~/.viminfo        " What info to store from an editing session in the viminfo file;  can be used at next session.
set whichwrap=b,s,<,>,h,l,[,]
set wildchar=<TAB>                                " wildchar  the char used for "expansion" on the command line default value is "<C-E>" but I prefer the tab key:
set winaltkeys=no                                 " divorce the keyboard from the menus
set writebackup                                   " writebackup:
set wildignore=*.pyc,*.swp

" For some reason this must be last...
set iskeyword=@,48-57,_,192-255,-                 " Add the dash ('-') as "letter" to "words".  iskeyword=@,48-57,_,192-255   (default)

" Setting the "shell" is always tricky - especially when you are
" trying to use the same vimrc on different operatin systems.
if has ("unix")
    set  shell=/bin/sh
else
    " cygwin is in the path
    set  shell=bash.exe 
    set  shellslash          " bash.exe sees backslashes as escapes
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif 

" set cmdheight=1
" set hlsearch showmatch
" set errorformat
" set equalprg
" set formatprg
" set t_vb=  " terminal's visual bell - turned off to make Vim quiet!
" set helpheight=0 " helpheight: zero disables this.
" set lazyredraw " do not update screen while executing macros
" set clipboard=unnamed  " so pasting to windows apps doesn't require prefixing
" set hlsearch showmatch

" " ===================================================================
" " MAPpings and macros
" " ===================================================================

  map ;l mz1/\(updated\\|edited\\|modified\)<cr>/\d<cr>2df i<c-r>=strftime("%c")<cr> <esc>'z

" This file checks the contents of loaded files for syntax info .. 
  let myscriptsfile = "~/.vim/myscripts.vim"

" Activate DTML syntax highlighting for current file with "_dd":
  nn _dd :source ~/.vim/syntax/dtml.vim<cr>

" Change to current dir
  nmap ,cd :cd %:p:h<CR>

  nmap <C-f> :!igor %<CR> <bar> :e!<CR>

" ------------------------------------------------------------------- 

" General Editing
" ===============
" Insert current date
  map ;id O<C-R>=strftime("%c")<cr><Esc>

" { Scroll two windows up and down in parallel. }
  nmap <C-Down> <C-E><C-W>W<C-E><C-W>w
  imap <C-Down> <Esc><C-E><C-W>W<C-E><C-W>wa
  nmap <C-Up> <C-Y><C-W>W<C-Y><C-W>w
  imap <C-Up> <Esc><C-Y><C-W>W<C-Y><C-W>wa

" substitutes runs of two or more space to a single space.
" Why can't this be an option of "text formatting"? *hrmpf*
" {What about end-of-sentence? (dot-space-space)}
  nmap ;ksr :%s/ \+/ /g
  vmap ;ksr  :s/ \+/ /g

python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" ================================================================
" AUTOCOMMANDS AUTOCOMMANDS AUTOCOMMANDS AUTOCOMMANDS AUTOCOMMANDS 
" ================================================================
if has("autocmd")

    " Remove ALL auto-commands.  This avoids having the
    " autocommands twice when the vimrc file is sourced again.
    autocmd!

    " -------------------------------------------------------------------
    " Stefan Roemer: <roemer@informatik.tu-muenchen.de> 
    " { Use <Tab> and <S-Tab> to skip to next/previous tags in helpfile. }
    " Mappings activated when entering a helpfile and de-activated when leaving.
    aug help_jump_macros
    au! BufEnter */vim*/doc/*.txt nn<tab> /\|[^\|]\+\|<cr>l
    au  BufEnter */vim*/doc/*.txt nn<s-tab> h?\|[^\|]\+\|<cr>l
    au  BufEnter */vim*/doc/*.txt nn<cr> <c-]>|nn<space> <c-]>
    au  BufEnter */vim*/doc/*.txt nn<bs> <c-t>
    au! BufLeave */vim*/doc/*.txt nun<tab>|nun<s-tab>|nun<cr>|nun<space>|nun<bs>
    aug END
    " -------------------------------------------------------------------
    " {Always go to last-edited position in a file}
    au BufReadPost * if line("'\"")|execute("normal `\"")|endif
    " -------------------------------------------------------------------

    augroup vpy
        autocmd BufRead,BufNewFile          *.vpy :set ft=python
        autocmd BufReadPre,FileReadPre      *.vpy :set ft=python
    augroup END
    
    augroup xliff
        autocmd BufRead,BufNewFile          *.xliff :set ft=xml
        autocmd BufReadPre,FileReadPre      *.xliff :set ft=xml
    augroup END

    augroup zcml
        autocmd BufRead,BufNewFile          *.zcml :set ft=xml
        autocmd BufReadPre,FileReadPre      *.zcml :set ft=xml
    augroup END

    augroup javascript
        autocmd BufRead,BufNewFile          *.js.dtml :set ft=javascript
        autocmd BufReadPre,FileReadPre      *.js.dtml :set ft=javascript
    augroup END

    augroup css 
        autocmd BufRead,BufNewFile          *.css.dtml :set ft=css
        autocmd BufReadPre,FileReadPre      *.css.dtml :set ft=css
    augroup END

    augroup kss
        autocmd BufRead,BufNewFile          *.kss :set syntax=kss
        autocmd BufReadPre,FileReadPre      *.kss :set syntax=kss
        autocmd BufRead,BufNewFile          *.kss.dtml :set syntax=kss
        autocmd BufReadPre,FileReadPre      *.kss.dtml :set syntax=kss
    augroup END

    augroup po
        autocmd BufRead,BufNewFile          *.po :set syntax=po
        autocmd BufReadPre,FileReadPre      *.po :set syntax=po
    augroup END

    " Omnicomplete
    set ofu=syntaxcomplete#Complete
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    autocmd FileType c set omnifunc=ccomplete#Complete
    " -------------------------------------------------------------------
endif " has("autocmd")

" Enabled file type detection and file-type specific plugins. (PyFlakes)
filetype on
filetype plugin on
syntax on

" Makes JSLint highlighting a bit nicer
hi clear SpellBad
hi SpellBad cterm=bold ctermbg=red ctermfg=black

" To enable the Afrikaans (af) spell checker type:
" :set spell spelllang=af 

