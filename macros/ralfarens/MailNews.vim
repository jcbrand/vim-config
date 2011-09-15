" File: MailNews.vim
"
" Purpose: faciliate editing mails and postings (correct them before editing)
"
" Author: Ralf Arens
" Last Modified: 2000-03-10 13:13:30 CET


" this funtion parses and corrects mails and news
fu! MailNews()
        "set formatoptions, comments and textwidth
        set fo=tcq com=n:>,n::,n:} tw=70
        " remove leading empty lines
        if ( getline(1) == "" )
                :0;/^./-d
        endif
        " avoid a deadlock which I don't understand
        if ( line("$") != 1 )
                " delete from quoted signature till end ([MN]UA quote has to be `> ')
                g/^> -- $/,$d
                " delete quotes on empty lines
                " (this sequence is ok cause of '...you wrote')
                %s/^>\(>\|\s\)*$//
                " delete trailing empty lines
                while ( getline(line("$")) == "" )
                        $d
                endwhile
                " squeeze empty lines into one
                v/./,//-j
                " remove trailing whitespace and repair quotes
                " mind, text will be harmed if it contains sth like `> >'
                " ¯¯¯¯¯¯¯¯¯¯¯¯¯ obsolete, this was old solution
                let curl = 1
                let last = line("$")
                while ( curl != last+1 )
                        let line = getline(curl)
                        if ( line =~ '^>' )
"                               let line = substitute(line, '> \=', '> ', 'g')
"                               let line = substitute(line, '> ', '>', 'g')
"                               let line = substitute(line, '\(^>\+\)\+', '\1 ', 'g')
                                let i = matchend(line, '^>[     >]*>')
                                let quotes = strpart(line, 0, i)
                                " why strlen+1? (otherwise I lose sometimes a char at the end)
                                " strlen should be more than enough!
                                "               ask mailing list?
                                let text = strpart(line, i, strlen(line)+1)
                                let text = substitute(text, '^\([^ ]\)', ' \1', "")
                                let quotes = substitute(quotes, '> \+', '>','g')
                                let line = quotes . text
                                " strange things are happening, Vim inserts a ` ' if
                                " there's only one `>'
                                "               ask mailing list?
                                let line = substitute(line, '^ ', '', "")
                        endif
                        if ( line !~ '^-- $' )
                                let line = substitute(line, '[ |        ]\+$', '', '')
                        endif
                        call setline(curl, line)
                        let curl = curl +1
                endwhile
        endif
        " append greetings and signature
        call Sig()
        " position cursor on first empty line
        0/^$/
endf


" take care of signature
fu! Sig()
        " assume sig exists not -> sig=0
        let sig = 0
        " assume not posting to dcouln -> dcouln=0
        let dcouln = 0
        " if sig exists -> sig=1
        %g/^-- $/let sig = 1
        " if de.comp.os.unix.linux.newusers -> dcouln=1
        %g/^Newsgroups: de.comp.os.unix.linux.newusers$/let dcouln=1

        if (sig == 0 && dcouln == 0)
                $put =\"\"
                $put =\"\"
                $put =\"Ciao,\"
                $put =\"Ralf\"
                $put =\"\"
                $put =\"-- \"
                r ~/.signature
        elseif (sig == 0 && dcouln == 1)
                $put =\"\"
                $put =\"\"
                $put =\"Ciao,\"
                $put =\"Ralf\"
                $put =\"\"
                $put =\"-- \"
                $put =\"Neuer Linux-User? de.comp.os.unix.linux.infos\"
                $put =\"Neu im Usenet?    de.newusers.infos, de.newusers.questions\"
                $put =\"Fragen zu KDE?    de.alt.comp.kde\"
                $put =\"Fragen zu Gnome?  de.alt.comp.gnome\"
        endif
endf


" a new mail or news doesn´t need to be parsed
fu! NewMailNews()
        "set formatoptions, comments and textwidth
        set fo=tcq com=n:>,n::,n:} tw=70
        " append greetings and signature
        $put =\"\"
        $put =\"\"
        $put =\"Ciao,\"
        $put =\"Ralf\"
        $put =\"\"
        $put =\"-- \"
        r ~/.signature
        " position cursor on first empty line
        0/^$/
endf


" and now the mappings

" Warum können die Leute keine Sigs abtrennen
nmap üsig iTrenne bitte Deine Signatur mit "-- " (minus minus Leerzeichen) ab.
" Und warum können sie die Zeilenlänge nicht richtig einstellen
nmap ülen iStelle bitte Deine Zeilenlänge auf <= 78 Zeichen ein.
" Den Namen bitte
nmap ünam iDein Name bitte, Score adjusted.
" change subject line
"map üns 1G/^Subject: /e<CR>a(was: <Esc>A)<Esc>%i
map üns 1G/^Subject: /<CR>:s,\(Subject: \)\(Re: \)*\(.*\)$,\1(was: \3),<CR>f(i
" put selected text in quotes (zitieren)
"map üz

" vim:noet:ts=8:sw=4:sts=4
