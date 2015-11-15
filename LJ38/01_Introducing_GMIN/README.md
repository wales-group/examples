# Example 1 - Introducing GMIN

**GMIN** aims to efficiently locate the global minimum of a system by employing the basin-hopping methodology. 
Here we use it to find the two lowest energy minima for a cluster of 38 Lennard-Jones particles, known as LJ38.

## Directory contents
This directory, and the backup you can find in the *./input* subdirectory, contain all the files you need to run **GMIN** for LJ38. The *./expected_output*
subdirectory contains output from a succesful **GMIN** run to give you an idea of what you will be producing, although your output may differ slightly.

### GMIN input files

- *data* -		Some input files are optional, but every **GMIN** job requires a *data* file containing the keywords used to specify 
			how the run should proceed 
		
- *data_annotated* -	The keywords we are using in this example are detailed in *data_annotated*. While this file is not required to run **GMIN**, it is
			provided for reference. For information on the full set of keywords available, check the [GMIN website](http://www-wales.ch.cam.ac.uk/GMIN)

- *coords* - 		The (x,y,z) starting coordinates for the LJ atoms in our system, one line per atom

### Utility files

- *plot_progress.plt* -	A **gnuplot** input file that we will use to check how the various energy measure changed during the basin-hopping run

- *view_best.tcl* -	TCL script that can be used as input for **VMD** to visualise the lowest energy minimum found

- *LJcolour.tcl* - 	TCL script used by *view_best.tcl* to colour the LJ atoms according to their pair energies, revealing any symmetry

## Step-by-step

Before you start producing output, take a minute to look through *data_annotated* and make sure you understand roughly the purpose of each keyword. You will find
some keywords are commented out, starting with ' !'. These are optional values to be experimented with that we will return to later. 

### Running GMIN

Assuming you have a **GMIN** binary somewhere in your *PATH*, starting the basin-hopping run is as simple as executing it in the directory containing the input files:
```
GMIN
```
As LJ38 is a relatively small system, this won't take long to finish - around 30 seconds - and will produce a few output files that we will look at in more detail. 

First is *output*, containing a lot of information on how the job progressed. The basin-hopping procedure in **GMIN** can be broken down into three phases:

1. Initial quench (Qu) and first basin-hopping steps
```
Calculating initial energy
Qu          0 E=    -167.3731638     steps=  238 RMS= 0.44987E-02 Markov E=    -167.3731638     t=        0.0
Starting MC run of       5000 steps
Temperature will be multiplied by      1.00000000 at every step
Qu          1 E=    -168.6121576     steps=  107 RMS= 0.39064E-02 Markov E=    -167.3731638     t=        0.0
Qu          2 E=    -167.5223376     steps=  109 RMS= 0.47082E-02 Markov E=    -168.6121576     t=        0.0
```

TO ADD
 
2. STEP size adjustment to satisfy target acceptance ratio
```
Qu         50 E=    -169.1284349     steps=  117 RMS= 0.23688E-02 Markov E=    -168.8944059     t=        0.1
Acceptance ratio for previous     50 steps=  0.6200  FAC=  1.0500
Steps are now:  STEP=    0.4200  ASTEP=    0.5355 Temperature is now:    1.0000
Qu         51 E=    -166.4647262     steps=  192 RMS= 0.43178E-02 Markov E=    -169.1284349     t=        0.1
```

TO ADD

3. Final quenches and file output
```
Final Quench      1 energy=    -173.9284262     steps=    5 RMS force=  0.6150277E-03 time=       11.44
Final Quench      2 energy=    -173.2523776     steps=    7 RMS force=  0.9629919E-03 time=       11.44
```

TO ADD  

