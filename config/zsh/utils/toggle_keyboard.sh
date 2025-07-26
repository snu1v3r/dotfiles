#!/usr/bin/zsh
test_keyboard=`setxkbmap -print | grep dvorak` ; if [[ $test_keyboard ]]; then setxkbmap us; else setxkbmap dvorak; fi
