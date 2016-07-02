#!/bin/zsh

edit=vim
oa=blogs
ob=posts
v=v3

t=${0:a:t}
t=${t%%.*}
ta=`echo $t|cut -d _ -f 1`
tb=`echo $t|cut -d _ -f 2`
dir=${0:a:h}
lhome=${dir:h}
txt=$lhome/json
acce=$txt/access.json
scpt=$lhome/scpt

$scpt/${ta}_list.sh

id=`cat $lhome/${ta}.json|jq -r ".${ta}_id"`
title=`cat $txt/${ta}_list.json| jq -r '.items|.[]|.title'`
cid=`cat $txt/${ta}_list.json| jq -r '.items|.[]|.id'`
cid=`cat $txt/${ta}_list.json| jq -r '.items|.[]|.id'`
cdate=`cat $txt/${ta}_list.json| jq -r '.items|.[]|.updated'|cut -d 'T' -f 1|tr '-' '/'`

pid=$(
for ((i=1;i<=`echo "$title"|wc -l`;i++ ))
do
	t=`echo "$title"|awk "NR==$i"`
	c=`echo "$cid"|awk "NR==$i"`
	echo $t,$c
done | peco | cut -d , -f 2
)
echo $id
echo $pid

if [ -e $acce ]; then
     access=`cat $acce | jq -r .access_token` > /dev/null 2>&1
     f=$txt/${ta}_${pid}.json
     url=https://www.googleapis.com/${ta}/$v/$oa/$id/$ob/$pid
     tmp=`curl -s -H "Authorization: Bearer $access" $url`
     echo "$tmp" >! $f
     tmp="{\"title\":`echo $tmp|jq '.title'`,\n\"content\":`echo $tmp|jq '.content'`,\n\"customMetaData\":`echo $tmp|jq '.updated'|cut -d 'T' -f 1|tr '-' '/'`\",\n\"labels\":[\"\"]}"
	echo -e "$tmp" >! $f
     $edit $f

     if cat $f|jq . ;then
     	echo "upload[y] -> $f"
     	read key
     	case $key in
     	        [yY])
     			curl -sL -H "Authorization: Bearer ${access}" -H "Content-type: application/json" -X PUT -d "`cat $f|tr -d '\n'`" $url
     	        ;;
     	esac
     else
	echo "json error -> $f"
     fi
fi

exit 0

