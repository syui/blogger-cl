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
body=$txt/${ta}_${tb}.json
day=`date +"%y%m%d%H%M"`
mday=`date +"%Y/%m/%d"`
tmp="{\"title\":\"\",\n\"content\":\"\",\n\"labels\":[\"origin\"],\n\"customMetaData\":\"$mday\"}"
id=`cat $lhome/${ta}.json|jq -r ".${ta}_id"`

if [ -e $acce ]; then
    access=`cat $acce | jq -r .access_token` > /dev/null 2>&1
    url="https://www.googleapis.com/$ta/$v/$oa/$id/$ob"
    if [ -f $body ];then
	    echo $body
	    cat $body
	    echo "upload[y]"
	    read key
	    case $key in
		    [yY])
    	    		curl -sL -H "Authorization: Bearer $access" -H "Content-type: application/json" -X POST -d "`cat $body`" $url
		;;
	    esac
     else
	    echo "edit:$body $tmp"
	    echo $tmp >! $body
	    $edit $body
	    echo "upload[y]"
	    read key
	    case $key in
		    [yY])
    	    		curl -sL -H "Authorization: Bearer $access" -H "Content-type: application/json" -X POST -d "`cat $body`" $url
			mv $body ${body}_${day}
		    ;;
	    esac
    fi
fi
