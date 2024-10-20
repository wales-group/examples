#Plots FPT from KMC data
import numpy as np
import matplotlib.pyplot as plt
import os.path as Path
plt.rcParams['text.usetex'] = True


KMCdata = []
with open("KMC.data", 'r') as KMCf:
    for line in KMCf.readlines():
        KMCdata.append(line.split())

KMCdata = np.array(KMCdata, dtype='float')
KMCdata = np.log(KMCdata)
plt.hist(KMCdata[:,1], bins=75, density=True, color=(0,71/255,171/255))




plt.xlabel(r"ln $ \theta$")
plt.ylabel(r"${\mathcal{P}}($ln $ \theta)$")
plt.tight_layout()
plt.savefig(f"9comm_KMC.png", format='png')
plt.show()
