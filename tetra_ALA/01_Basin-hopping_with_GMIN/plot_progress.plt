# LJ38

# Plot the progress of the LJ38 basin-hopping run

# Set plot parameters
se xla "Basin-hopping step"
se yla "Energy / kcal/mol"
se tit "Progress of tetra-ALA basin-hopping run"
set key below
se grid

# Plot 'best' (current lowest energy), 'markov' (energy of structure in Markov chain) and 'energy' (energy of each quench)
pl [][:-37] 'best' w l lw 2 linecolor rgb "red", \
   'markov' w l lw 2 linecolor rgb "blue", \
   'energy' w l lw 0.5 linecolor rgb "black"
