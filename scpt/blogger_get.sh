#!/bin/zsh

oa=blogs
ob=byurl

t=${0:a:t}
t=${t%%.*}
v=v3
ta=`echo $t|cut -d '_' -f 1`
tb=`echo $t|cut -d '_' -f 2`
dir=${0:a:h}
lhome=${dir:h}
txt=$lhome/json
acce=$txt/access.json

id=`cat $lhome/${ta}.json|jq -r ".${ta}_id"`
id=https://www.googleapis.com/$ta/$v/$oa/$id

url=`cat $lhome/${ta}.json|jq -r ".${ta}_url"`
url="https://www.googleapis.com/$ta/$v/$oa/${ob}?url=$url"

if [ -e $acce ]; then
    access=`cat $acce | jq -r .access_token` > /dev/null 2>&1
    curl -s -H "Authorization: Bearer $access" $id | jq . >! $txt/${ta}_${id}.json
    cat $txt/${ta}_${id}.json
    curl -s -H "Authorization: Bearer $access" $url | jq . >! $txt/${ta}_${ob}.json
    cat $txt/${ta}_${ob}.json
fi

exit 0
