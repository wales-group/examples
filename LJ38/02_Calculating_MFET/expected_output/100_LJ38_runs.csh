#!/bin/csh
# script to collect mean first encounter time stats for LJ38 by running 100
# GMIN runs from random initial configurations
#
# Usage: ./100_LJ38_runs.csh withSYM 42

# check for correct number of arguments
set expected_args=2

if ($#argv != $expected_args) then
   echo "ERROR: Missing arguements:"
   echo "./100_LJ38_runs.csh <working directory name> <seed>"
   exit
endif

# specify system size and container (to prevent evaporation) radius
set radius=3.0
set natoms=38

# specify the binary to use
# if GMIN is already in your $PATH
set exec=GMIN
# to specify a specific binary
# set exec=~/workshop/binaries/GMIN

# the first argument specifies the working directory, the second the seed to start at
set directory=$1
set seed=$2

# create the working directory and copy over the input data file
mkdir $directory
cd $directory
cp ../data data
# remove any old output and supress the output
rm hits >& /dev/null

# initialise the counter variable
set count=1

echo
echo "Running GMIN for 38 LJ atoms from 100 random starting geometries"
echo "Random number seeds start from $2"
echo

# loop to start 100 GMIN jobs 
while ($count <= 100)
   # use rancoords to generate initial coordinates
   echo $natoms $radius -$seed > randata
   rancoords # >& /dev/null
   cp newcoords coords
   # start GMIN
   echo "Starting run $count"
   $exec output >& extra_out.$count
   # extract the number of quenches, number of potential calls and time taken from the output 
   echo `grep hit output | head -1 | sed -e 's/[a-zA-Z]//g' -e 's/[a-zA-Z]//g' -e 's/\.//' -e 's/>//'` \
        `grep time= output | tail -1 | sed 's/.*time=//'` >> hits
   # back up initial coordinates and output
   mv coords coords.$count
   mv output $directory.output.$natoms.$count
   # increment counter variable and seed
   @ count +=1
   @ seed +=1 
end

# construct a smooth distribution for the time taken (t), number of quenches (Q) and number 
# of potential calls (V) and return the mean and standard deviation for each
gminconv2 < hits > temp ; head -1 temp > pdf
rm temp
# print the results
echo
echo "Mean and standard deviation for global minimum first encounter time:"
echo
cat pdf
