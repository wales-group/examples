# Example 2 - Free energy basin-hopping

As temperature rises, entropy plays an increasing role in determining structural stability. To study this effect, we calculate the local free energy associated with
minima on the potential energy surface using the harmonic superposition approach. This is referred to as **free energy** basin-hopping.

In this example we will perform free energy basin-hopping for the SER-LYS dipeptide at two temperatures. We will also look back at [Example 1](../01_Basin-hopping_with_GMIN)
and compare what we find to the results when entropy was not considered.

## Requirements
In order to successfully follow this example, the following needs to be in your *PATH*:
- an **A12GMIN** binary

## Directory contents
This directory, and the backup you can find in the *./input* subdirectory contains all the files you need to run **A12GMIN** for SER-LYS.
The *./expected_output* subdirectory contains output from a succesful **A12GMIN** run to give you an idea of what you will be producing, although your output may differ slightly.

### GMIN input files

- *data* -		Some input files are optional, but every **GMIN** job requires a *data* file containing the keywords used to specify 
			how the run should proceed 
		
- *data_annotated* -	The keywords we are using in this example are detailed in *data_annotated*. While this file is not required to run **GMIN**, it is
			provided for reference. For information on the full set of keywords available, check the [GMIN website](http://www-wales.ch.cam.ac.uk/GMIN)

- *coords.prmtop* -	The symmetrised (see the note below!) **AMBER** topology file for SER-LYS using parameters from the **AMBER** ff99SB force field

- *coords.inpcrd* -  	The starting coordinates for the SER-LYS atoms in our system in **AMBER** restart format

- *min.in* -		The **AMBER** force field parameters to use to calculate the energy and gradient. 

- *min.in_annotated* -	Not used during the run. Contains additional information about the **AMBER** parameters used in this exammple. See the **AMBER** manual for more information

- *atomgroups* -	Defines the rotatable groups for the `GROUPROTATION` **GMIN** keyword, used to generate new configurations during basin-hopping

- *atomgroups_annotated* - Describes how the `GROUPROTATION` groups are defined. See the [GMIN documentation](http://www-wales.ch.cam.ac.uk/GMIN) for more examples

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

### Utility files

- *plot_progress.plt* -	A **gnuplot** input file that we will use to check how the various energy measures changed during the basin-hopping run

## Step-by-step

Before you start producing output, take a minute to look through *data_annotated* and make sure you understand roughly the purpose of each keyword. Pay special attention to the 
keywords that were not used in [Example 1](../01_Basin-hopping_with_GMIN), namely `FEBH` and `MIN_ZERO_SEP`.

The *data* file is initially set up for an `FEBH` temperature (distinct from the sampling `TEMPERATURE`) of 0.5 kcal/mol = 251.6K. 

### Running A12GMIN

Assuming you have a **A12GMIN** binary somewhere in your *PATH*, starting the basin-hopping run is as simple as executing it in the directory containing the input files:
```
A12GMIN &
```

The output can then be view as follows:

```
tail -f output
```

IF you would like to only see the 'quenches', you can filter this using `grep`:

```
tail -f output | grep Qu
```

Although SER-LYS is a relatively small system, we are diagonalising the Hessian every step and so this could take a bit of time to run... 

Because the contents of the *output* file for free energy basin-hopping is so similar to that for standard basin-hopping we covered in [Example 1](../01_Basin-hopping_with_GMIN) we 
will not cover it in detail.

One important difference to note is that when the final quenches are printed, the free energies are given as both absolute values and relative to the lowest free energy minimum 
found:

```
Final Quench      1 energy=    -41.38587901     steps=   68 RMS force=  0.7559131E-08 time=       97.11
Final Quench      2 energy=    -41.31212951     steps=   84 RMS force=  0.8902073E-08 time=       97.23
Final Quench      3 energy=    -40.90769222     steps=   56 RMS force=  0.8541320E-08 time=       97.35
...
Final Quench     20 energy=    -39.75600693     steps=   68 RMS force=  0.9807067E-08 time=       99.34
After re-sorting, the lowest found minima are (lowest free energy subtracted if applicable):
Lowest Minimum      1 Energy=      0.000000000    
Lowest Minimum      2 Energy=     0.7374949959E-01
Lowest Minimum      3 Energy=     0.4781867895    
...
```

It is the relative free energies that will appear in the *lowest* file:

```
          45
Energy of minimum      1=     0.000000000     first found at step      196 after                65709 function calls
HH31        2.8767214682       -0.8909614326        3.6642364410
CH3         2.3553733391       -1.6074586829        3.0298851522
HH32        2.7958757429       -2.5952604914        3.1617026261
...
```

In addition to the standard **A12GMIN** output files that are produces, the file *free_energy* contains a concise summary of each quench, breaking out the potential energy and
giving timing information:

```
      Quench         Potential energy     rot/vib terms        Free energy        Markov energy            Time
 ------------------  ------------------  ------------------  ------------------  ------------------  ------------------ 
           0        -69.0291461938       29.2523081444      -39.7768380494      0.100000000000+101                 0.3
           1        -68.9643630227       29.0315931186      -39.9327699041      -39.7768380494                     0.5
           2         68.0934278826       30.9114082863       99.0048361688      -39.9327699041                     0.6
           3        -62.5297273405       29.0463249529      -33.4834023876      -39.9327699041                     0.8
...
         500        -61.6944640488       29.3692923254      -32.3251717235      -40.4600808185                    97.0
F          1        -70.1327397475       28.7468607357      -41.3858790117      -40.4600808185                    97.1
F          2        -70.2598229122       28.9476934001      -41.3121295121      -40.4600808185                    97.2
F          3        -69.6120165536       28.7043243314      -40.9076922222      -40.4600808185                    97.3
...
```

This includes the final quenches that are included in the *lowest* file, indicated by an `F` on the far left above.

### Comparing the lowest free and potential energy minimua using VMD
<img src="ser_lys_PE_FE_minima.png" width="100%", height="100%">

As we found the global potential energy minimum for SER-LYS in [Example 1](../01_Basin-hopping_with_GMIN), we can load it with **VMD** to compare against the lowest 
free energy minimum found here:

```
vmd -parm7 coords.prmtop -rst7 ../01_Basin-hopping_with_GMIN/expected_output/coords.1.rst -rst7 coords.1.rst
```

This will load the potential and free energy (at 100.8K) global minima into a pseudo trajectory. To align them and make structural comparison easy, navigate to the 
`Extensions > Analysis > RMSD Trajectory Tool` and click `RMSD` followed by `Align`. 

When you now drag the slider in the 'VMD Main' window you should see that the major difference between the global potential and free energy
minima at 100.8K is the orientation of the serine sidechain.

### The effect of raising the temperature

As we raise the temperature, entropic contributions to the free energy become more important - so much so that the global free energy minimum can change. 
To investigate this, we increase the `FEBH` temperature to 2.0 kcal/mol = 1006K. To do this we need to create a new working directory to run **A12GMIN** in so that
we don't overwrite our existing output, then copy in the required input files:

```
mkdir FEBH2.0
cp input/* FEBH2.0
cd FEBH2.0
```

In order to change the `FEBH` temperature, we need to uncomment/comment the appropriate lines in the *data* file so it contains the following:

```
! 0.5 = 251.6K
! FEBH 0.5
! alternative FEBH temperature to try
! 2.0 = 1006K
FEBH 2.0
``` 

We now run **A12GMIN** as before:

```
A12GMIN &
tail -f output | grep Qu
```

When the run completes, compare the *free_energy* output file to that produced when using `FEBH 0.5` originally. The first five final quenches from each should look
similar to the below:


**FEBH 0.5** (original)
```
F          1        -70.1327397475       28.7468607357      -41.3858790117      -40.4600808185                    97.1
F          2        -70.2598229122       28.9476934001      -41.3121295121      -40.4600808185                    97.2
F          3        -69.6120165536       28.7043243314      -40.9076922222      -40.4600808185                    97.3
F          4        -69.4543361545       28.8211893256      -40.6331468289      -40.4600808185                    97.5
F          5        -69.5914273426       29.0189104904      -40.5725168522      -40.4600808185                    97.6
...
```

**FEBH 2.0** (new)
```
F          1        -68.3455658283      -249.266752706      -317.612318534      -316.596752843                    98.7
F          2        -69.2735281825      -248.207507667      -317.481035850      -316.596752843                    98.8
F          3        -68.8724987305      -248.530008125      -317.402506856      -316.596752843                    98.9
F          4        -67.4884318245      -249.752431045      -317.240862869      -316.596752843                    99.1
F          5        -67.0410418849      -250.066833469      -317.107875354      -316.596752843                    99.2
...
```

The first thing to notice here is that the harmonic term is more significant at 1006K. 

We also see that the potential energy for the lowest free energy minimum has changed from -70.13 to -68.35 kcal/mol, suggesting that the structure of the
global free energy minimum has changed after we raised the temperature. We can confirm this by using **VMD** again and aligning the structures before with the 
'RMSD Trajectory Tool' as before:

```
vmd -parm7 coords.prmtop -rst7 ../coords.1.rst -rst7 coords.1.rst
```

Due to the order in which we load the structures, frame 0 (the first structure) will correspond to the `FEBH 0.5` global free energy minimum. Looking at the difference between these
two structures, can you suggest why the second (from `FEBH 2.0`) may be more entropically stabilised?

You can see a comparison of (from left to right) the global potential energy and free energy minima at 251.6 (`FEBH 0.5)` and 1006K (`FEBH 2.0`) respectively. 


## Extension: what about lowering the `FEBH` temperature?

Given that 1 kcal/mol = 504K, copy and edit the original input into new directories and run **A12GMIN** for some lower temperatures. Does the global free energy minimum change 
again at any point? 

If not - raise the temperature! Go crazy!  
