Blogger Post CLI.

## Blogger API

[Google Consle](https://console.developers.google.com)

- Blogger API v3 `set : on`

- OAuth 2.0 client IDs `download : json`

## OAuth 2.0

[ref](https://developers.google.com/blogger/docs/3.0/reference/)

```bash
# mac
$ ./scpt/blogger_access.sh

# linux
$ export f=`ls ~/Downloads/*.json | grep client_secret`
$ export id=`cat $f | jq -r .web.client_id`
$ export sec=`cat $f | jq -r .web.client_secret`
$ export url=`cat $f | jq -r .web.redirect_uris`
$ export scope_url_a=https://www.googleapis.com/auth/blogger
$ export scope_url_b=https://www.googleapis.com/auth/blogger.readonly
$ export url="https://accounts.google.com/o/oauth2/auth?client_id=$id&redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback&scope=${scope_url_a}%20${scope_url_b}&response_type=code&access_type=offline&approval_prompt=force"
$ firefox $url
# copy url
$ export code=`echo PASTE!! | cut -d '=' -f 2`
# get access token
$ export access=`curl -d client_id=$id -d client_secret=$sec -d redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback -d grant_type=authorization_code -d code=$code https://accounts.google.com/o/oauth2/token | jq -r .access_token`
# test
$ curl -s "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$access"
```

## Post

new post.

```bash
$ ./blogger-cl
```

## Update

old post edit.

```bash
$ ./blogger-cl -u
```

## Blogger Edit

HTML Only.

Todo : Markdown -> HTML

```html
# read more
<!--more-->
```

## Sample 

```
# option
access_type=online
approval_prompt=auto

# min
# https://developers.google.com/blogger/docs/3.0/performance#partial-response
url="https://www.googleapis.com/blogger/v3/blogs/${id}/posts/${pid}?key=${access}&fields=kind,items(title,content)"

# update
# https://developers.google.com/gdata/articles/using_cURL#using-clientlogin
curl -sL -H "Authorization: Bearer ${access}" -H "Content-type: application/json" -X PUT -d "`cat $f|tr -d '\n'`" $url
```

