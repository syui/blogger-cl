#!/bin/zsh

v=v2
dir=${0:a:h}
lhome=${dir:h}
scpt=$lhome/scpt
txt=$lhome/json
acce=$txt/access.json
url=https://accounts.google.com/o/oauth2/token 

if [ -e $acce ]; then

access=`cat $acce | jq -r .access_token`

if [ "`$scpt/token_time.sh|cut -b 1`" = "n" ]; then
    f=`ls $txt/*.json | grep client_secret|head -n 1`
    tmp=`cat $acce`
    id=`cat $f | jq -r .web.client_id`
    sec=`cat $f | jq -r .web.client_secret`
    code=`cat $acce | jq -r .refresh_token`
    curl -d client_id=$id -d client_secret=$sec -d refresh_token=$code -d grant_type=refresh_token $url >! $acce
    case $OSTYPE in
	    darwin*)
    		sed -i "" 's/}/,/g' $acce
		;;
	    linux*)
    		sed -i 's/}/,/g' $acce
		;;
    esac
    echo "$tmp" | grep refresh_token >> $acce && echo '}' >> $acce
    access=`cat $acce | jq -r .access_token`
    echo $access
    curl -s "https://www.googleapis.com/oauth2/$v/tokeninfo?access_token=$access"
fi

else
    echo no...json
fi

exit 0
