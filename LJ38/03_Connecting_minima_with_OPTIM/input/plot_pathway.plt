# LJ38

# Plot the progress of the LJ38 basin-hopping run

# Set plot parameters
se xla "Integrated path length"
se yla "Energy"
se tit "Initial discrete path between two LJ38 minima"
se grid

# Plot 'best' (current lowest energy), 'markov' (energy of structure in Markov chain) and 'energy' (energy of each quench)
pl [:20.5][] 'EofS' w l lw 2 linecolor rgb "red"
