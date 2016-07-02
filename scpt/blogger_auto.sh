#!/bin/zsh
home_dir=${0:a:h:h}
md=$home_dir/md/intro.md
html=$home_dir/html/intro.html
oa=blogs
ob=posts
v=v3

# middleman https://syui.github.io/middleman
mdir=~/.zsh/plugin/m.zsh/middleman
cd $mdir
git pull

mtitle=`date +"%Y-%m-%d" -d "-1 year"`
mbody=`cat ${mdir}/${mtitle}*`
mtitle=`echo "$mbody"|grep 'title:'|cut -d ':' -f 2|tr -d ' '`
mbody=`echo "$mbody"|sed '1,5d'`

if echo "$mbody"|grep '~~~';then
	mbody=`echo "$mbody"|sed -e 's/~~~bash/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~css/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~html/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~js/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~json/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~lua/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~md/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~ruby/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~shell/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~yml/<pre class=\\"brush: bash;\\">/g'`
	mbody=`echo "$mbody"|sed -e 's/~~~/<\/pre>/g'`
fi

# gulp
echo "$mbody" >! $md
cd $home_dir
gulp

# json
mday=`date +"%Y/%m/%d"`
mbody=`cat $html`
if echo "$mbody"|grep '"';then
	mbody=`echo "$mbody"|sed 's/"/\\\"/g'`
fi
mtop=`echo "$mbody"|head -n 1`
mtop=`echo "$mtop"|sed -e 's/<p>//g' -e 's/<\/p>/<br \/>/g'`
mbody=`echo "$mbody"|sed '1d'`
mbody=`echo "${mtop}${mbody}"`
echo "$mbody" >! $html
echo "<br />" >> $html
mbody=`cat $html|sed -e 's/\n/<br \/>/g'|tr -d '\n'`
echo "$mbody"

#mbody=`echo "$mbody"|tr '\n' '^'|sed -e 's/\^/<br />/g'`
#mbody=`echo "$mbody"|sed -e 's/<p>//g' -e 's/<\\p>//g'`

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
id=`cat $lhome/${ta}.json|jq -r ".${ta}_id"`
#tmp="{\"title\":\"$mtitle\",\"content\":\"$mbody\"}"
tmp="{\"title\":\"$mtitle\",\"labels\":[\"auto\"],\"customMetaData\":\"$mday\",\"content\":\"$mbody\"}"
echo "$tmp" >! $body

if [ -e $acce ]; then
    access=`cat $acce | jq -r .access_token` > /dev/null 2>&1
    url="https://www.googleapis.com/$ta/$v/$oa/$id/$ob"
    if [ -f $body ];then
	    echo $body
	    cat $body
    	    curl -sL -H "Authorization: Bearer $access" -H "Content-type: application/json" -X POST -d "`cat $body`" $url
    fi
fi
