# rg.sh -- Recursive grep
# Michael Geddes

# Search directory tree for expressions and save the result
# usage: rg [ options ] <regexp> [ extensions ]

# Should handle long filenames

if [ -z "$binw" ]
then
  binw=c:/usr/binw
fi
# save the current directory so that we can restore it later
#cwd=$(pwd)
if [ -z "$findprog" ]
then
  findprog=$binw/find
fi
if [ -z "$grepprog" ]
then
  grepprog=$binw/grep
fi
if [ -z "$egrepprog" ]
then
  egrepprog=$binw/egrep
fi

rm -f $temp/shtmp.* 2>nul >nul

#opt=""
fname=""
func="x"
for b in "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
do
  if [ -n "$b" ]
  then
    o=$(expr "$b" : "-.*")
    if [ $o -ge 1 ]
    then opt="$opt $b"
    elif [ "$func" = "x" ]
    then func="$b"
    else fname="$fname $b"
    fi
  fi
done

if [ "${func}" = x ]
then
	echo Nothing specified!
	echo Usage:
	echo   $0 [ egrep_options ] function [ extenstions ]
	exit
fi

if [ -z "${fname}" ]
then
	fname="c cpp hpp h rc rh"
else
	echo NAME:$fname
fi

# construct a list of directories below the current directory
# don't bother searching directories that end in /dbg or /rel

rm -f $home/greps 2> /dev/null
touch $home/greps > /dev/null
echo -r GREPTERM: $func > $home/greps

ppwd=$pwd
if [ "$ppwd" == "/" ]
then
	ppwd=""
fi

# for each directory in the list, peform the grep
sedpwd=$(echo $ppwd/|sed 's/\//\\\//g')
for d in . $( $findprog . -type d -L -print | $egrepprog -i -v (^\|/)((dbg)\|(rel)\|(obj))$| sed 's/[ *&?]/\?/g' ) 
do
	echo -n "$d/                                   \r"

# Cludge to force expansion of filenames
	files=""
	for b in $fname
	do
		files="${files} \"$ppwd/$d\"/*.$b"
	done
# Echoing here forces sh to group the quoted files.
	echo $grepprog -n $opt $func nul $files |sh 2> /dev/null | tee -a $home/greps | sed "s/^$sedpwd//"

done
