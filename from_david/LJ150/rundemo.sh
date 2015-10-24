#!/bin/bash

let "seed=$1+$2+$3"
echo Setting up GMIN run for 150 Lennard-Jones atoms
sleep 1
echo
echo Random seed is $1 + $2 + $3 = $seed
sleep 1
echo
echo 150 random coordinates generated 
echo in a sphere radius 4.0
sleep 1
echo
echo Starting GMIN
sleep 1
echo
echo Starting visualisation 
echo
sleep 3

echo 150 4.0 $seed > randata
rancoords # >& /dev/null
cp newcoords coords
GMIN output &
export VMDTITLE=off

xterm -e vmd -size 1024 768 -e refresh2.tcl
