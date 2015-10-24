for {set i 0} {$i<1000} {incr i} {
after [expr 5000*$i] 
{source test2.vmd;
set infile [open "best.xyz" r]; 
gets $infile line; gets $infile line;
close $infile;
draw delete all;
draw material Opaque; draw color white;
draw text {-12 0.95 -3} "$line";
set infile [open "monitor.xyz" r];
gets $infile line; gets $infile line;
close $infile;
draw material Opaque; draw color white;
draw text {-12 -8 -3} "$line"};
after [expr 5000*$i+4999] {molinfo top; mol delete [molinfo top]};
after [expr 5000*$i+5000] {molinfo top; mol delete [molinfo top]}
}


