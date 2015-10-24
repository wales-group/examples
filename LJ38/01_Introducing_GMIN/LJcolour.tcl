proc enabletrace {args} {
     global vmd_frame numatoms minEnergy

      trace variable vmd_frame([molinfo top]) w do_draw
}

proc disabletrace {args} {
     global vmd_frame numatoms minEnergy

      trace vdelete vmd_frame([molinfo top]) w do_draw
}

proc initxyz {filename} {
   global xdata ydata zdata
   global vmd_frame numParamsRead
   global molid numatoms minEnergy atomcolor
   # assume we are in the script directory and filename is in the data directory.

   disabletrace

# set three colours
   set color1 blue
   set color2 green
   set color3 red
   

   set wholeFileName [expr {"$filename"}]

   # open the data file and assign a fileId.
   set fileId [open $wholeFileName r]

   # extract num of atoms from file
   
#   if { [catch {mol load xyz $filename} fid] } {
#    set errornumber $fid
#   } else {
    mol load xyz "$filename"
#   }
   set molid [molinfo top] 
   mol rename $molid  $filename
   set frame [molinfo $molid get numframes]
   set cf 0 
   set numatoms [gets $fileId]
#   set vmd_frame($molId) 
   # scan until the end of the file comes up
   while { [eof $fileId] == 0 } {
#     if {$cf==0} {set numatoms [gets $fileId]} 
#     if {$cf>0} {set numatoms1 [gets $fileId]}
     # read next line in file
     set energyline [gets $fileId]
     # parse line
     set numParamsRead [scan $energyline "%f" minEnergy]
#     puts "energyline= $energyline  "
#     puts "numparamsread= $numParamsRead"
     # check the number of parameters read is correct before proceeding, else it is not a start of frame line.
     if {$numParamsRead == 1} {

        # output energy line by way of a heart beat [ie so user knows program is running].
#        puts $minEnergy
#        puts $cf 
#        puts $molid 

        # loop through $numAtoms lines obtaining information about each atom in molecule and then plot the data in VMD.
        for {set atom 0} {$atom < $numatoms} {set atom [expr $atom + 1]} {
#           start_cache molid 
           set atom_detail [gets $fileId]
           set numParamsRead [scan $atom_detail " %2s %f %f %f" \
                atomtype($cf,$atom) xdata($cf,$atom) ydata($cf,$atom) zdata($cf,$atom)]
           if {$atomtype($cf,$atom)=="X1"} {set atomcolor($cf,$atom) $color1
           } elseif {$atomtype($cf,$atom)=="X2"} {set atomcolor($cf,$atom) $color2
           } elseif {$atomtype($cf,$atom)=="X3"} {set atomcolor($cf,$atom) $color3
           } else {set atomcolor($cf,$atom) white}
        }

       set cf [expr $cf + 1]
     }
  }
#   set frame $cf
   set cf [expr $cf - 1]
}

proc draw_sphere {index atom radius eColour} {
  global adata bdata cdata hhdata iidata jjdata xdata ydata zdata

  set x [expr $xdata($index,$atom)]
  set y [expr $ydata($index,$atom)]
  set z [expr $zdata($index,$atom)]
#        puts "x= $xdata($index,$atom)"
        draw color $eColour

        draw sphere "$x $y $z" radius $radius resolution 60
}

proc do_draw {name element op} {
     global vmd_frame numatoms scalefac minEnergy atomcolor

#        puts "in do_draw, $numatoms"
      draw delete all
#        puts $minEnergy
#        draw text {-1.0 -4.0 0} "$minEnergy"
     for {set atom 0} {$atom < $numatoms} {set atom [expr $atom + 1]} {
        draw_sphere [expr $vmd_frame([molinfo top])] $atom  0.5  $atomcolor($vmd_frame([molinfo top]),$atom)
     }
}


