#!/bin/zsh

dir=${0:a:h}
lhome=${dir:h}
txt=$lhome/json
acce=$txt/access.json

if [ -e $acce ]; then

access=`cat $acce | jq -r .access_token`

curl -s "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$access" | jq .expires_in

else
    echo no...json
fi

exit 0
