#!/bin/zsh

BROWSER=firefox
t=${0:a:t}
t=${t%%.*}
v=v2
ta=`echo $t|cut -d _ -f 1`
tb=`echo $t|cut -d _ -f 2`

scope_url_a=https://www.googleapis.com/auth/${ta}
scope_url_b=https://www.googleapis.com/auth/${ta}.readonly
scope_all="&scope=${scope_url_a}%20${scope_url_b}"
access_type=offline
approval_prompt=force
#scope_email=https://www.googleapis.com/auth/userinfo.email
#scope_profile=https://www.googleapis.com/auth/userinfo.profile
#scope_admin=https://www.googleapis.com/auth/admin.directory.user

dir=${0:a:h}
lhome=${dir:h}
scpt=$lhome/scpt
txt=$lhome/json
mkdir -p $txt
acce=$txt/access.json

if [ `cat $acce | jq -r .access_token` != null ] ; then

    $scpt/token_refresh.sh

else

$scpt/download_json.sh

    if ls $txt/*.json | grep client_secret > /dev/null 2>&1; then
	f=`ls $txt/*.json | grep client_secret|head -n 1`
        id=`cat $f | jq -r .web.client_id`
        sec=`cat $f | jq -r .web.client_secret`
        url=`cat $f | jq -r .web.redirect_uris`
	browser_access_url="https://accounts.google.com/o/oauth2/auth?client_id=$id&redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback${scope_all}&response_type=code&access_type=${access_type}&approval_prompt=${approval_prompt}"
	echo $browser_access_url
	case $OSTYPE in
		darwin*)
        		open -a Google\ Chrome $browser_access_url
		        $scpt/chrome_reload.sh && $scpt/iterm_activate.sh
		        echo enter
		        read key
		        url=`$scpt/chrome_url.sh`
			;;
		linux*)
			2>/dev/null 1>&2 $BROWSER "$browser_access_url" &
		        echo enter
		        read key
			#url=`xclip -o -sel clipboard`
			#http://localhost/oauth2callback
			#previous.js
			url=`cat ~/.mozilla/firefox/*.default/sessionstore-backups/previous.js | jq -r '.windows|.[].tabs|.[].entries|.[].url'|tail -n 1`
			;;
	esac

        code=`echo "$url" |tail -n 1| cut -d '=' -f 2`

        curl -d client_id=$id -d client_secret=$sec -d redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback -d grant_type=authorization_code -d code=$code https://accounts.google.com/o/oauth2/token >! $acce

        cat $acce

        access=`cat $acce | jq -r .access_token`

	token_url="https://www.googleapis.com/oauth2/$v/tokeninfo?access_token=$access"
        curl -s $token_url
	echo $token_url

    else

        echo no...json

    fi

fi

exit 0
