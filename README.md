# GMIN, OPTIM and PATHSAMPLE example input
These directories contain example input and output for the **GMIN**, **OPTIM** and **PATHSAMPLE** codes developed in the Wales Group at the University of Cambridge.

## Prerequisites

In order to run through these examples, you will need to either use a build of the Wales Group VM, or have the following Ubuntu packages installed via `apt-get`:

- to compile the code
```
sudo apt-get install build-essential gfortran cmake cmake-curses-gui csh bison flex libblas-dev liblapack-dev
```

- utility programs for visualisation etc
```
sudo apt-get install vim git subversion gnuplot-x11 gv
```

## Compiling GMIN, OPTIM and PATHSAMPLE

Once you have the source cosde, **GMIN**, **OPTIM** and **PATHSAMPLE** can be easily compiled using **cmake**. Detailed instructions can be found [here](./COMPILATION.md). 


## Example systems

### [LJ38](./LJ38) - a 38 atom Lennard-Jones cluster
<img src="LJ38/lj38_gmin.png" width="50%", height="50%">
- Basin-hopping with **GMIN**
- Calculating the mean first encounter time (MFET)
- Connecting minima with a discrete path using **OPTIM**
- Setting up a **PATHSAMPLE** database using an **OPTIM** *path.info* file
- Expanding a **PATHSAMPLE** database in a targeted way

### [tetra-ALA](./tetra_ALA) - an alanine polypeptide (AMBER)
<img src="tetra_ALA/tetra_ALA_igb2_gmin.png" width="50%", height="50%">
- Basin-hopping with **A9GMIN**
- Investigating the effect of removing C-alpha chirality checks 
- Connecting minima with a discrete path using **A9OPTIM**
- Setting up a **PATHSAMPLE** database using an **A9OPTIM** *path.info* file
- Expanding a **PATHSAMPLE** database in a targeted way

### [SER-LYS](./SER_LYS) - a capped dipeptide (AMBER)
<img src="SER_LYS/ser_lys_fe0.6_gmin.png" width="50%", height="50%">

- Basin-hopping with **GMIN**
- Free energy basin-hopping using **A9GMIN** to investigate the effect of entropy

### [trypzip](./trypzip) - a 12 residue tryptophan zipper (AMBER)
<img src="trypzip/trypzip_endpoints.png" width="50%", height="50%">

**CHALLENGE!**

- Efficiently expand a **PATHSAMPLE** database for a provided initial folding path
- Requires much trial and error!

## Compiling the Wales Group codes

### Obtaining the source code

The source code can be obtained from the Wales group website [here](http://www-wales.ch.cam.ac.uk/svn.tar.bz2) or using `wget` like so:

```
wget http://www-wales.ch.cam.ac.uk/svn.tar.bz2
```

**NOTE:** Due to licensing issues, we cannot distribute the **AMBER** or **CHARMM** interfaced versions of our source code. If you have a license for either, contact
[David Wales](mailto:dw34@cam.ac.uk) and request access to the restricted code.

Copy the tar file into a working directory and uncompress it as follows: 

```
tar xvfj svn.tar.bz2
```

Replace the file name as necessary should you have a version of the source containing the AMBER or CHARMM interface. Now, change directory until you see a set of folders including
one for **GMIN**, one for **OPTIM** and one for **PATHSAMPLE**.

### Compiling GMIN

All **cmake** builds are 'out of source' i.e. we build the binary in a directory that does not contain the source code. As a result, the first thing we need to do is create
a build directory and move into it (note the nifty shortcut!):

```
mkdir -p GMIN/build/gfortran
cd !$
```

 

You can then compile **GMIN** as follows:

```
cd GMIN
mkdir build
cd build
FC=gfortran cmake ../source
make -j
```

To see additional options for the compilation (including enabling the interfaces to **AMBER** and **CHARMM**) you can run ``ccmake .`` in your build directory.
If you make any changes here, make sure you 'configure' (`c`), 'exit' (`e`) and then 'generate' (`g`).

For **OPTIM**:

```
cd OPTIM
mkdir build
cd build
FC=gfortran cmake ../source
make -j
```

For **PATHSAMPLE**:

```
cd PATHSAMPLE
mkdir build
cd build
FC=gfortran cmake ../source
make -j
```



 
