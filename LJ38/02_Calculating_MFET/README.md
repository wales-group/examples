# Example 2 - Calculating MFET

A frequently used measure of performance for global optimisation is the Mean First Encounter Time (MFET) for the global minimum. This is the average time taken 
(measured say in the number of calls to the potential being used) to locate the global minimum for a range of random starting configurations. The MFET when using 
**GMIN** is affected by many parameters, including the type and size of `STEP` used to generate new conformations and the `TEMPERATURE`.

In this example, we compare the MFET of basic **GMIN** input like that used in Example 1, to some that has been highly optimised. 

As we have identified the energy of the global minimum for this system, we can use the `TARGET` keyword in the *data* file to stop **GMIN** as soon as it has been 
found.

## Requirements
In order to successfully follow this example, the following need to be in your *PATH*:

- a **GMIN** binary
- compiled **rancoords** utility program (source in *../../utilities*)
- compiled **gminconv2** utility program (source also in *../../utilities*)

## Directory contents
This directory contains three sets of **GMIN** input:

- *./input* 			- basic GMIN input as used in Example 1
- *./input_SYMMETRISE*		- input using symmetry adapted moves to generate new geometries
- *./input_SYMMETRISECSM*	- input using symmetry adapted moves employing a continuous symmetry measure (CSM) 

Each contains all the files you need to run **GMIN** for LJ38. The *./expected_output* subdirectory contains matching directories for each set of input from a 
succesful set of **GMIN** runs to give you an idea of what you will be producing. Note that your output may differ!

### GMIN input files

- *data* -		Some input files are optional, but every **GMIN** job requires a *data* file containing the keywords used to specify 
			how the run should proceed 
		
- *data_annotated* -	The keywords we are using in this example are detailed in *data_annotated*. While this file is not required to run **GMIN**, it is
			provided for reference. For information on the full set of keywords available, check the [GMIN website](http://www-wales.ch.cam.ac.uk/GMIN)

- *coords* - 		The (x,y,z) starting coordinates for the LJ atoms in our system. Replaced by **rancoords** with random coordinates for this example 

### Utility files

- *100_LJ38_runs.csh* -	script to generate 100 sets of random coordinates, run **GMIN** starting from each and then calculate the MFET

## Step-by-step

Before you start producing output, take a minute to look through *data_annotated* and make sure you understand roughly the purpose of each keyword. You will find
some keywords are commented out, starting with ' !'. It is also recommended that you read through the *100_LJ38_runs.csh* script as you go. 

### Calculating the MFET (basic input)

The input currently in the directory corresponds to the basic **GMIN** input from Example 1. Assuming you have the binary somewhere in your *PATH*, running
**GMIN** from 100 random starting points is as simple as this:

```
./100_LJ38_runs.sh basic 42
```

‘*basic*’ is the name of the subdirectory that will contain the output for the runs and 42 is used to seed the random number generator that creates the initial 
coordinates for each run. Feel free to change either.

This will take some time so you might want to grab a coffee or take a break. When it finishes, the script prints the mean and standard deviation of the time taken 
to find the global minimum as measured by *t* (time in seconds), *Q* (number of quenches) and *V* (number of calls to the potential). 

```
Starting run 99
Starting run 100
Mean and standard deviation for global minimum first encounter time:
mu/sig of t, Q, V  are          6.59         7.37      2824.70      3092.98    387784.64    427516.22
```

In this case the MFET is 6.59s with a standard deviation of 7.37s. If you're curious, feel free to explore the contents of the directory that you specified 
when running the script. It contains the **GMIN** output from each starting point as well as some summary statistics.

### Computing the MFET with more optimised input

By changing the **GMIN** parameters specified in the *data* file we can significantly affect the efficiency of the basin-hopping global optimisation procedure.
In the extension to Example 1, we explored this by varying the Cartesian `STEP` size and `TEMPERATURE` used when accepting or rejecting minima into the Markov chain.
Here we take a different approach - generating new conformations in an entirely different way using symmetry adapted moves. The details of these moves are beyond
the scope of this example - for more information see the [GMIN website](http://www-wales.ch.cam.ac.uk/GMIN).

Once we have copied the input into our working directory, we can start 100 **GMIN** runs as before, this time saving output in the *./sym* subdirectory:
```
cp input_SYMMETRISE/* .
./100_LJ38_runs.sh sym 42
```

This should run significantly faster, and the improvement will be reflected in the MFET stats printed at the end, for example:
```
Starting run 99
Starting run 100
Mean and standard deviation for global minimum first encounter time:
mu/sig of t, Q, V  are          1.12         1.27       737.86       702.99     59631.66     69090.13
```

Much better! 

This nicely demonstrates the take home message of this example: the type (and size) of moves that are most effective depend a lot on the system you are 
studying - both it's size and topology. Here, moves that exploit the symmetry of the system are much more effective than 'dumb' random Cartesian displacements.

## Extension: using even more optimised input

The input files in *./input_SYMMETRISECSM* demonstrate just how fast we can find the global minimum for LJ38 with extremely optimised parameters. 

Copy the input into your working directory as before and run another 100 **GMIN** runs to calculate the MFET - remembering to change the directory you 
save the output to when running the script.

Feel free to alter both the `STEP` size and `TEMPERATURE` in the *data* file as in Example 1 to see how changing them (and thus the efficiency of basin-hopping) 
affects the MFET. 
