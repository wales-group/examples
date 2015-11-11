# Using GMIN, OPTIM and PATHSAMPLE to explore the energy landscape of LJ38
<img src="lj38_gmin.png" width="50%", height="50%">

This set of examples explore applying **GMIN**, **OPTIM** and **PATHSAMPLE** to a system of 38 Lennard-Jones atoms (LJ38).

Each example is stand-alone - you do not need to do them in order, although it may aid understanding to do so.
Expected output is provided for each, but bear in mind that it may not match yours 100% of the time.

As a prerequisite, you will need to have compiled all three codes, plus the **disconnectionDPS**, **rancoords** and **gminconv2** utility programs. 
The source code for this can be found on the Wales group website [here](http://www-wales.ch.cam.ac.uk/svn.tar.bz2) or in *examples/utilities*.
All should compile fine using **gfortran** and **cmake**.

Visualisation is done with both **gnuplot** and **VMD** which can be obtained [here](http://www.ks.uiuc.edu/Research/vmd/)

## Contents

### Example 1 - Introducing GMIN

Covers the basics of using GMIN for the LJ38 cluster, including:
- running basin-hopping to find the global minimum
- tracking the progress of a basin-hopping run using gnuplot
- investigating the effect of changing the step size and temperature
- visualising the global minimum using VMD

### Example 2 - Calculating MFET

Demonstrates calculating the mean first encounter time (MFET) for the global minimum of LJ38 from 100 random starting points.
Three sets of input are compared at different levels of optimisation to show just how much the MFET can vary with different approaches.

### Example 3 - Connecting minima with OPTIM

### Example 4 - Creating PATHSAMPLE database 

### Example 5 - Expanding PATHSAMPLE database 
