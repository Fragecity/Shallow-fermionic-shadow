import copy
import numpy as np

import randon_unitary as ru
from qiskit.quantum_info import Pauli


_, U = ru.random_FGUclifford(2, ret_unitary=True)
IX = Pauli("IX")

print(U @ IX.to_matrix() @ U.conj().T)
