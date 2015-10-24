for {set i 0} {$i<1000} {incr i} {after [expr 5000*$i] source test.vmd;
after [expr 5000*$i+4900] {molinfo top;mol delete [molinfo top]}}


