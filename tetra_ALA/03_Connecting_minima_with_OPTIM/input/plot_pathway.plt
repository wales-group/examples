# LJ38

# Plot the energy along the initial discrete path found by OPTIM

# Set plot parameters
se xla "Integrated path length"
se yla "Energy kcal/mol"
se tit "Initial discrete path between two tetra-ALA minima"
se grid
unset key

# Plot 'EofS' containing the energy as a function of the integrated path length
pl [:111.7][] 'EofS' w l lw 2 linecolor rgb "red"
