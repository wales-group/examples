# Example 4 - Creating PATHSAMPLE database 

Once we have found an intial discrete pathway between minima (endpoints) of interest using **OPTIM**, we can create a **PATHSAMPLE** stationary point database
and grow it using built in methods designed to create a kinetically relevent sample for further analysis.   

In this example, we will take the *path.info* file from Example 3 (here renamed as *path.info.initial*) and create a **PATHSAMPLE** database. We will then check
that the initial pathway is still present and create a disconnectivity graph to view the landscape it explores using **disconnectionDPS**.

## Requirements
In order to successfully follow this example, the following need to be in your *PATH*:

- a **PATHSAMPLE** binary
- a **disconnectionDPS** binary

## Directory contents
Both this directory and the backup in *./input* contain all the files you need to run **PATHSAMPLE** to create a database. The *./expected_output* subdirectory 
contains output after all of the below steps have been followed. Your intermediate results may differ as a result.

As **PATHSAMPLE** acts as a driver for **OPTIM** (i.e. it starts **OPTIM** jobs), there are also **OPTIM** input files present. In this example we will not actually
be using them as we are simply setting up the database, but they are included as in a normal use case, they would be present.

### PATHSAMPLE input files

- *pathdata* -			Every **PATHSAMPLE** job requires a *pathdata* file containing the keywords used to specify what we would like the run to achieve.
				This example will require us to run it twice with different keywords, hence there are two sections at the bottom of
				*pathdata*, one initially commented out (starting with '! ')

- *pathdata_annotated* -	The **PATHSAMPLE** keywords we are using in this example are detailed in *pathdata_annotated*. This file is not required, it is
				provided for reference only. For information on the full set of **PATHSAMPLE** keywords available, check the
				[PATHSAMPLE website](http://www-wales.ch.cam.ac.uk/PATHSAMPLE)

- *path.info.initial* -		The **OPTIM** output file from Example 3 that contains the energy, coordinates and vibration frequencies of the minims and transition
				states found when making the initial connected pathway. We will be reading this file in to create the **PATHSAMPLE** database

### OPTIM input files

- *odata.connect* -		Contains the **OPTIM** keywords used for jobs started by **PATHSAMPLE**. Although we will not be using it in this example, it is
				included for completeness. It should be noted that the major difference between this file and an *odata* file used in a standalone
				**OPTIM** job is the lack of starting coordinates following the ``POINTS`` keyword. This is because *odata.connect* acts as the
				template from which **PATHSAMPLE** can build *odata.JOBID* files for the runs it starts, adding the coordinates as appropriate

		
- *odata.connect_annotated* -	The **OPTIM** keywords present in *odata.connect* are detailed in *odata.connect_annotated*. This is only present for reference and
				is not used in the current example as explained above. For information on the full set of keywords available, check the 
				[OPTIM website](http://www-wales.ch.cam.ac.uk/OPTIM)

### Utility files

- *plot_Epath.plt* - 		**gnuplot** input file to plot the energy of the stationary points along the fastest path

- *optim.out.initial* -		The **OPTIM** output from Example 3 where *path.info.initial* was created. Used to identify the endpoints by their energy below

## Step-by-step

Before you start, take a minute to look through *pathdata_annotated* and make sure you understand roughly the purpose of each keyword.  

### Creating the stationary point database

We are first going to create the initial stationary point database by reading in the *path.info,initial* file from **OPTIM** using the `STARTFROMPATH` keyword. Your
*pathdata* file should look like this, with the keywords for 'STEP 1' uncommented:

```
! PATHSAMPLE input to create an initial database from OPTIM path.info for LJ38
! For further details, see the PATHSAMPLE documentation

EXEC           /home/energy/workshop/binaries/OPTIM
CPUS           1
SYSTEM         AX
NATOMS         38
SEED           1
DIRECTION      AB
CONNECTIONS    1
TEMPERATURE    0.1

PERMDIST 
RANROT         5
ETOL           1.0D-6
GEOMDIFFTOL    0.2
ITOL           0.1D0

! STEP 1: creating the initial database from OPTIM path.info file
STARTFROMPATH  path.info.initial 1 2
CYCLES         0

! STEP 2: run a Dijkstra analysis to identify the 'fastest path' (initially commented) 
! DIJKSTRA       0
! CYCLES         0

```

Note that if we were planning on expanding the database, we would need to alter the path after `EXEC` to point to your **OPTIM** binary. As we are not, it can be set
to anything for now.

Assuming you have it somewhere in your *PATH*, we can create the database by running *PATHSAMPLE*:

```
PATHSAMPLE > pathsample_startfrompath.out
```

This will finish almost immediately as we are only adding a few stationary points. If you take a look at the bottom of the output file, you should see that the
minima and transition states from *path.info.initial* have been read into the database. You can print the output using `cat pathsample_startfrompath.out`:

```
path.info files will be read as min-sad-min triples
*************************************************************************************************
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
tsdouble> Maximum number of ts increased to       20
getallpaths> writing data for new ts to ts.data
```

#### Locating the endpoints in min.data and setting up min.A and min.B


#### Checking the connected path is still present with a Dijkstra analysis


#### Visualising the fastest path using gnuplot


#### Create a disconnectivity graph, labelling the endpoints


## Extension: identifying other minima of interest on the disconnectivity graph

