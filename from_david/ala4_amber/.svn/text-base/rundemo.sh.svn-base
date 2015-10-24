#!/bin/bash

let "seed=$1+$2+$3"
echo Setting up GMIN run for tetraalanine in vacuum
echo Force field is AMBER99SB
sleep 1
echo
echo Random seed is $1 + $2 + $3 = $seed
sleep 1
echo
echo Starting from a high energy local minimum
sleep 1
echo
echo Starting GMIN
sleep 1
echo
echo Starting visualisation 
echo
sleep 3

cp data.template data
echo RANSEED $seed >> data
export VMDTITLE=off

AMBGMIN output &

xterm -e vmd -size 1024 768 -e refresh2.tcl
