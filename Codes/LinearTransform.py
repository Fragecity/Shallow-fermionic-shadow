from itertools import product
from collections import namedtuple
from functools import reduce

import numpy as np
from scipy.linalg import expm
import tensornetwork as tn
import copy

from U2representation import get_U_2fold
from QCompTool.Gates import X, Y, Z, pauli_map_mat
from QCompTool.Math import dagger, tensor

T = get_U_2fold()
T_tensor = T.tensor
Mat_info = namedtuple("MatInfo", ("Matrix", "eig_values", "eig_vectors"))


def pauli_lst(num_bits):
    p_lst = []
    for idx in product(range(4), repeat=num_bits):
        mats = []
        for i in idx:
            mats.append(pauli_map_mat[i])
        P = tensor(mats)
        p_lst.append(P)
    return p_lst


def fst_mat(i, j):
    return T_tensor[:, i, :, j]


def all_fst_mat():
    all_mat = []
    for i, j in product(range(4), repeat=2):
        all_mat.append(fst_mat(i, j))
    return all_mat


def all_fst_mat_dict():
    all_mat = dict()
    for i, j in product(range(4), repeat=2):
        mat = fst_mat(i, j)
        eigvals, eigvecs = np.linalg.eig(mat)
        all_mat[(i, j)] = Mat_info(mat, eigvals, eigvecs)
    return all_mat


def gener_A(theta) -> tn.Node:
    generator = 0
    num_qubits = 2

    p_lst = pauli_lst(num_qubits)
    thetas = [0]
    thetas.extend(theta)
    for t, p in zip(thetas, p_lst):
        generator = generator + t * p
    mat = expm(1j * generator)
    return tn.Node(mat, "A")


def gener_A_dagger(theta) -> tn.Node:
    generator = 0
    num_qubits = 2

    p_lst = pauli_lst(num_qubits)
    thetas = [0]
    thetas.extend(theta)
    for t, p in zip(thetas, p_lst):
        generator = generator + t * p
    mat = expm(1j * generator)

    mat = dagger(mat)
    return tn.Node(mat, "A_dag")


def transform_T(theta):
    A_up = gener_A(theta)
    A_down = copy.deepcopy(A_up)
    A_dag_up = gener_A_dagger(theta)
    A_dag_down = copy.deepcopy(A_dag_up)
    T = get_U_2fold()

    A_dag_up[1] ^ T[0]
    A_dag_down[1] ^ T[1]
    A_up[0] ^ T[2]
    A_down[0] ^ T[3]

    T_trans = tn.contractors.optimal(
        [A_up, A_down, A_dag_up, A_dag_down, T],
        [A_dag_up[0], A_dag_down[0], A_up[1], A_down[1]],
    )

    return T_trans


if __name__ == "__main__":
    theta = np.zeros(15)
    trans_T = transform_T(theta)
    # res = all_fst_mat_dict()

    # for item in res:
    #     print()
    #     print(str(item) + ":")
    #     print("eigen values are:")
    #     print(res[item].eig_values)
    #     print("eigen vectors are:")
    #     print(res[item].eig_vectors)
