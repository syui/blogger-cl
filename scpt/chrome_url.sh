#!/bin/zsh

cat << EOF | osascript -
tell application "Google Chrome" to get URL of active tab of first window
EOF
