import copy, math, pickle
from itertools import combinations
from collections import namedtuple
from scipy.special import comb
import numpy as np
import pandas as pd
from datetime import datetime

from qiskit_aer import Aer
from qiskit.quantum_info import Pauli
from qiskit.quantum_info import Statevector, Operator
from qiskit.primitives import StatevectorEstimator
from qiskit import transpile, QuantumCircuit

import randon_unitary as ru
from experiment import alpha_k
import Pauli as p

Hamiltonian = namedtuple("Hamiltonian", ["groups", "coefficients"])


# def KiteavChain_hamiltonian_group1(qubit_num):
#     return [[2 * j, 2 * j - 1] for j in range(1, qubit_num + 1)]


# def KiteavChain_hamiltonian_group2(qubit_num):
#     return [[2 * j, 2 * j + 1] for j in range(1, qubit_num)]


# def KiteavChain_hamiltonian_group3(qubit_num):
#     return [[2 * j + 2, 2 * j - 1] for j in range(1, qubit_num)]


def KiteavChain_hamiltonian(qubit_num, mu, delta, t):
    group1 = [[2 * j, 2 * j - 1] for j in range(1, qubit_num + 1)]
    group2 = [[2 * j, 2 * j + 1] for j in range(1, qubit_num)]
    group3 = [[2 * j + 2, 2 * j - 1] for j in range(1, qubit_num)]
    return Hamiltonian(
        [group1, group2, group3], [mu / 2, -(delta + t) / 2, -(delta - t) / 2]
    )


def random_match_circuit(qubit_num, depth, state):

    circ, U_lst = ru.zig_zag_QuantumNet_Circ(qubit_num, depth, state)

    simulator = Aer.get_backend("qasm_simulator")
    counts = simulator.run(circ, shots=1).result().get_counts()

    return list(counts.keys())[0], U_lst


def calculate_expectation_value(qubit_num, depth, b_lst, U_lst_lst, obs):
    expval_simulator = StatevectorEstimator()
    expectation_value = 0

    for b, U_lst in zip(b_lst, U_lst_lst):
        # Create the combined unitary UUi using the function f
        U_lst_copy = copy.deepcopy(U_lst)
        circ_inv = ru.circuit_inverse(qubit_num, depth, b, U_lst_copy)
        data = expval_simulator.run([(circ_inv, obs)]).result()[0].data
        expectation_value += data.evs
    expectation_value = expectation_value / len(b_lst)

    return expectation_value


def random_whole_matchgroup(qubit_num, state):

    simulator = Aer.get_backend("qasm_simulator")
    qc = QuantumCircuit(qubit_num)
    qc.initialize(state)
    _, U = ru.random_FGUclifford(qubit_num, True)
    ru.custom_Matrix_Add(U, qc, range(qubit_num))
    qc.measure_all()
    counts = simulator.run(qc, shots=1).result().get_counts()

    return list(counts.keys())[0], U


def calculate_expectation_value_FCS(qubit_num, b_lst, U_lst, obs):
    expval_simulator = StatevectorEstimator()
    expectation_value = 0

    for b, U in zip(b_lst, U_lst):
        # Create the combined unitary UUi using the function f
        qc2 = QuantumCircuit(qubit_num)
        qc2.initialize(b)
        # circ_inv = ru.circuit_inverse(qubit_num, depth, b, U_lst_copy)
        ru.custom_Matrix_Add(U.conj().T, qc2, range(qubit_num))
        data = expval_simulator.run([(qc2, obs)]).result()[0].data
        expectation_value += data.evs
    expectation_value = expectation_value / len(b_lst)

    return expectation_value


def jordan_wigner_gamma(k, n_qubits):
    if k < 1:
        raise ValueError("Index k must be a positive integer.")

    # Determine whether k is odd or even
    j = (k + 1) // 2  # Calculate the j value corresponding to k

    # Initialize the Pauli string
    pauli_string = ["I"] * n_qubits

    # Apply the Jordan-Wigner transformation
    for i in range(j - 1):  # Add Z terms for indices < j
        pauli_string[i] = "Z"
    if k % 2 == 1:  # If k is odd (2j-1), add X at position j
        pauli_string[j - 1] = "X"
    else:  # If k is even (2j), add Y at position j
        pauli_string[j - 1] = "Y"

    return "".join(pauli_string)


def gammaS_2_pauli_F2(S, qubit_num):
    res = [0] * (2 * qubit_num)
    for k in S:
        pauli_string = p.transform_pauli_string(jordan_wigner_gamma(k, qubit_num))
        pauli_F2 = p.pauli_string_to_F2(pauli_string)
        res = p.mod2_add(res, pauli_F2)
    return res
    # jordan_wigner_gamma_lst.append(jordan_wigner_gamma(k, qubit_num))


def ADFCS_expval(qubit_num, depth, state, hamiltonian: Hamiltonian, shots):
    b_lst = []
    U_lst_lst = []

    for _ in range(shots):
        b, U_lst = random_match_circuit(qubit_num, depth, state)
        b_lst.append(b)
        U_lst_lst.append(U_lst)

    # results = dict()
    results_ADFCS = 0

    for group, coeff in zip(hamiltonian.groups, hamiltonian.coefficients):
        expval_group = 0
        for obs in group:
            operator = p.pauli_F2_to_string(gammaS_2_pauli_F2(obs, qubit_num))
            operator = p.transform_pauli_string_x2X(operator)
            operator = Pauli(operator)

            expval_group += calculate_expectation_value(
                qubit_num, depth, b_lst, U_lst_lst, operator
            ) / alpha_k(obs, depth, qubit_num)
        results_ADFCS += coeff * expval_group

    return results_ADFCS


def FCS_expval(qubit_num, state, hamiltonian: Hamiltonian, shots):
    b_match_lst = []
    U_match_lst = []

    for _ in range(shots):
        b_match, U_match = random_whole_matchgroup(qubit_num, state)
        b_match_lst.append(b_match)
        U_match_lst.append(U_match)

    results_FCS = 0
    alpha = alpha_k(hamiltonian.groups[0][0], qubit_num**2 * 20, qubit_num)
    for group, coeff in zip(hamiltonian.groups, hamiltonian.coefficients):
        expval_group = 0
        for obs in group:
            operator = p.pauli_F2_to_string(gammaS_2_pauli_F2(obs, qubit_num))
            operator = p.transform_pauli_string_x2X(operator)
            operator = Pauli(operator)
            expval_group += calculate_expectation_value_FCS(
                qubit_num, b_match_lst, U_match_lst, operator
            )
        results_FCS += coeff * expval_group
    return results_FCS / alpha


def moments_of_random_var(func, *args, repeat_num=32):
    """
    Calculate the mean and standard deviation of a random variable.

    Parameters:
    func (callable): A function that generates a random variable.
    *args: Arguments to pass to the function `func`.
    repeat_num (int, optional): The number of times to repeat the experiment. Default is 32.

    Returns:
    tuple: A tuple containing the mean and standard deviation of the results.
    """
    """ """
    results = []
    for _ in range(repeat_num):
        results.append(func(*args))
    return np.mean(results), np.var(results)


def expval_theory(qubit_num, state, hamiltonian: Hamiltonian):
    res = 0

    for group, coeff in zip(hamiltonian.groups, hamiltonian.coefficients):
        expval_group = 0
        for obs in group:
            operator = p.pauli_F2_to_string(gammaS_2_pauli_F2(obs, qubit_num))
            operator = p.transform_pauli_string_x2X(operator)
            operator = Pauli(operator)
            expval_simulator = StatevectorEstimator()
            qc = QuantumCircuit(qubit_num)
            qc.initialize(state)
            data = expval_simulator.run([(qc, operator)]).result()[0].data
            expval_group += data.evs
        res += coeff * expval_group
    return res


def run_experiment(
    qubit_num, depth_lst, sample_lst, repeat_num=32, mu=1.5, delta=0.5, t=0.1
):
    state = ru.random_state(qubit_num)
    hamiltonian = KiteavChain_hamiltonian(qubit_num, mu, delta, t)
    FCS_mean = []
    FCS_var = []
    ADFCS_mean = [list() for _ in range(len(depth_lst))]
    ADFCS_var = [list() for _ in range(len(depth_lst))]

    for shots in sample_lst:

        mean, var = moments_of_random_var(
            FCS_expval, qubit_num, state, hamiltonian, shots, repeat_num=repeat_num
        )
        FCS_mean.append(mean)
        FCS_var.append(var)

        for i, depth in enumerate(depth_lst):
            mean, var = moments_of_random_var(
                ADFCS_expval,
                qubit_num,
                depth,
                state,
                hamiltonian,
                shots,
                repeat_num=repeat_num,
            )
            ADFCS_mean[i].append(mean)
            ADFCS_var[i].append(var)
    data = {"samles": sample_lst, "FCS_mean": FCS_mean, "FCS_var": FCS_var}

    for i in range(len(depth_lst)):
        data[f"mean_d={depth_lst[i]}"] = ADFCS_mean[i]
        data[f"var_d={depth_lst[i]}"] = ADFCS_var[i]
    df = pd.DataFrame(data)

    theory = expval_theory(qubit_num, state, hamiltonian)
    df.attrs["theory"] = theory

    now = datetime.now()
    date_time_str = now.strftime("%Y-%m-%d_%H-%M")
    filename = f"./data/data_{date_time_str}.csv"

    # 保存 DataFrame 到 CSV 文件
    df.to_csv(filename, index=False)
    return df


# Example usage
if __name__ == "__main__":
    import experiment

    qubit_num = 8
    sample_lst = [1]
    depth_lst = [3, 5, 7, 11]

    print(run_experiment(qubit_num, depth_lst, sample_lst))
    now = datetime.now()
    date_time_str = now.strftime("%d_%H-%M")
    print(date_time_str)
