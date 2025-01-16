from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator
import numpy as np

extended_stabilizer_simulator = AerSimulator(method='extended_stabilizer')

def build_circuit():
    pass

def random_transp(n):
    """returns a random permutation of the numpy array [1,...,n], and also a decomposition into nearest-neighbour transpositions (list of 2-tuples)"""

    transp = np.arange(1, n + 1, dtype="int")
    nn_transp = []

    # Fisher–Yates shuffle
    for i in range(1, n):
        j = np.random.randint(i, n + 1)

        mem = transp[i - 1]

        transp[i - 1] = transp[j - 1]
        transp[j - 1] = mem

        for k in range(j - i):
            nn_transp.append((i + k, i + k + 1))

        for k in range(j - i - 1):
            nn_transp.append((j - 2 - k, j - 1 - k))

    transp = np.argsort(transp) + 1
    return transp, nn_transp

# def perm_to_FGU()