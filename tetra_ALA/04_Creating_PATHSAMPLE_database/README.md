# Example 4 - Creating PATHSAMPLE database 

Once we have found an intial discrete pathway between minima (endpoints) of interest using **OPTIM**, we can create a **PATHSAMPLE** stationary point database
and grow it using built-in methods designed to create a kinetically relevent sample for further analysis.   

In this example, we will take the *path.info* file from [Example 3](../03_Connecting_minima_with_OPTIM) (here renamed as *path.info.initial*) and create a 
**PATHSAMPLE** database. We will then check that the initial pathway is still present and create a disconnectivity graph to view the landscape it explores 
using **disconnectionDPS**.

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

- *path.info.initial* -		The **OPTIM** output file from [Example 3](../03_Connecting_minima_with_OPTIM) that contains the energy, coordinates and Hessian 
				eigenvalues of the minima and transition states found when making the initial connected pathway. We will be reading this file in to 
				create the **PATHSAMPLE** database

### OPTIM input files

- *odata.connect* -		Contains the **OPTIM** keywords used for jobs started by **PATHSAMPLE**. Although we will not be using it in this example, it is
				included for completeness. 

		
- *odata.connect_annotated* -	The **OPTIM** keywords present in *odata.connect* are detailed in *odata.connect_annotated*. This is only present for reference and
				is not used in the current example as explained above. For information on the full set of keywords available, check the 
				[OPTIM website](http://www-wales.ch.cam.ac.uk/OPTIM)

- *coords.prmtop* -	The symmetrised (see the note below!) **AMBER** topology file for tetra-ALA using parameters from the **AMBER** ff99SB force field

- *coords.inpcrd* -  	Coordinates for the tetra-ALA atoms in our system in **AMBER** restart format. These are only used to allocate arrays during setup and the coordinates
			themselves are overwritten with those in *start.X* by **PATHSAMPLE** automatically as it starts **A9OPTIM** jobs in the next example

- *start* -		The placeholder (x,y,z) tetra-ALA coordinates - in this case the higher energy of the two tetra-ALA minima. These are not used in the current example
			but are included for completeness

- *min.in* -		The **AMBER** force field parameters to use to calculate the energy and gradient. 

- *min.in_annotated* -	Not used during the run. Contains additional information about the **AMBER** parameters used in this exammple. See the **AMBER** manual for more information

- *perm.allow* - 	Specifies which atoms in tetra-ALA should be considered identical with respect to permutational isomerisation. This ensures that we do not consider two minima
			that differ by a rotation of a methyl group to be different. It is possible to generate these files automatically from a PDB using the Python script here:

```
SCRIPTS/make_perm.allow/perm-pdb.py file.pdb AMBER 
```

This script does not treat capping groups such as ACE and NME which will need to be added manually.

- *perm.allow_annotated* - Contains details of how the *perm.allow* groups are constructed. For more information, see the [OPTIM website](http://www-wales.ch.cam.ac.uk/OPTIM)   


**IMPORTANT NOTE:** the **AMBER** and **CHARMM** force fields are not symmetrised with respect to permutational isomerisation! This is particularly troublesome for methods 
like these which rely partially on the energy to discriminate between minima. Without proper symmetrisation, permutational isomers (e.g. rotated methyl groups) can have different 
energies, resulting in 'twinning' of minima. 

For **AMBER** we resolve this by symmetrising the problem improper dihedral angles in the topology file after creating it using a Python script. You can find the script in the 
source code here:

```
SCRIPTS/AMBER/symmetrise_prmtop/perm-prmtop.ff03.py
```

Despite being labelled `ff03` - this script is also works for the ff99SB force field. For more details, see the script and the paper discussing this issue
[here](http://onlinelibrary.wiley.com/doi/10.1002/jcc.21425/abstract).

In this example, we have symmetrised the topology files for you. If you are ever unsure about your input, exchange the coordinates of what should be two identical atoms and
check that the energy does not change.

### disconnectionDPS input files

- *dinfo* -			Contains the keywords that control the appearence of the disconnectivty graph produced when **disconnectionDPS** is run in the
				current directory

- *dinfo_annotated* -		The **disconnectionDPS** keywords used in this example are detailed in *dinfo_annotated*. For more information and a full
				keyword listing, see the top of the *disconnectionDPS.f90* source file, available in the source tar file on the
				[Wales Group website](http://www-wales.ch.cam.ac.uk)

### Utility files

- *plot_Epath.plt* - 		**gnuplot** input file to plot the energy of the stationary points along the fastest path

- *optim.out.initial* -		The **OPTIM** output from [Example 3](../03_Connecting_minima_with_OPTIM) where *path.info.initial* was created. Used below to identify 
				the endpoints by their energy

## Step-by-step

Before you start, take a minute to look through *pathdata_annotated* and make sure you understand roughly the purpose of each keyword.  

**WARNING:** when using **PATHSAMPLE** with `PERMDIST`, it is really important that you include it in both your *odata.connect* and *pathdata* files and that the values of 
`ETOL`/`EDIFFTOL`, `GEOMDIFFTOL` and `RANROT` are consistent between them. This also applies to the **OPTIM** *odata* files that were used to make the initial path in 
[Example 3](../03_Connecting_minima_with_OPTIM).

### Creating the stationary point database

We are first going to create the initial stationary point database by reading in the *path.info,initial* file from **A9OPTIM** using the `STARTFROMPATH` keyword. Your
*pathdata* file should look like this, with the keywords for 'STEP 1' uncommented:

```
! PATHSAMPLE input to create an initial database from A9OPTIM path.info for tetra-ALA (ALA-ALA-ALA-ALA)
! For further details, see pathdata_annotated and the PATHSAMPLE documentation

EXEC           /home/energy/workshop/binaries/A9OPTIM
CPUS           1
NATOMS         52
SEED           1
DIRECTION      AB
CONNECTIONS    1
TEMPERATURE    0.592
PLANCK         9.536D-14

PERMDIST 
ETOL           1.0D-5
GEOMDIFFTOL    0.1D0
ITOL           0.1D0

! STEP 1: creating the initial database from A9OPTIM path.info file
STARTFROMPATH  path.info.initial 1 2
CYCLES         0

! STEP 2: run a Dijkstra analysis to identify the 'fastest path' (initially commented) 
! DIJKSTRA       0
! CYCLES         0

AMBER9
```

Note that if we were planning on expanding the database, we would need to alter the path after `EXEC` to point to your **A9OPTIM** binary. As we are not, it can be set
to anything for now.

Assuming you have it somewhere in your *PATH*, we can create the database by running *PATHSAMPLE*:

```
PATHSAMPLE > pathsample_startfrompath.out
```

This will finish almost immediately as we are only adding a few stationary points. If you take a look at the bottom of the output file, you should see that the
minima and transition states from *path.info.initial* have been read into the database. You can print the output using `cat pathsample_startfrompath.out`:

```
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      2 new minima to min.data
getallpaths> writing data for new ts to ts.data
tsdouble> Maximum number of ts increased to       20
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for      1 new minima to min.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
getallpaths> writing data for new ts to ts.data
```

The **PATHSAMPLE** database we have created here resides in four key files:

- *min.data* - 	contains the energy, logarithm of the product of positive Hessian eigenvalues, symmetry and moments of inertia for each minimum:
```
      -35.350347228396458     9790.913915977564102     1      293.6823691158      860.7846898767     1024.4566946858
      -41.058341717437770     9792.881833598055891     1      324.7291569216      655.0519707341      671.7053052785
      -41.722992401385000     9796.924653787169518     1      399.2855477052      500.2110330140      532.1986393602
...
```
We can refer to minima by a number, e.g. minimum 2 corresponds to line 2 of *min.data*.

- *ts.data* -	contains the energy, logarithm of the product of positive Hessian eigenvalues, symmetry, minima numbers that it connects and moments of inertia for each
		transition state:
```
      -34.588539720675726     9729.762985518258574         1         1         1      294.9379548940      862.5627405652     1026.2729301279
      -40.768480627843360     9730.513517685552870         1         2         3      365.1519908484      571.0496282252      597.9409456527
      -29.315644184662858     9732.995322984439554         1         4         5      434.9411456952      631.9888656187      875.1112365707
...
```
As for minima in *min.data*, transition states are identified by their line number in *ts.data*. This means that we can check how many minima and transition states
we have in our database using `wc -l min.data ts.data`:
```
  12 min.data
  18 ts.data
  30 total
```

- *points.min* -	contains the coordinates for each minimum in a binary format to keep the file size low

- *points.ts* -		contains the coordinates for each transition state in the same binary format

**TIP:** when using **PATHSAMPLE** it is a good idea to occasionally back up your database in case something goes wrong. It is these four files that you need to copy
to do so!

### Locating the endpoints in min.data

Two other files are also created with the database, *min.A* and *min.B*. These files define which minima **PATHSAMPLE** should consider to be in the product and
reactant states when doing kinetic analysis and selecting minima to connect when growing the database. They can contain a single minimum, or a group according to some
experimental observable or order parameter that defines the states of interest.

The format is simple, the first line contains the number of minima in state A or B and each subsequent line contains the number of each minimum in that group, the
corresponding *min.data* line number. In *min.A*, we currently have: 
```
         1
         1
```

This is saying that group A contains a single minimum, minimum 1.

The initial contents of these files are defined by the arguments to the `STARTFROMPATH` keyword in *pathdata* and do not correspond to the endpoint states for our
**A9OPTIM** pathway. Let's fix that!

To do so, we need to find the line in *min.data* that corresponds to our end point structures. This is usually done by matching their energies by looking at the
**A9OPTIM** output for the creating of *path.info.initial* which has been provided for convenience as *optim.out.initial*. Looking in this file we see that the 
energy of the endpoints appears twice. This is because they were reoptimised before being connected:
```
 OPTIM> Initial energy=    -34.60220758     RMS force=    0.3103087097E-04
 OPTIM> Final energy  =    -41.72299240     RMS force=    0.3117591169E-04
OPTIM> Bad endpoints supplied - RMS force too big!
OPTIM> Acceptable RMS force would be less or equal to     0.1000000000E-05
```

As a result, we ignore this first set of energies and look for the output once the optimisation has finished:
```
geopt>                          **** CONVERGED ****

 OPTIM> Initial energy=    -34.60220758     RMS force=    0.8612671412E-06
 OPTIM> Final energy  =    -41.72299240     RMS force=    0.8757805512E-06
```

These are the energies of our endpoints. Looking in min.data we can see that these match lines 3 and 7 so let's edit *min.A* and *min.B* to contain the correct 
information:

*min.A*
```
         1
         3
```

*min.B*
```
         1
         7
```

As well as defining the endpoint (product/reactant) states, we also need to define a direction between them. This is done using the `DIRECTION` keyword in
*pathdata*. We are using `DIRECTION AB` which, according to spectroscopic convention implies 'A from B' or A<-B - hence the minima in *min.B* are our reactants and
those in *min.A* are our products.   

### Checking the connected path is still present

Before we use **PATHSAMPLE** to further explore the landscape, we need to check that we have successfully imported the whole connected path. The easiest way to do 
this is to perform a Dijkstra analysis to identify the path between the endpoints which makes the largest contribution to the steady state rate constant, often 
termed the ‘fastest path’. 

To do this requires some editing of the *pathdata* file to uncomment the keywords involved in 'STEP 2' and comment out those in 'STEP 1'. The bottom of your 
*pathdata* file after these changes should look like this:
```
! STEP 1: creating the initial database from OPTIM path.info file
! STARTFROMPATH  path.info.initial 1 2
! CYCLES         0

! STEP 2: run a Dijkstra analysis to identify the 'fastest path' (initially commented) 
DIJKSTRA       0
CYCLES         0
```

We now run **PATHSAMPLE** again to perform the analysis:

```
PATHSAMPLE > pathsample_dijkstra.out
```

This should also be very fast as our database is very small. As we (hopefully!) have a connected path in our database between the A and B minima, the output will
contain a summary in the form of sequential min-ts-min triples followed by a list of the downhill barriers in order of size:
 
```
Dijkstra> Best path for min        7 and any A minimum, k^SS A<-B     374393.7433
       3       8       6       9      10      12       1       7
Dijkstra> Best path between any B minimum and any A minimum:
       3       8       6       9      10      12       1       7
Dijkstra> Largest contribution to SS rate constant A<-B for any A and B is      374393.7433     for      7 transition states:
Dijkstra> Note that path is printed backwards starting with A, ending with B
                    E+                          Ets                         E-
       3      -41.7229924014      13      -33.6627076722       8      -37.9782296582
       8      -37.9782296582       8      -37.5226723783       6      -37.9728100102
       6      -37.9728100102      15      -33.6176190692       9      -37.1738336534
       9      -37.1738336534       9      -31.2736332346      10      -35.3093212066
      10      -35.3093212066      18      -33.5205243121      12      -36.1555293799
      12      -36.1555293799      14      -35.0747126047       1      -35.3503472284
       1      -35.3503472284       7      -34.2706748149       7      -34.6022075799
Dijkstra> Ordered downhill barriers,    ts        barrier
                                         13     4.315521986
                                          9     4.035687972
                                         15     3.556214584
                                         18     2.635005068
                                          8    0.4501376319
                                          7    0.3315327650
                                         14    0.2756346237
```

As stated, this pathway is printed backwards, so start from the bottom right and read right to left - minimum 7 -> minimum 1 (via transition state 7) and so on.

### Visualising the fastest path

The Dijkstra analysis also produces an *Epath* file containing the energy of the minima and transition states along the fastest path. We can visualise this
using **gnuplot** to check the pathway looks sensible.

Unlike in [Example 3](../03_Connecting_minima_with_OPTIM), the plot seems to be shorter. This is because **PATHSAMPLE** has removed transitiono states that connect minima
to themselves (go back and look at the plot for Example 3!):

```
gnuplot -persist plot_Epath.png
```

<img src="tetra_ALA_initial_Epath.png" width="100%", height="100%">

### Creating a disconnectivity graph

In order to display the multidimensional potential energy surface of a system of any reasonable size without projecting along somewhat arbitrary order parameters, 
we use the disconnectivity graph representation. To do this, we use **disconnectionDPS** with keywords specified in its input file, *dinfo*.

Minima are divided into ‘superbasins’ at regular intervals specified by the `DELTA` keyword. Each minimum in the database is represented by a line that starts 
from the superbasin the minimum belongs to, and terminates at the potential energy of that minimum. The lines are arranged along the horizontal axis to produce 
the clearest representation, so the horizontal axis has no physical meaning. The vertical axis is potential energy.

To create and view a disconnectivity graph (often referred to as a 'tree') for your **PATHSAMPLE** database, simply run **disconnectionDPS** followed by **gv**:
```
disconnectionDPS
gv tree.ps
```

You should produce something like this:

<img src="tree_tetra_ALA_initial.png" width="100%", height="100%">

Using the `IDMIN` keyword in the *dinfo* file, we have labelled the endpoints, minima 3 and 7 and can start to gain an understanding
of the underlying topology of the energy landscape for tetra-ALA. When combined with keywords that colour branches by an experimentally interesting order parameter, or
committor probability - great insight can be gained from exploring the structure of these trees!

## Extension: identifying other minima of interest

A very useful keyword for **disconnectionDPS** is `IDENTIFY`. This will label ALL minima on the disconnectivity graph, making it very easy to identify what might
be an interesting structural feature, and then drill down to look at specific structures.

Add the `IDENTIFY` keyword to your *dinfo* file and re-run **disconnectionDPS**. Take a look at the resulting tree and see if you can follow the steps of the
fastest path between the endpoints across the landscape by matching the energies from your Dijkstra analysis to line numbers in min.data and hence minima on the tree.
