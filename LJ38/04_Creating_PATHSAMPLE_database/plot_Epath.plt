# LJ38

# Plot the fastest path identified by PATHSAMPLE using a Dijkstra analysis

# Set plot parameters
se xla "Step along fastest path"
se yla "Energy"
se tit "Dijkstra fastest path between min.A and min.B for LJ38"
se grid
unset key

# Plot 'Epath' containing the energy of the stationary points along the fastest path
pl [1:17][] 'Epath' w l lw 2 linecolor rgb "red"
