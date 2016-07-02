#!/bin/zsh

v=v2
dir=${0:a:h}
lhome=${dir:h}
scpt=$lhome/scpt
txt=$lhome/json
acce=$txt/access.json
ref=$txt/refresh.json
url=https://accounts.google.com/o/oauth2/token 

if [ -e $acce ]; then

access=`cat $acce | jq -r .access_token`
f=`ls $txt/*.json | grep client_secret|head -n 1`
tmp=`cat $acce`
id=`cat $f | jq -r .web.client_id`
sec=`cat $f | jq -r .web.client_secret`

if ! $scpt/token_time.sh|grep '[0-9]'; then
    if cat $ref | grep ".refresh_token";then
    	code=`cat $ref | jq -r .refresh_token`
    else
	if cat $acce | grep ".refresh_token";then
		echo $acce
    		code=`cat $acce | jq -r .refresh_token`
		cp -rf $acce $ref
    	else
    	        exit
    	fi
    fi

    curl -d client_id=$id -d client_secret=$sec -d refresh_token=$code -d grant_type=refresh_token $url >! ${acce}.back

    if ! cat ${acce}.back | grep "error";then
	    mv ${acce}.back ${acce}
    else
	    echo "error"
	    exit
    fi
    access=`cat $acce | jq -r .access_token`
    echo $access
    curl -s "https://www.googleapis.com/oauth2/$v/tokeninfo?access_token=$access"
    echo time:`$scpt/token_time.sh`
else
	echo time:`$scpt/token_time.sh`
fi

else
    echo no...json
fi

exit 0
