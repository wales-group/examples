# Example 1 - Introducing GMIN

**GMIN** aims to efficiently locate the global minimum of a system by employing the basin-hopping methodology. 
Here we use it to find the two lowest energy minima for a cluster of 38 Lennard-Jones particles, known as LJ38.

## Contents
This directory (and the backup you can find in the *./input* subdirectory) contains all the files you need to run **GMIN** for LJ38:

### GMIN input files

- *data* -		Some input files are optional, but every **GMIN** job requires a *data* file containing the keywords used to specify 
			how the run should proceed 
		
- *data_annotated* -	The keywords we are using in this example are detailed in *data_annotated*. While this file is not required to run **GMIN**, it is
			provided for reference. For information on the full set of keywords available, check the [GMIN website](http://www-wales.ch.cam.ac.uk/GMIN)

- *coords* - 		The (x,y,z) starting coordinates for the LJ atoms in our system, one line per atom

### Utility files

- *plot_progress.plt* -	A **gnuplot** input file that we will use to check how the various energy measure changed during the basin-hopping run

- *view_best.tcl* -	TCL script that can be used as input for **VMD** to visualise the lowest energy minimum found

- *LJcolour.tcl - 	TCL script used by *view_best.tcl* to colour the LJ atoms according to their pair energies, revealing any symmetry
