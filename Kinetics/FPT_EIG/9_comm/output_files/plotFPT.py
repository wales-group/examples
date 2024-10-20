#Plots FPT from waitlnpdf data
import numpy as np
import matplotlib.pyplot as plt
import os.path as Path
plt.rcParams['text.usetex'] = True



FPTdata = []
with open("waitlnpdfAB.1.0000000000", 'r') as FPTf:
    for line in FPTf.readlines():
        FPTdata.append(line.split())
FPTdata = np.array(FPTdata, dtype='float')

plt.plot(FPTdata[:,0],FPTdata[:,1],color=(0,71/255,171/255))


plt.xlabel(r"ln $ \theta$")
plt.ylabel(r"${\mathcal{P}}($ln $ \theta)$")
plt.tight_layout()
plt.savefig(f"9comm_FPT.png", format='png')
plt.show()
