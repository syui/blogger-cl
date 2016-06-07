#!/bin/zsh

oa=blogs
ob=posts
#oc=pages
v=v3

t=${0:a:t}
t=${t%%.*}
ta=`echo $t|cut -d _ -f 1`
tb=`echo $t|cut -d _ -f 2`
dir=${0:a:h}
lhome=${dir:h}
txt=$lhome/json
acce=$txt/access.json

id=`cat $lhome/${ta}.json|jq -r ".${ta}_id"`
u=https://www.googleapis.com/$ta/$v/$oa

#url=$u/${id}/$oc
#f=$txt/${ta}_${oc}.json
#
#if [ -e $acce ]; then
#    access=`cat $acce | jq -r .access_token` > /dev/null 2>&1
#    curl -s -H "Authorization: Bearer $access" $url | jq . >! $f
#    cat $f
#fi

url=$u/${id}/$ob
f=$txt/${ta}_${tb}.json

if [ -e $acce ]; then
    access=`cat $acce | jq -r .access_token` > /dev/null 2>&1
    curl -s -H "Authorization: Bearer $access" $url | jq . >! $f
    cat $f
fi

exit 0
