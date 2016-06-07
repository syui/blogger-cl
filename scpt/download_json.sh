#!/bin/zsh

dir=${0:a:h}
lhome=${dir:h}
scpt=$lhome/scpt
txt=$lhome/json

if ! ls $txt/*.json|grep client_secret > /dev/null 2>&1;then

open -a Google\ Chrome https://console.developers.google.com/apis/credentials
#open -a Google\ Chrome https://console.developers.google.com/project

$scpt/iterm_activate.sh
echo "okey...download?"
echo "[y]yes, [n]no: "
read key

	if ls ~/Downloads/*.json|grep client_secret > /dev/null 2>&1;then
	    f=`ls ~/Downloads/*.json|grep client_secret|head -n 1`
	    case $key in
	        y[yY]es)
	            cp $f $txt/
		    echo "$txt/$f"
	            ;;
	        n[nN]o)
	            echo no...download
	            ;;
	        *)
	            cp $f $txt/
		    echo "$txt/$f"
	            ;;
	    esac
	fi
fi

exit
