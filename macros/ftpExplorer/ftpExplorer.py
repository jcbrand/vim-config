#=================================================
# settings that you should customize (ftp server)
#=================================================
host     = 'localhost'
port     =  10021
username = 'sparroy'
password = 'brightred'

#====================================
# required modules
#==================================
import vim,string,sys,tempfile,time
from ftplib import FTP

#====================================
# init global variables
#====================================
ftp         = ''
dir_output  = []
retr_output = []
pwd         = '/'
fi          = ''
lastfile    = ''

#===================================
# function definitions section
#===================================
def showHelp():
    ''' just the help text of ftpExplorer'''
    out       = "| <enter> : open directory or file     |\n"
    out = out + "| ,e : open ftp explorer               |\n"
    out = out + "| *w : save file to ftp                |\n"
    # delete the whole text on vim and print out the help
    vim.command('1,$d')
    vim.command(':let g:help="%s"' %out)
    vim.command(':put=g:help')
    # delete the first line (which is supposed to be empty)
    vim.command('1,1d')
    # place the cursor at the end of line
    vim.command('$')

def showPWD():
    ''' just a text that shows PWD'''
    global pwd
    out       = "|======================================|\n"
    out = out + " %s\n" %pwd
    out = out + "|======================================|\n\n"
    vim.command(':let g:pwdText="%s"' %out)
    vim.command(':put=g:pwdText')
    vim.command('$')

def dir_callback(line):
    '''ftp.dir() callback, stores all results 
    on dir_output (global)'''
    global dir_output,dir_nice
    if line[0:1] == 'd':
        type = 'directory'
        slash = '/'
    else:
        type = 'file'
        slash = ''
    filename = string.split(line)[8]
    dir_output.append(filename+slash,type)
    return 1

def retr_callback(line):
    ''' retr_file callback'''
    global fi
    fi.write(line+'\n')
    

def sortme(a,b):
    ''' this is just the user-defined sort function
    used to sort the dir_output '''
    if cmp(a[1],b[1]) == 0:
        return cmp(a[0],b[0])
    else:
        return cmp(a[1],b[1])

def ftp_connect(host,port,username,password):
    ''' connect and login to the ftp '''
    global ftp
    ftp=FTP()
    try:
        ftp.connect(host,port)
    except:
        vim.command('echo "FTP ERROR: Connection refused"')
        return 0
    try :
        ftp.login(username,password)
    except:
        vim.command('echo "FTP ERROR: Wrong username or password"')
        return 0
    return 1

def ftp_dir(path):
    ''' function that prints out on vim the results
    of an ftp dir'''
    global ftp,dir_output,pwd
    dir_output= []
    try:
        ftp.cwd(path)
    except:
        vim.command('echo "FTP ERROR: %s"' %sys.exc_value)
        return 0
    pwd = ftp.pwd()
    vim.command('let g:pwd="%s"'%pwd)
    ftp.dir(".",dir_callback)
    dir_output.sort(sortme)
    output = ""
    for item in dir_output:
        output = output + item[0] +"\n"
    vim.command(':let g:dirlist="%s"' %output)
    showPWD()
    vim.command(':put=g:dirlist')
    return 1

def ftp_retr(file):
    ''' Retrieves an ftp file, dumps it to a temp file
    and make vim open it'''
    global ftp,pwd,fi

    if pwd == "/":
        filename = pwd+file
    else:
        filename = pwd+'/'+file

    tempfile.template='vimFTPExplorer'
    tn=tempfile.mktemp()
    tn = tn + string.replace(filename,'/','__')
    fi = open(tn,'wb')
    try:
        ftp.retrlines('RETR %s' %file, retr_callback)
        fi.close()
        ftp.quit()
        vim.command('e! %s' %tn)
        # meta_type guessing
        vcmd =        'if (match(getline("1"), "^<params>.*</params>$") == "0")\n'
        vcmd = vcmd + '  set filetype=sql\n'
        vcmd = vcmd + 'elseif (match(getline("1"),"^## Script (Python)") == "0")\n'
        vcmd = vcmd + '  set filetype=python\n'
        vcmd = vcmd + 'else\n'
        vcmd = vcmd + '  set filetype=html\n'
        vim.command(vcmd)
        bufname=vim.current.buffer.name
        vim.command('echo "Current buffer: %s"' %bufname)
    except:
        vim.command('echo "FTP ERROR: %s"' %sys.exc_value)

def ftp_save():
    global ftp,host,username,password,filename
    if ftp_connect(host,port,username,password):
        if pwd == '/':
            filename = pwd+lastfile
        else:
            filename = pwd+'/'+lastfile
        bufname = vim.current.buffer.name
        try:
            fi=open(bufname,'r')
            ftp.storbinary('stor %s' %filename, fi, 8192)
            fi.close()
            ftp.quit()
        except:
            vim.command('echo "FTP ERROR: %s"' %sys.exc_value)
        else:
            vim.command('echo "FTP File saved: %s"' %filename)
    
def doit(path='/'):
    global host,port,username,password
    if ftp_connect(host,port,username,password):
        showHelp()
        ftp_dir(path)

