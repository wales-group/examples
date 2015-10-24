for {set i 0} {$i<1000} {incr i} {
after [expr 2000*$i] source test2.vmd;
after [expr 1+2000*$i] {set infile [open "best.xyz" r]; 
                      gets $infile line; gets $infile line;
                      close $infile;
                      draw delete all;
                      draw material Opaque; draw color white;
                      draw text {-2 -5 0} "$line";
                      set infile [open "monitor.xyz" r]; 
                      gets $infile line; gets $infile line;
                      close $infile;
                      draw text {-10 -5 0} "$line";
                     };
after [expr 1999+2000*$i] {molinfo top;mol delete [molinfo top]};
after [expr 1999+2000*$i] {molinfo top;mol delete [molinfo top]}
}


