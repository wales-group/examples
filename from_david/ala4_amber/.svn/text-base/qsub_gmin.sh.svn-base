#!/bin/bash

#PBS -j oe

cd $PBS_O_WORKDIR
wc $PBS_NODEFILE > nodes.info
cat $PBS_NODEFILE >> nodes.info
echo $USER >> nodes.info
# /home/ss2029/bin/AMBGMIN > gmin.log 

echo Started on 
date

echo rm GMIN.dump GMIN.dump.save GMIN_out  best  energy markov lowest.xyz
rm GMIN.dump GMIN.dump.save GMIN_out  best  energy markov lowest.xyz

/home/ss2029/svn/GMIN/bin/AMBGMIN.serial 

echo Finished on 
date 

