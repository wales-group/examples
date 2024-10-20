import numpy as np
import sys

# Finds "trapping basins" within the energy landscape
# Requires four input parameters
# The parameters must agree with the node numbers file generated from disconnectionDPS
# Make sure the node numbers file doesn't contain empty levels at the bottom
# NOTE: Set FIRST and MAXTSENERGY to the same value. This code hasn't been tested for when they are different
trap_energy = float(sys.argv[1]) #trapping energy
num_levels = int(sys.argv[2]) #number of energy levels in the disconnectivity plot
delta_level = float(sys.argv[3]) #energy difference between energy levels 
maxE = float(sys.argv[4])#Maximum energy of disconnectivity plot

'''
Reads in first column (energy) of min.data
mfile: min.data file
returns: array of energies
'''
def get_Emin(mfile):
    min_file = open(mfile)
    Emin = []
    for line in min_file:
        array_line = np.array(line.split(), dtype=float)
        Emin.append(array_line[0])
    Emin = np.array(Emin)
    return Emin

'''
Reads in disconnectivity graph data and converts to an array
For each coarse grained energy level, the node of each minimum is stored as the data in the array
Minima are in the same node if they are connected at that energy level
Inputs:
fname: node_numbers file (output txt style data from disconnectionDPS)
num_min: Number of minima
num_levels: Number of energy levels in disconnectivity plot
returns
min_pos: array version of disconnectivity plot
'''
def get_energy_levels(fname, num_min, num_levels):
    min_pos = -1*np.ones((num_levels, num_min))#If minima doens't exist at set energy level, value set to -1

    #frames = list()
    traj_file = open(fname)
    EI=0#The energy level number currently being read in
    NI=0#The node number currently being read in
    #frame = list()
    NODE_LEVEL=False
    LEVEL_LINE=False
    line_num=0
    for line in traj_file:
        line_num += 1
        if line =="\n": #The next line is either a new node or a new level
            NODE_LEVEL=True
        elif NODE_LEVEL:
            try:
                array_line = np.array(line.split(), dtype=str)
                if array_line[0]=="LEVEL":
                    LEVEL_LINE=True
                    EI = int(array_line[1])
                elif array_line[0]=="Node":
                    NI = int(array_line[1])
                else:
                    Exception("Incorrect line read " + str(line_num))
                NODE_LEVEL=False
            except:
                print("NOT A STRING LINE " + str(line_num))
        elif LEVEL_LINE==True:
            LEVEL_LINE=False
        else: #Should contain 1 number, the minima that is in node NI of energy level EI
            array_line = np.array(line.split(), dtype=int)
            min_pos[EI-1][array_line[0]-1] = NI


    traj_file.close()
    return min_pos

'''
Computes lowest transition state energy that directly or indirectly connects minA and minB
input: min_pos computed from get_energy_levels
min.A and min.B: 1st indexed minima values
returns the energy level number (not the energy itself)
'''
def low_energy_level(min_pos, minA, minB):
    num_levels = len(min_pos[:,0])
    for level in range(num_levels, 0, -1):
        nodeA=min_pos[level-1][minA-1]
        nodeB=min_pos[level-1][minB-1]
        if nodeA != -1 and nodeA==nodeB:
            #-1 means energy level is lower than minima energy
            #nodeA==nodeB at the lowest energy where minA and minB are connected
            return level

'''
Computes the absolute energy difference between:
minA and the lowest transition state (in)directly connecting to minB: ELTSBA
minB and the lowest transition state (in)diretly connecting to minA: ELTSAB
input:
elevelAB: low_energy_level() output
minA and minB: 1st indexed minima indexes
delta: energy gap between energy levels in disconnectivity plot
Emin: array of minima energies from min.data
EFIRST: Maximum energy on disconnectivity plot
outputs: ELTSAB and ELTSBA
'''
def energy_level_to_energy(elevelAB, minA, minB, delta, Emin, EFIRST):
    ELTSAB = EFIRST-elevelAB*delta - Emin[minB-1]
    ELTSBA = EFIRST-elevelAB*delta - Emin[minA-1]
    return ELTSAB, ELTSBA

'''
Sorts Emin to be from index order to being in energy order, with the lowest energy first
input:
Emin: array of minima energies from min.data
returns:
min_sorted: list of minima indexed from 1, listed in lowest energy order'''
def min_energy_order(Emin):
    Emin_sorted = sorted(zip(Emin, np.arange(1,len(Emin)+1)), key=lambda x: x[0]) #lowest energy level first
    Emin_sorted = np.array(Emin_sorted)
    min_sorted = np.array(Emin_sorted[:,1], dtype=int)
    return min_sorted


'''
Reads in ts.data connections and energies
Input: tsname is a ts.data file
returns:
conns: dictionary of connections for each minima.
       key: minima
       value: list of minima connected to the key minima
energies: dictionary of connection energy for each connection
       key: lowest energy minima index - highest energy minima index
       value: transition state energy
'''
def get_connections(tsname):
    ts_file = open(tsname)
    conns = {}
    energies = {}
    for line in ts_file:
        array_line = np.array(line.split(), dtype=float)
        minA = int(array_line[3])
        minB = int(array_line[4])
        TSE = float(array_line[0]) #transition state energy
        if minA in conns:
            conns[minA].append(minB)
        else:
            conns[minA] = [minB]
        if minB in conns:
            conns[minB].append(minA)
        else:
            conns[minB] = [minA]
        if minA<minB:
            energies[str(minA) + "-" + str(minB)]=TSE
        else:
            energies[str(minB) + "-" + str(minA)]=TSE

    return conns, energies



###########################
#Define the trapping energy
#By manually looking at disconnectivity plot
trap_energy = float(sys.argv[1]) #trapping energy
num_levels = int(sys.argv[2]) #number of energy levels in the disconnectivity plot
delta_level = float(sys.argv[3]) #energy difference between energy levels 
maxE = float(sys.argv[4])#Maximum energy of disconnectivity plot

#Read in all energy minima, and sort by energy
Emin = get_Emin("min.data")
num_min = len(Emin)
min_sorted = min_energy_order(Emin)

#Read in disconnectivity graph as an array
tree_pos = get_energy_levels("node_numbers", num_min, num_levels)

#Define trapping set
trap_min = [min_sorted[0]] #The global minima of each trap, initially just contains the global minimum
ELTS = {}
traps = {}
traps[min_sorted[0]]=[1]
ELTS[traps[trap_min[0]][0]]=maxE

#Also need to add a new ELTS (low energy transition state that connects trap A to B)
for m in min_sorted[1:]:
    #Determine what trap this minima is in
    #Find lowest energy barrier to all minima in trapping set trap_min
    TRAP = False
    INTRAP = False
    in_traps = []
    for tm in trap_min:
        LElevel = low_energy_level(tree_pos, tm , m)
        ELTSAB, ELTSBA = energy_level_to_energy(LElevel, tm, m, delta_level, Emin, maxE)
        if ELTSBA<trap_energy:
            #m is in trap tm
            in_traps.append(traps[tm][0])
            INTRAP=True
            continue
        elif ELTSAB>trap_energy:
            # m is a global minimum of a trap
            TRAP=True
            continue
        if ELTSBA < (ELTS[traps[tm][0]]-Emin[tm-1]):
            #m is in trap tm
            in_traps.append(traps[tm][0])
            INTRAP=True
    if INTRAP != True :
        #m isn't in any of the current trapping minima
        if TRAP==True:#m is a global minimum of a trap
            trap_min.append(m)
            in_traps.append(len(trap_min))
            #Also need to add a new ELTS (low energy transition state that connects trap A to B)
            #And need to update as required all other ELTS
            traps[m]=in_traps
            for tmA in trap_min:
                ELTSA = maxE # Max value ELTSA can be
                for tmB in trap_min:
                    if tmA != tmB:
                        ELTSA_tm = maxE-delta_level*low_energy_level(tree_pos, tmA , tmB)
                        if ELTSA_tm < ELTSA:
                            ELTSA = ELTSA_tm
                ELTS[traps[tmA][0]]=ELTSA
        else:#m isn't in a trap
            in_traps.append(0)
    traps[m]=in_traps
num_traps = len(trap_min)
num_traps2 = num_traps


#Find what minima to keep
kept_min = []

def get_trap_string(ts):
    #print("ts " + str(ts))
    #print("type " + str(type(ts)))
    ots = sorted(ts)
    ts =""
    for t in ots:
        ts += str(t)
    return ts

trap_index = {} #index of all the traps. Required for minima that belong to more than one trap - this is defined as a separate trap.
#i.e. minima that are in trap 1 and trap 2 are defined to being in a separate trap for the purposes of deciding what minima to keep.


#Saving trap global minima to file
np.savetxt("globmin.txt", trap_min, fmt='%10.d')

#Create list of minima in each trap
comms = {}
for m in range(1, num_min+1):
    if traps[m][0] in comms:
        comms[traps[m][0]].append(m)
    else:
        comms[traps[m][0]]=[m]
for t in range(1, num_traps+1):
    np.savetxt("t" + str(t) + ".txt", comms[t], fmt='%10.d')









