import numpy as np
from qiskit import QuantumCircuit, transpile
from qiskit.quantum_info import Operator, DensityMatrix
from scipy.linalg import expm
from qiskit.visualization import plot_histogram
from qiskit_aer import Aer


def Z(theta):
    return np.array(
        [[np.exp(-1j * theta / 2), 0], [0, np.exp(1j * theta / 2)]], dtype="complex128"
    )


# two-qubit XX rotation
def XX(theta):
    return np.array(
        [
            [np.cos(theta / 2), 0, 0, -1j * np.sin(theta / 2)],
            [0, np.cos(theta / 2), -1j * np.sin(theta / 2), 0],
            [0, -1j * np.sin(theta / 2), np.cos(theta / 2), 0],
            [-1j * np.sin(theta / 2), 0, 0, np.cos(theta / 2)],
        ],
        dtype="complex128",
    )


# X gate
X = np.array([[0, 1], [1, 0]], dtype="complex128")

# Y gate
Y = np.array([[0, -1j], [1j, 0]], dtype="complex128")

# single-qubit identity
I = np.identity(2, dtype="complex128")


def gen_matchgate_sigma(n, perm, ret_unitary=True):
    ###transp = {(2j-1,2j),(2j,2j-1)}
    ###sign_Q in {0,1}^2n

    perm_Q = np.copy(perm[: 2 * n])
    sign_Q = np.copy(perm[2 * n :])

    dn = 2 * n
    transp = np.arange(1, dn + 1, dtype="int")
    nn_transp = []

    for i in range(1, dn):
        # j = np.random.randint(i,dn+1)
        j = perm_Q[i - 1]
        # print('(',i,j,')',perm_Q[i-1])
        mem = transp[i - 1]
        transp[i - 1] = transp[j - 1]
        transp[j - 1] = mem

        for k in range(j - i):
            nn_transp.append((i + k, i + k + 1))

        for k in range(j - i - 1):
            nn_transp.append((j - 2 - k, j - 1 - k))
    # print(transp,'\nperm:',perm_Q,nn_transp)
    transp = np.argsort(transp) + 1
    # print(transp)
    Q = np.identity(2 * n, dtype="float32")[:, transp - 1]
    if ret_unitary == True:

        unitary = np.identity(2**n, dtype="complex128")

        for i, j in enumerate(nn_transp):

            if (
                j[0] % 2 == 1
            ):  # Z-rotation by pi/2 on qubit j[0]//2, identity on all others (up to sign)

                if j[0] == 1:

                    gate = Y @ (Z(np.pi / 2))

                    for qubit in range(1, n):
                        gate = np.kron(gate, Z(np.pi))

                else:
                    gate = I

                    for qubit in range(1, j[0] // 2):
                        gate = np.kron(gate, I)

                    gate = np.kron(gate, Y @ (Z(np.pi / 2)))

                    for qubit in range(j[0] // 2 + 1, n):
                        gate = np.kron(gate, Z(np.pi))

                unitary = gate @ unitary

            else:  # XX-rotation by pi/2 on qubits j[0]//2-1 and j[0]//2, identity on all others (up to sign)

                if j[0] == 2:

                    gate = np.kron(X, Z(np.pi)) @ XX(np.pi / 2)

                    for qubit in range(2, n):
                        gate = np.kron(gate, Z(np.pi))

                else:
                    gate = I

                    for qubit in range(1, j[0] // 2 - 1):
                        gate = np.kron(gate, I)

                    gate = np.kron(gate, np.kron(X, Z(np.pi)) @ (XX(np.pi / 2)))

                    for qubit in range(j[0] // 2 + 1, n):

                        gate = np.kron(gate, Z(np.pi))

                unitary = gate @ unitary

        # signed permutations
    for i in range(1, 2 * n + 1):
        #        rand_number = np.random.randint(2)
        #        if rand_number == 1: # flip sign
        if sign_Q[i - 1] == 1:  # sign_Q in {0,1}^2n
            # print('sign_Q[',i-1,']=',sign_Q[i-1])
            Q[i - 1, :] *= -1

            if ret_unitary == True:

                if i % 2 == 1:  # apply Y to qubit i//2, Z to all subsequent qubits

                    if i == 1:
                        gate = Y

                        for qubit in range(1, n):
                            gate = np.kron(gate, Z(np.pi))

                    else:
                        gate = I

                        for qubit in range(1, i // 2):
                            gate = np.kron(gate, I)

                        gate = np.kron(gate, Y)

                        for qubit in range(i // 2 + 1, n):
                            gate = np.kron(gate, Z(np.pi))

                else:  # apply X to qubit i//2-1, Z to all subsequent qubits

                    if i == 2:
                        gate = X

                        for qubit in range(1, n):
                            gate = np.kron(gate, Z(np.pi))

                    else:
                        gate = I

                        for qubit in range(1, i // 2 - 1):
                            gate = np.kron(gate, I)

                        gate = np.kron(gate, X)

                        for qubit in range(i // 2, n):
                            gate = np.kron(gate, Z(np.pi))

                unitary = gate @ unitary

    if ret_unitary == True:
        return Q, unitary

    return Q


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


def random_FGUclifford(n, ret_unitary=False):
    """outputs uniformly random 2n*2n signed permutation matrix i.e. matchgate Clifford
    if ret_unitary is set to True, the n-qubit unitary is returned as well"""

    transp, nn_transp = random_transp(2 * n)

    Q = np.identity(2 * n, dtype="float32")[:, transp - 1]
    if ret_unitary == True:

        unitary = np.identity(2**n, dtype="complex128")

        for i, j in enumerate(nn_transp):

            if (
                j[0] % 2 == 1
            ):  # Z-rotation by pi/2 on qubit j[0]//2, identity on all others (up to sign)

                if j[0] == 1:

                    gate = Y @ (Z(np.pi / 2))

                    for qubit in range(1, n):
                        gate = np.kron(gate, Z(np.pi))

                else:
                    gate = I

                    for qubit in range(1, j[0] // 2):
                        gate = np.kron(gate, I)

                    gate = np.kron(gate, Y @ (Z(np.pi / 2)))

                    for qubit in range(j[0] // 2 + 1, n):
                        gate = np.kron(gate, Z(np.pi))

                unitary = gate @ unitary

            else:  # XX-rotation by pi/2 on qubits j[0]//2-1 and j[0]//2, identity on all others (up to sign)

                if j[0] == 2:

                    gate = np.kron(X, Z(np.pi)) @ XX(np.pi / 2)

                    for qubit in range(2, n):
                        gate = np.kron(gate, Z(np.pi))

                else:
                    gate = I

                    for qubit in range(1, j[0] // 2 - 1):
                        gate = np.kron(gate, I)

                    gate = np.kron(gate, np.kron(X, Z(np.pi)) @ (XX(np.pi / 2)))

                    for qubit in range(j[0] // 2 + 1, n):

                        gate = np.kron(gate, Z(np.pi))

                unitary = gate @ unitary

    # signed permutations
    for i in range(1, 2 * n + 1):
        if np.random.randint(2) == 1:  # flip sign

            Q[i - 1, :] *= -1

            if ret_unitary == True:

                if i % 2 == 1:  # apply Y to qubit i//2, Z to all subsequent qubits

                    if i == 1:
                        gate = Y

                        for qubit in range(1, n):
                            gate = np.kron(gate, Z(np.pi))

                    else:
                        gate = I

                        for qubit in range(1, i // 2):
                            gate = np.kron(gate, I)

                        gate = np.kron(gate, Y)

                        for qubit in range(i // 2 + 1, n):
                            gate = np.kron(gate, Z(np.pi))

                else:  # apply X to qubit i//2-1, Z to all subsequent qubits

                    if i == 2:
                        gate = X

                        for qubit in range(1, n):
                            gate = np.kron(gate, Z(np.pi))

                    else:
                        gate = I

                        for qubit in range(1, i // 2 - 1):
                            gate = np.kron(gate, I)

                        gate = np.kron(gate, X)

                        for qubit in range(i // 2, n):
                            gate = np.kron(gate, Z(np.pi))

                unitary = gate @ unitary

    if ret_unitary == True:
        return Q, unitary
    # np.conj(unitary).T

    return Q


def custom_Matrix_Add(matrix, circ, qubit_list, label="custom_gate"):
    # 将矩阵转换为 Qiskit 的 Operator 对象
    custom_gate = Operator(matrix)

    # 将自定义门应用到qubit_list的每个量子比特上
    circ.unitary(custom_gate, qubit_list, label=label)
    # print('add Completed!!!')

    # 返回添加操作完成后的量子线路
    return circ


def zig_zag_QuantumNet_Circ(qubit_num, depth, state):
    # 创建qubit_num个量子位的量子线路
    qc = QuantumCircuit(qubit_num, qubit_num)
    qc.initialize(state, range(qubit_num))
    U_lst = []
    # 添加 U_theta
    for j in range(depth):
        if j % 2 == 0:
            for i in range(qubit_num // 2):
                _, U = random_FGUclifford(2, ret_unitary=True)
                U_lst.append(U)
                qc = custom_Matrix_Add(
                    U, qc, [i * 2, i * 2 + 1], label="U{}".format((j, i + 1))
                )
        else:
            for i in range(qubit_num // 2 - 1):
                _, U = random_FGUclifford(2, ret_unitary=True)
                U_lst.append(U)
                qc = custom_Matrix_Add(
                    U, qc, [i * 2 + 1, i * 2 + 2], label="U{}".format((j, i + 1))
                )

    qc.measure(range(qubit_num), range(qubit_num))

    return qc, U_lst


def circuit_inverse(qubit_num, depth, b, U_lst):
    qc = QuantumCircuit(qubit_num)
    qc.initialize(b, range(qubit_num))

    counts = 0
    for j in range(depth):
        if j % 2 == (depth + 1) % 2:
            for i in range(qubit_num // 2 - 1, -1, -1):
                U = U_lst.pop()
                qc = custom_Matrix_Add(
                    U.conj().T,
                    qc,
                    [i * 2, i * 2 + 1],
                    label="U{}".format((j, i + 1, counts)),
                )
                counts += 1
        else:
            for i in range(qubit_num // 2 - 2, -1, -1):
                U = U_lst.pop()
                qc = custom_Matrix_Add(
                    U.conj().T,
                    qc,
                    [i * 2 + 1, i * 2 + 2],
                    label="U{}".format((j, i + 1, counts)),
                )
                counts += 1

    return qc


def random_state(n):
    dim = 2**n
    psi = np.random.rand(dim) + 1j * np.random.rand(dim)
    psi /= np.linalg.norm(psi)
    return psi
