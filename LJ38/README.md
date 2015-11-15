# Using GMIN, OPTIM and PATHSAMPLE to explore the energy landscape of LJ38
<img src="lj38_gmin.png" width="50%", height="50%">

This set of examples explore applying **GMIN**, **OPTIM** and **PATHSAMPLE** to a system of 38 Lennard-Jones atoms (LJ38).

As a prerequisite, you will need to have compiled all three codes, plus the **disconnectionDPS**, **rancoords** and **gminconv2** utility programs. 
The source code for this can be found on the Wales group website [here](http://www-wales.ch.cam.ac.uk/svn.tar.bz2) or in *examples/utilities*.
All should compile fine using **gfortran** and **cmake**.

Visualisation is done with both **gnuplot** and **VMD** which can be obtained [here](http://www.ks.uiuc.edu/Research/vmd/)

These examples are practically focussed and as such, we won't be covering the theoretical basis of basin-hopping global optimisation or discrete path sampling.

## Contents
Each example is stand-alone - you do not need to do them in order, although it may aid understanding to do so.
Expected output is provided for each, but bear in mind that it may not match yours 100% of the time.

Where appropriate, annotated versions of input files are provided (*FILE_annotated*) describing their contents.
These descriptions are not exhaustive so for more detail, see the documentation. 

### Example 1 - Introducing GMIN

Covers the basics of using **GMIN** for the LJ38 cluster, including:

- running basin-hopping to find the the two lowest energy minima
- tracking the progress of a basin-hopping run using gnuplot
- investigating the effect of changing the step size and temperature
- visualising the global minimum using **VMD**

### Example 2 - Calculating MFET

Demonstrates calculating the mean first encounter time (MFET) for the global minimum of LJ38:

- generate 100 random starting points and find the global minimum from each using **GMIN**
- compare the efficiency of three sets of **GMIN** input that have been optimised to different degrees

This example aims to show just how much the MFET time can vary with the approach used.

### Example 3 - Connecting minima with OPTIM

Using **OPTIM**, create an initial discrete path between the two lowest energy minima found in Example 1. 
This includes:
- using the doubly-nudged elastic band method (DNEB) to identify transition state candidates
- refining transition states using a hybrid BFGS/eigenvector following approach and Rayleigh-Ritz minimisation
- plotting the energy along the initial path
- viewing the initial path using **VMD** where each LJ atoms is coloured by its pair energy
- producing the output file (*path.info*) that can be used as a starting point for **PATHSAMPLE** (see Example 4)

### Example 4 - Creating PATHSAMPLE database 

Using an **OPTIM** *path.info* file, initialise a **PATHSAMPLE** database to use for further sampling and calculating rates.
This involves:
- using the `STARTFROMPATH` procedure to read an **OPTIM** *path.info* file
- correctly setting the endpoints of interest in *min.A* and *min.B* by identifying them in *min.data*
- running a Dijkstra analysis to identify the 'fastest path' and visualising it using **gnuplot**
- creating a disconnectivity graph for the intial database using **disconnectionDPS**

### Example 5 - Expanding PATHSAMPLE database

Expand the initial LJ38 **PATHSAMPLE** database by smartly selecting minima to reconnect using the `UNTRAP` procedure.
This involves:
- using **PATHSAMPLE** to run **OPTIM** jobs that expand the initial database in a targeted way
- creating a disconnectivity graph for the expanded database using **disconnectionDPS**
