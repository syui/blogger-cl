#!/bin/zsh

cat << EOF | osascript -
tell application "Google Chrome"
   repeat while loading of active tab of window 1
        delay 0.1
   end repeat
   activate
end tell
EOF
