# Utility code

The code here can be compiled using **gfortran** to create utility programs used in some of the examples. Once compiled, they should be placed in your `PATH`.

## rancoords.f ##
Generates random (x,y,z) coordinates for a specified number of atoms with in a specified radius.
```
gfortran -o rancoords rancoords.f
```

## gminconv2.f ##
Applies a 1D Gaussian filter to convert a set of values into a continuous distribution. This is achieved via convolution with Gaussians.
```
gfortran -ffixed-line-length-132 -o gminconv2 gminconv2.f
``` 
