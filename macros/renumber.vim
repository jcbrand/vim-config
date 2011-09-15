"///////////////////////////////////////////////////////////////////////////////
"//         Source : renumbering.viw
"//       Describe : set of functions to renumbering in a visual area (lines)
"//         Author : Peter Figura peterf@aurus.sk
"//        Created : April 2000
"//  Last Modified : 17.08.2000 PF
"//          Usage : select visual area vith V and then press <C-A>
"//                  examples are on the bottom of this file
"///////////////////////////////////////////////////////////////////////////////


"Right returns the rightmost characters of a string up to a specified length
function! Right(string, length)
    if a:length < 1
        return ""
    endif
    if a:length > strlen(a:string)
        return a:string
    endif
    return matchstr(a:string,'.\{' . a:length . '}$')
endfunction

function! Renumbering(line_start,line_end,prefix,postfix,s_flags)
    let i = a:line_start
    let patt = '\(' . a:prefix . '\)'. '\d\+' . '\(' . a:postfix .'\)'
    let string = getline(i)
    let number = matchstr(string, patt)
    let number = matchstr(number, '\d\+')
    "echo number
    let i = i + 1
    while i <= a:line_end
        let string = getline(i)
        if match(string, patt) != -1
            let number = number + 1
            let repl = '\1' . number . '\2'
            let string = substitute(string, patt, repl, a:s_flags)
            call setline(i, string)
        endif
        let i = i + 1
    endwhile
endfunction

function! Renumbering_x() range
    call Renumbering(a:firstline,a:lastline,'\<','\>','')
endfunction

function! Renumbering_wordx() range
    call Renumbering(a:firstline,a:lastline,'\<\h\+','\>','')
endfunction

function! Renumbering_to_x() range
    call Renumbering(a:firstline,a:lastline,'\<to\s\+','','')
endfunction

function! Renumbering_item_x() range
    call Renumbering(a:firstline,a:lastline,'\<item\s\+','','')
endfunction

function! Renumbering_image() range
    call Renumbering(a:firstline,a:lastline,'\h\+\.\<','\>','g')
endfunction


function! Run_renumbering(line_start,line_end,buttons,choice)
    let butt = a:buttons
    let rval = a:choice
    if rval > 1
        let butt = butt ."\n&"
        let i = 0
        while i <= rval
            let string = matchstr(butt,'^[^&.]*&')
            let butt = strpart(butt, strlen(string), strlen(butt))
            let i = i + 1
        endwhile
        let string = matchstr(string,'\h\+')
        let name = "Renumbering_" . string
        exe "norm! :" . a:line_start .",". a:line_end ."call ". name . "()"
        echo "Your choice: ". name
        return
    endif
endfunction

function! Renumbering_AUTO() range
    let string = getline(a:firstline)
    let image  = 0
    let item   = 0
    let to     = 0
    let x      = 0
    let wordx = 0
    let butt   = ""
    if match(string, '\<\(entry\|on\)_\(name_\)\=item\>') != -1
        let image = 1
        let butt = butt . "\n&image"
    elseif match(string, '\h\+\.\<\d\+\>') != -1
        let image = 1
        let butt = butt . "\n&image"
    endif
    if match(string,'\<item\s\+\d\+') != -1
        let item = 1
        let butt = butt . "\n&item_x"
    endif
    if match(string,'\<to\s\+\d\+') != -1
        let to = 1
        let butt = butt . "\n&to_x"
    endif
    if match(string,'\<\d\+\>') != -1
        if item == 1 || to == 1
        else
            let x = 1
            let butt = butt . "\n&x"
        endif
    endif
    if match(string,'\<\h\+\d\+\>') != -1
        let wordx = 1
        let butt = butt . "\n&wordx"
    endif
    let all = image + item + to + x + wordx
    if all == 1
        let name = "Renumbering_" . Right(butt,strlen(butt) - 2)
        exe "norm! :" . a:firstline .",". a:lastline ."call ". name . "()"
        echo "AUTO: " . name
        return
    elseif all == 0
        let butt = "&No action\n&wordx\n&image\n&x\n&to_x\n&item_x"
        let rval = confirm("Number not found. Choose from:", butt)
        call Run_renumbering(a:firstline,a:lastline,butt,rval)
    else
        let butt = "&No action\n&Show_all" . butt
        let rval = confirm("Choose from:", butt,3)
        if rval == 2
            let butt = "&No action\n&wordx\n&image\n&x\n&to_x\n&item_x"
            let rval = confirm("Choose from all options:", butt)
            call Run_renumbering(a:firstline,a:lastline,butt,rval)
        else
            call Run_renumbering(a:firstline,a:lastline,butt,rval)
        endif
    endif
endfunction

vmap <C-A> :call Renumbering_AUTO()<CR>

"******************************************************************************
"Example: Renumbering_AUTO applies func Renumbering_x
"
"aaa bbb ccc 13 ddd eee
"ggg kkkkk 0 kkkk sdddd
"ggg kkkkk 0 kkkk sdddd
"ggg kkkkk 0 kkkk sdddd
"ggg kkkkk 0 kkkk sdddd
"******************************************************************************


"******************************************************************************
"Example: Renumbering_AUTO applies func Renumbering_wordx
"
"set p_sValue388 to ""
"set p_sValue1 to ""
"set p_sValue1 to ""
"set p_sValue1 to ""
"set p_sValue1 to ""
"set p_sValue1 to ""
"******************************************************************************


"******************************************************************************
"Example: Renumbering_AUTO applies func Renumbering_to_x
"
"set p_jazhod to 2 'i_11rok'
"set p_jazhod to 4 'i_11rok'
"// location of numbers is no object
"            set p_jazhod to 5 'i_11perioda'
"            set p_jazhod to 9 'i_11od
"set p_jazhod to 10 'i_11do' 
"******************************************************************************


"******************************************************************************
"Example: Renumbering_AUTO applies func Renumbering_item_x
"
"set value item 8 to ""
"  set value item 20 to 50
"set value item 21 to "100"
"set value item 22 to "200"
"******************************************************************************


"******************************************************************************
"Example: Renumbering_AUTO applies func Renumbering_image
"   entry_name_item ucmobr_filter_ef.p_noj_od## ucmobr_filter_ef.50 ;
"                  { autoclear,range=0,9999999999 ,;
"                    iprompt=(sycoj_slc(current_object))  }
"   entry_name_item ucmobr_filter_ef.p_noj_do## ucmobr_filter_ef.2 ;
"                  { autoclear,range=0,9999999999 ,;
"                    iprompt=(sycoj_slc(current_object))  }
"   entry_name_item ucmobr_filter_ef.p_aosn_od## ucmobr_filter_ef.3 ;
"                  { autoclear ,;
"                    iprompt=(sykosn_slc(current_object))  }
"   entry_name_item ucmobr_filter_ef.p_aosn_do## ucmobr_filter_ef.4 ;
"                  { autoclear ,;
"                    iprompt=(sykosn_slc(current_object))  }
"   entry_name_item ucmobr_filter_ef.p_amena## ucmobr_filter_ef.5 ;
"                  { autoclear ,;
"                    iprompt=(sycmena_slc(current_object))  }
"   entry_name_item ucmobr_filter_ef.p_nrok_od## ucmobr_filter_ef.6 ;
"                  { autoclear,range=0,9999 ,;
"                    iprompt=(syruzrok_slc(current_object))  }
"******************************************************************************


"///////////////////////////////////////////////////////////////////////////////
"// 17.08.2000 - PF - added function Right from my string library
"// 17.08.2000 - PF - translation of names functions, comments, variables 
"//                   from Slovak to English.
"///////////////////////////////////// EOF /////////////////////////////////////
