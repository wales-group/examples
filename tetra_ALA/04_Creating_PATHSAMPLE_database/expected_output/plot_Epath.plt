# tetra-ALA

# Plot the fastest path identified by PATHSAMPLE using a Dijkstra analysis

# Set plot parameters
se xla "Step along fastest path"
se yla "Energy kcal/mol"
se tit "Dijkstra fastest path between min.A and min.B for tetra-ALA"
se grid
unset key

# Plot 'Epath' containing the energy of the stationary points along the fastest path
pl [1:15][] 'Epath' w l lw 2 linecolor rgb "red"
