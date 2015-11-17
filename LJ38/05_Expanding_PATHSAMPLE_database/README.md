# Example 5 - Expanding PATHSAMPLE database

Although identifying a single discrete path for a system can give us some information on the kinetics and underlying energy landscape, we are likely to be 
missing many kinetically relevent states and as such, should be wary of drawing conclusions from our initial results. **PATHSAMPLE** provides a range of methods
to allow us to efficiently expand our stationary point database to achieve a more kinetically relevent sample.

All of these methods focus on ways of selecting pairs of minima in our database to connect using **OPTIM**. For example, the `SHORTCUT` method aims to
choose pairs to reconnect that will reduce the overall length of the path between endpoints, while `SHORTCUT BARRIER` aims to find alternative connections to avoid
the largest barriers between them. 

In this example, we will be using `UNTRAP`, another of these methods that aims to reconnect minima similar in energy but seperated by large barriers - often referred
to as kinetic traps. For more information all these and other methods, check the [PATHSAMPLE website](http://www-wales.ch.cam.ac.uk/PATHSAMPLE).  

## Requirements
In order to successfully follow this example, the following need to be in your *PATH*:

- a **PATHSAMPLE** binary
- an **OPTIM** binary
- a **disconnectionDPS** binary

## Directory contents
Both this directory and the backup in *./input* contain all the files you need to run **PATHSAMPLE** to expand the database created in Example 4. 
The *./expected_output* subdirectory contains output after all of the below steps have been followed. Your intermediate results may differ as a result.

As **PATHSAMPLE** acts as a driver for **OPTIM** (i.e. it starts **OPTIM** jobs), there are also **OPTIM** input files present.

### PATHSAMPLE input files

- *pathdata* -			Every **PATHSAMPLE** job requires a *pathdata* file containing the keywords used to specify what we would like the run to achieve.
				This example will require us to run it twice with different keywords, hence there are two sections at the bottom of
				*pathdata*, one initially commented out (starting with '! ')

- *pathdata_annotated* -	The **PATHSAMPLE** keywords we are using in this example are detailed in *pathdata_annotated*. This file is not required, it is
				provided for reference only. For information on the full set of **PATHSAMPLE** keywords available, check the
				[PATHSAMPLE website](http://www-wales.ch.cam.ac.uk/PATHSAMPLE)

- *min.A* -			Defines which minima should be considered part of the A group - the products or reactants depending on how we specify the `DIRECTION`
				in *pathdata*

- *min.B* -			Defines which minima should be considered part of the B group - the products or reactants depending on how we specify the `DIRECTION`
				in *pathdata*

### PATHSAMPLE database files

- *min.data* - 	Contains the energy, log product of vibrational frequencies, symmetry and moments of inertia for each minimum. A minimum is identified by its
		line number in this file

- *ts.data* -	Contains the energy, log product of vibrational frequencies, symmetry, minima numbers that it connects and moments of intertia for each
		transition state. A transition state is identified by its line number in this file

- *points.min* -	Contains the coordinates for each minimum in a binary format to keep the file size low

- *points.ts* -		Contains the coordinates for each transition state in the same binary format

### OPTIM input files

- *odata.connect* -		Contains the **OPTIM** keywords used for jobs started by **PATHSAMPLE**. 
				It should be noted that the major difference between this file and an *odata* file used in a standalone
				**OPTIM** job is the lack of starting coordinates following the ``POINTS`` keyword. This is because *odata.connect* acts as the
				template from which **PATHSAMPLE** can build *odata.JOBID* files for the runs it starts, adding the coordinates as appropriate

		
- *odata.connect_annotated* -	The **OPTIM** keywords present in *odata.connect* are detailed in *odata.connect_annotated*.
				For information on the full set of keywords available, check the [OPTIM website](http://www-wales.ch.cam.ac.uk/OPTIM)

### disconnectionDPS input files

- *dinfo* -			Contains the keywords that control the appearence of the disconnectivty graph produced when **disconnectionDPS** is run in the
				current directory

- *dinfo_annotated* -		The **disconnectionDPS** keywords used in this example are detailed in *dinfo_annotated*. For more information and a full
				keyword listing, see the top of the *disconnectionDPS.f90* source file, available in the source tar file on the
				[Wales Group website](http://www-wales.ch.cam.ac.uk)

## Step-by-step

Before you start, take a minute to look through *pathdata_annotated* and *odata.connect_annotated* and make sure you understand roughly the purpose of each keyword.  

### Expanding the stationary point database

TO ADD

- explain how many OPTIM jobs are run per cycle (CPUS)

### Creating a disconnectivity graph

In order to display the multidimensional potential energy surface of a system of any reasonable size without projecting along somewhat arbitrary order parameters, 
we use the disconnectivity graph representation. To do this, we use **disconnectionDPS** with keywords specified in its input file, *dinfo*.

Minima are divided into ‘superbasins’ at regular intervals specified by the `DELTA` keyword. Each minimum in the database is represented by a line that starts 
from the superbasin the minimum belongs to, and terminates at the potential energy of that minimum. The lines are arranged along the horizontal axis to produce 
the clearest representation, so the horizontal axis has no physical meaning.

To create and view a disconnectivity graph (often referred to as a 'tree') for your **PATHSAMPLE** database, simply run **disconnectionDPS** followed by **gv**:
```
disconnectionDPS; gv tree.ps
```

You should produce something like this:

<img src="expandedtree_eg.png" width="100%", height="100%">

Using the `IDMIN` keyword in the *dinfo* file, we have labelled the endpoints, minima 2 and 8 and can start to gain an understanding
of the underlying topology of the energy landscape for LJ38. When combined with keywords that colour branches by an experimentally interesting order parameter, or
committor probability - great insight can be gained from exploring the structure of these trees!

### Q: When do you stop?!

- brief discussion about knowing when to stop running PATHSAMPLE i.e. you don't usually!

## Extension: understanding why minima are being selected for connection

When using PATHSAMPLE to expand a database and optimise a pathway, the choice of parameters for the minima selection method (e.g. `UNTRAP`) can be critical. It is 
highly recommended that before you leave **PATHSAMPLE** running for a month on 128 cores, you check that the minima it is choosing to connect make some intuitive
sense!

This is most easily done by including the `DUMMYRUN` keyword in *pathdata*. This will cause **PATHSAMPLE** to act exactly as it would in a normal run, but no **OPTIM**
jobs will be actually started. This means that you can briefly run the job and look into the output being produced to see which minima are being selected for
connection.

Identify which minima are being initially selected by `UNTRAP` in this example by looking at the top of your **PATHSAMPLE** output where the pairs are printed, just
below this section:
```
getupair> lowest minimum in product set lies at     -173.9284266
getupair> highest transition state lies at     -168.2771069
getupair> sorted list of       11 pairs
```

Generate a new disconnectivity graph using **disconnectionDPS** with these minima identified using `IDMIN` in *dinfo*. Check that you are happy that these minima
make sense to be reconnected if we are trying to eliminate kinetic traps between our specified endpoints (minima 8 and 2). 

Feel free to change the parameters of `UNTRAP` and add `DUMMYRUN` to *pathdata* and see how this affects the pairs being choosen. 
