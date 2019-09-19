# Using GMIN, OPTIM and PATHSAMPLE to explore the energy landscape of tetra-ALA
<img src="tetra_ALA_igb2_gmin.png" width="50%", height="50%">

This set of examples explore applying **A12GMIN**, **A12OPTIM** and **PATHSAMPLE** to the tetra-ALA peptide (ALA-ALA-ALA-ALA).

As a prerequisite, you will need to have compiled all three codes (or have access to binaries), plus the **disconnectionDPS** utility program. 
The source code for **disconnectionDPS** can be found on the Wales group website [here](http://www-wales.ch.cam.ac.uk/svn.tar.bz2).

Unfortunately due to licensing restrictions, we are not able to distribute the source code for **(A9/A12)GMIN** or **(A9/A12)OPTIM**.
If you have an **AMBER** license - please contact [David Wales](mailto:dw34@cam.ac.uk) to request access to the **AMBER** specific source code.

If you have the source code, all should compile fine using **gfortran** and **cmake**.

Visualisation is done with both **gnuplot** and **VMD** which can be obtained [here](http://www.ks.uiuc.edu/Research/vmd/)

These examples are practically focussed and as such, we won't be covering the theoretical basis of basin-hopping global optimisation or discrete path sampling.

## Contents
Each example is stand-alone - you do not need to do them in order, although it may aid understanding to do so.
Expected output is provided for each, but bear in mind that it may not match yours 100% of the time.

Where appropriate, annotated versions of input files are provided (*FILE_annotated*) describing their contents.
These descriptions are not exhaustive so for more detail, see the documentation.

### [Example 1 - Basin-hopping with GMIN](./01_Basin-hopping_with_GMIN)

Covers the basics of using **A12GMIN** for the tetra-ALA peptide, including:

- running basin-hopping to find the the 10 lowest energy minima *in vacuo* and with a Generalised Born implicit solvent
- tracking the progress of a basin-hopping run using gnuplot
- visualising the global minimum using **VMD** or **Pymol**

### [Example 2 - Removing the chirality checks](./02_Removing_chirality_checks)

Demonstrates the effect of removing the chirality checks for C-alpha atoms of the tetra-ALA peptide:

- identifying the now mixed L/D global minimum
- visualising the global minimum with **VMD** and identifying the inverted chiral centres

This example shows the limitations of using a force field parametrised for use with molecular dynamics only.

### [Example 3 - Connecting minima with OPTIM](./03_Connecting_minima_with_OPTIM)

Using **A12OPTIM**, create an initial discrete path between the two tetra-ALA minima. 
This includes:
- using the doubly-nudged elastic band method (DNEB) to identify transition state candidates
- refining transition states using a hybrid BFGS/eigenvector following approach and Rayleigh-Ritz minimisation
- plotting the energy along the initial path
- viewing the initial path using **VMD**
- producing the output file (*path.info*) that can be used as a starting point for **PATHSAMPLE**

### [Example 4 - Creating a PATHSAMPLE database](./04_Creating_PATHSAMPLE_database) 

Using an **A12OPTIM** *path.info* file, initialise a **PATHSAMPLE** database to use for further sampling and calculating rates.
This involves:
- using the `STARTFROMPATH` procedure to read an **A12OPTIM** *path.info* file
- correctly setting the endpoints of interest in *min.A* and *min.B* by identifying them in *min.data*
- running a Dijkstra analysis to identify the 'fastest path' and visualising it using **gnuplot**
- creating a disconnectivity graph for the intial database using **disconnectionDPS**

### [Example 5 - Expanding a PATHSAMPLE database](./05_Expanding_PATHSAMPLE_database)

Expand the initial tetra-ALA **PATHSAMPLE** database by smartly selecting minima to reconnect using the `SHORTCUT BARRIER` procedure.
This involves:
- using **PATHSAMPLE** to run **A12OPTIM** jobs that expand the initial database in a targeted way
- creating a disconnectivity graph for the expanded database using **disconnectionDPS**
