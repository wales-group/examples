# Using GMIN to explore the potential and free energy landcape of SER-LYS
<img src="ser_lys_fe0.6_gmin.png" width="50%", height="50%">

This set of examples explore applying **A12GMIN** to find the potential and free energy global minima for the SER-LYS dipeptide.

As a prerequisite, you will need to have compiled **A12GMIN** (or have access to binary). 

Unfortunately due to licensing restrictions, we are not able to distribute the source code for **(A9/A12)GMIN** or **(A9/A12)OPTIM**.
If you have an **AMBER** license - please contact [David Wales](mailto:dw34@cam.ac.uk) to request access to the **AMBER** specific source code.

If you have the source code, all should compile fine using **gfortran** and **cmake**.

Visualisation is done with both **gnuplot** and **VMD** which can be obtained [here](http://www.ks.uiuc.edu/Research/vmd/)

These examples are practically focussed and as such, we won't be covering the theoretical basis of basin-hopping or how the free energy is calculated.

## Contents
Each example is stand-alone - you do not need to do them in order, although it may aid understanding to do so.
Expected output is provided for each, but bear in mind that it may not match yours 100% of the time.

Where appropriate, annotated versions of input files are provided (*FILE_annotated*) describing their contents.
These descriptions are not exhaustive so for more detail, see the documentation.

### [Example 1 - Basin-hopping with GMIN](./01_Basin-hopping_with_GMIN)

Covers the basics of using **A12GMIN** for the SER-LYS dipeptide, including:

- running basin-hopping to find the the 20 lowest energy minima
- tracking the progress of a basin-hopping run using gnuplot
- visualising the minima found using **VMD** or **Pymol**

### [Example 2 - Free energy basin-hopping](./02_Free_energy_basin-hopping)

Demonstrates the free energy basin-hopping approach including:

- comparing the potential and free energy global minima
- investigating the effect of raising the temperature on the global free energy minimum
