import copy, math, pickle
from itertools import combinations
from scipy.special import comb
import numpy as np

from qiskit_aer import Aer
from qiskit.quantum_info import Pauli
from qiskit.primitives import StatevectorEstimator
from qiskit import transpile, QuantumCircuit

import randon_unitary as ru


def random_match_circuit(qubit_num, depth, state, observable, shots):

    # state = ru.random_state(qubit_num)
    circ, U_lst = ru.zig_zag_QuantumNet_Circ(qubit_num, depth, state)

    simulator = Aer.get_backend("qasm_simulator")
    # state_simulator = Aer.get_backend("statevector_simulator")
    expval_simulator = StatevectorEstimator()

    compiled_circuit = transpile(circ, simulator)
    counts = simulator.run(compiled_circuit, shots=shots).result().get_counts()

    expval = 0

    for b in counts:
        frequency = counts[b] / shots
        U_lst_copy = copy.deepcopy(U_lst)
        circ_inv = ru.circuit_inverse(qubit_num, depth, b, U_lst_copy)
        data = expval_simulator.run([(circ_inv, observable)]).result()[0].data
        expval += frequency * data.evs
    return expval


def expval_theory(qubit_num, state, observable):
    expval_simulator = StatevectorEstimator()
    qc = QuantumCircuit(qubit_num)
    qc.initialize(state)
    data = expval_simulator.run([(qc, observable)]).result()[0].data
    return data.evs


def experiment(qubit_num, depth, state, observable, sample_num, shots=1):
    data = []
    for _ in range(sample_num):
        data.append(random_match_circuit(qubit_num, depth, state, observable, shots))

    return np.mean(data)


def alpha_L_k2(i, j, d, n, k_max=4):
    i, j = (i - 1) // 4 + 1, (j - 1) // 4 + 1
    a = abs(i - j)
    b = i + j - 1

    alpha = 0
    for k in range(-k_max, k_max + 1):
        term1 = np.exp(-((k * n + a) ** 2) / (d - 1))
        term2 = np.exp(-((k * n + b) ** 2) / (d - 1))
        alpha += term1 + term2

    alpha *= 1 / np.sqrt(4 * np.pi * (d - 1))

    return alpha


def pair_partition(S):
    if len(S) == 2:
        return [[(S[0], S[1])]]
    else:
        res = []
        for i in range(1, len(S)):
            pair = (S[0], S[i])
            rest = [x for x in S if x not in pair]
            rest_partition = pair_partition(rest)
            for partition in rest_partition:
                res.append([pair] + partition)
        return res


def alpha_k(S, d, n, k_max=3):

    pairings = pair_partition(S)
    normalizing_factor = 1 / np.prod(range(1, len(S), 2))  # prod(1:2:length(S)-1)
    k = len(S) // 2
    c = n**k * comb(n, k, exact=True) / comb(2 * n, 2 * k, exact=True)
    total = 0

    for partition in pairings:
        product = 1
        for i, j in partition:
            product *= alpha_L_k2(i, j, d, n, k_max)
        total += product

    return c * normalizing_factor * total


def run(qubit_num, depth, state, operator, samples, alpha_Sd, shots=4):
    means = []
    variances = []
    # samples = [16, 32, 64, 128, 256, 300, 500]
    for sample_num in samples:
        one_exper_means = []
        for _ in range(16):
            exper_mean = experiment(
                qubit_num, depth, state, operator, sample_num, shots
            )
            one_exper_means.append(exper_mean / alpha_Sd)
            # variances.append(exper_var)
        means.append(np.mean(one_exper_means))
        variances.append(np.var(one_exper_means))
    thm_mean = expval_theory(qubit_num, state, operator)

    with open("data_n={}_d={}.pkl".format(qubit_num, depth), "wb") as f:
        pickle.dump((means, variances, thm_mean), f)

    return means, variances, thm_mean


def FCS(qubit_num, state, operator, k, sample_num, shots=4):

    simulator = Aer.get_backend("qasm_simulator")
    expval_simulator = StatevectorEstimator()

    expval_lst = []
    for _ in range(sample_num):
        qc = QuantumCircuit(qubit_num)
        qc.initialize(state)
        _, U = ru.random_FGUclifford(qubit_num, True)
        ru.custom_Matrix_Add(U, qc, range(qubit_num))
        qc.measure_all()
        counts = simulator.run(qc, shots=shots).result().get_counts()

        expval = 0

        for b in counts:
            frequency = counts[b] / shots

            qc2 = QuantumCircuit(qubit_num)
            qc2.initialize(b)
            ru.custom_Matrix_Add(U.conj().T, qc2, range(qubit_num))

            data = expval_simulator.run([(qc2, operator)]).result()[0].data
            expval += frequency * data.evs
        expval_lst.append(expval)

    return np.mean(expval_lst)


def run_FCS(qubit_num, state, operator, samples, k, shots=4):
    means = []
    variances = []
    alpha_Sd = math.comb(qubit_num, k) / math.comb(2 * qubit_num, 2 * k)

    for sample_num in samples:
        one_exper_means = []
        for _ in range(16):
            exper_mean = FCS(qubit_num, state, operator, k, sample_num, shots)
            one_exper_means.append(exper_mean / alpha_Sd)
            # variances.append(exper_var)
        means.append(np.mean(one_exper_means))
        variances.append(np.var(one_exper_means))

    with open("data_FCS_n={}_d={}.pkl".format(qubit_num, depth), "wb") as f:
        pickle.dump((means, variances), f)

    return means, variances


if __name__ == "__main__":
    # import matplotlib.pyplot as plt
    # import pickle

    # qubit_num = 8
    # depth = 1
    # shots = 16
    # alpha_Sd = 0.012345679012345678
    # state = ru.random_state(qubit_num)
    # operator = Pauli("IZZIXYIZ")
    # k = 4
    # samples = [100, 200, 350, 500, 1000, 2000, 4000]

    # our_mean, our_var, thm_expval = run(
    #     qubit_num, depth, state, operator, samples, alpha_Sd, shots
    # )
    # FCS_mean, FCS_var = run_FCS(qubit_num, state, operator, samples, k, shots)

    S = [1, 2, 3, 4]
    n = 10
    d = 3
    # print(pair_partition(S))
    alpha = alpha_k(S, d, n)
    print("计算结果：", alpha)
