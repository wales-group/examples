set data style lines
set format y "%.1f"
set nokey
set data style points
unset mouse
set xrange [1:]
# set yrange [-12.75:-10.25]
# plot "EofS.all" linewidth 2,"EofS.3.all" linewidth 3
plot "monitor.e" using 1:3 linewidth 2 lc rgb 'red' , "monitor.e" using 1:2 linewidth 3 lc rgb 'blue'
# replot "EofS.3.all" with lines linewidth 2
pause 2
load "energy.plot"
