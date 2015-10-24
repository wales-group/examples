for {set i 0} {$i<1000} {incr i} {
after [expr 2000*$i] source ala4.vmd;
after [expr 1+2000*$i] {set infile [open "best.xyz" r]; 
                      gets $infile line; gets $infile line;
                      close $infile;
                      draw delete all;
                      draw material Opaque; draw color white;
                      draw text {28 -6 -0} "$line";
                      set infile [open "monitor2.xyz" r]; 
                      gets $infile line; gets $infile line;
                      close $infile;
                      draw text {16 -11 -4.5} "$line";
                     };
after [expr 1999+2000*$i] {molinfo top;mol delete [molinfo top]};
after [expr 1999+2000*$i] {molinfo top;mol delete [molinfo top]}
}


