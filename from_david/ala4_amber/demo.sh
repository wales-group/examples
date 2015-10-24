#!/bin/bash

# xterm -bg white -fg black -fn -misc-fixed-medium-r-normal--20-200-75-75-c-100-iso10646-1 -geometry 101x37+0+0

echo $1 $2 $3

gnome-terminal --window --maximize -x rundemo.sh $1 $2 $3

