from itertools import product
from collections import Counter

# from functools import cache

import numpy as np
import matplotlib.pyplot as plt
import tensornetwork as tn

from QCompTool.Pauli import number


def alpha_distribution(d, n) -> list:
    alpha_lst = []
    for S in product(range(4), repeat=n):
        alpha_lst.append(alpha(S, d, n))

    return alpha_lst


def alpha(S, d, n) -> number:
    init_state = ket0_node(n)
    layer_lst = get_layers(n, d)
    connected_edges = []

    edges = connect_state(init_state, layer_lst[0], n, "in")
    connected_edges.extend(edges)

    for l in range(1, d):
        # print(f"here we connect layer {l}")
        connected_edges.extend(connect_layer(layer_lst[l - 1], layer_lst[l], n))

    gammaS = out_ket_node(n, S)
    connected_edges.extend(connect_state(gammaS, layer_lst[-1], n, "out"))

    # print(connected_edges)
    # for edge in connected_edges:
    #     alp = tn.contract(edge)

    # if alp.tensor < 0:

    all_nodes = [init_state]
    for layer in layer_lst:
        all_nodes.extend(layer)
    all_nodes.append(gammaS)
    alp = tn.contractors.optimal(all_nodes)

    return alp.tensor


def connect_state(state_node, layer: list, n: int, direction: str = "in"):
    connected_edges = []

    left_edges = []
    right_edges = []
    for i in range(n):
        left_edges.append(state_node[i])
    for node in layer:
        right_edges.extend(_get_edge(node, direction))

    if direction == "out":
        left_edges, right_edges = right_edges, left_edges

    for edge1, edge2 in zip(left_edges, right_edges):
        connected_edges.append(edge1 ^ edge2)

    return connected_edges


def connect_layer(layer_front: list, layer_behind: list, n: int) -> list[tn.Edge]:
    connected_edges = []

    left_edges = []
    right_edges = []
    for node in layer_front:
        left_edges.extend(_get_edge(node, "out"))
    for node in layer_behind:
        right_edges.extend(_get_edge(node, "in"))

    for edge1, edge2 in zip(left_edges, right_edges):
        connected_edges.append(edge1 ^ edge2)

    return connected_edges


def _get_edge(node: tn.Node, direct) -> list[tn.Edge]:
    if len(node.edges) == 4:
        if direct == "in":
            edges = [node[0], node[1]]
        elif direct == "out":
            edges = [node[2], node[3]]
    elif len(node.edges) == 2:
        if direct == "in":
            edges = [node[0]]
        elif direct == "out":
            edges = [node[1]]
    return edges


def get_layers(n: int, d: int) -> list[list]:
    layer_lst = [None] * d
    for l in range(d):
        if l % 2 == 0:
            layer_lst[l] = layer_odd(n, d)
        else:
            layer_lst[l] = layer_even(n, d)
    return layer_lst


def layer_odd(n: int, d: int) -> list[tn.Node]:
    num_T = n // 2
    delta = (n + 1) // 2 - num_T
    T_layer = []
    for i in range(num_T):
        T = get_U_2fold()
        T.set_name(f"T_{d, i}")
        T[0].set_name(f"T_{d, i}_in_0")
        T[1].set_name(f"T_{d, i}_in_1")
        T[2].set_name(f"T_{d, i}_out_0")
        T[3].set_name(f"T_{d, i}_out_1")
        T_layer.append(T)

    T_layer = T_layer + [tn.Node(np.eye(4))] * delta
    return T_layer


def layer_even(n: int, d: int) -> list[tn.Node]:
    num_T = (n - 1) // 2
    delta = n // 2 - num_T

    T_layer = []
    for i in range(num_T):
        T = get_U_2fold()
        T.set_name(f"T_{d, i}")
        T[0].set_name(f"T_{d, i}_in_0")
        T[1].set_name(f"T_{d, i}_in_1")
        T[2].set_name(f"T_{d, i}_out_0")
        T[3].set_name(f"T_{d, i}_out_1")
        T_layer.append(T)

    T_layer = [tn.Node(np.eye(4))] + T_layer + [tn.Node(np.eye(4))] * delta

    return T_layer


def get_U_2fold() -> tn.Node:
    U = np.zeros((4, 4, 4, 4))

    U[0, 0, 0, 0] = 1

    k1_lst = [(0, 1), (0, 2), (1, 3), (2, 3)]
    k2_lst = [(0, 3), (1, 1), (1, 2), (2, 1), (2, 2), (3, 0)]
    k3_lst = [(1, 0), (2, 0), (3, 1), (3, 2)]

    _fill_symmetry_mat(U, k1_lst, 1 / 4)
    _fill_symmetry_mat(U, k2_lst, 1 / 6)
    _fill_symmetry_mat(U, k3_lst, 1 / 4)

    U[3, 3, 3, 3] = 1

    return tn.Node(U)


def split_U2(truncate) -> tuple[tn.Node, tn.Node]:
    T = get_U_2fold()
    T_up, T_down, error = tn.split_node(
        T,
        left_edges=[T[0], T[2]],
        right_edges=[T[1], T[3]],
        max_truncation_err=truncate,
    )
    return T_up, T_down, error


def ket0_node(n: int) -> tn.Node:
    shape = [4] * n
    data = np.zeros(tuple(shape))
    for idx in product((0, 3), repeat=n):
        data[idx] = 1 / 2**n

    ket0 = tn.Node(data)
    ket0.set_name("ket0")
    for i in range(len(ket0.edges)):
        ket0[i].set_name(f"ket0_{i}")
        # print(ket0[i].name)
    return ket0


def out_ket_node(n: int, S: tuple) -> tn.Node:
    shape = [4] * n
    data = np.zeros(tuple(shape))
    data[S] = 1

    out_ket_node = tn.Node(data)
    out_ket_node.set_name("out_ket")
    for i in range(len(out_ket_node.edges)):
        out_ket_node[i].set_name(f"out_ket_{i}")
    return tn.Node(data)


def _fill_symmetry_mat(Mat: np.array, idx_lst: list, fill_num: number) -> None:
    for input, output in product(idx_lst, repeat=2):
        Mat[input[0], input[1], output[0], output[1]] = fill_num


def get_distribution(lst: list, section=[0, 1], num_points=64) -> list:
    distribution = []
    segment = (section[1] - section[0]) / num_points
    for i in range(num_points):
        seg_beg = i * segment
        seg_end = (i + 1) * segment
        count = 0
        for item in lst:
            if seg_beg <= item < seg_end:
                count += 1
        distribution.append(count / num_points)
    return distribution


def plot_fig(n, d, sec_end=None, num_points=64) -> None:
    plt.figure()
    if sec_end:
        pass
    else:
        sec_end = 1 / 2**n

    section = [0, sec_end]
    x = np.linspace(0, sec_end, num_points)
    alp_lst = alpha_distribution(d, n)
    alp_lst = [abs(alp) for alp in alp_lst]
    alp_cnt = Counter(alp_lst)
    zero_num = alp_cnt[0]

    alp_vals = list(alp_cnt)
    alp_vals.sort()
    alp_min = alp_vals[1]

    bound = 1 / 6**d
    varified = alp_min > bound

    alp_distri = get_distribution(alp_lst, section=section, num_points=num_points)
    plt.plot(x, alp_distri, label=f"n={n}, d={d}")

    plt.legend()
    plt.title(
        f"number of zero alpha: {zero_num} \n alp_min: {alp_min} , varified: {varified}"
    )
    plt.savefig(f"figures\\alpha_distribution_n={n}_d={d}.png")


def plot_range(n_range, d_range) -> None:
    for n, d in product(n_range, d_range):
        plot_fig(n, d)


def get_alpha(n):
    S = [3] * n
    S[0] = 1
    S[n - 1] = 1

    def alpha_d(d):
        return alpha(S, d, n)

    return alpha_d


# %%
if __name__ == "__main__":
    n = 6
    alpha_d = get_alpha(n)

    x_ac = [alpha_d(d) for d in range(1, 4 * n)]
    plt.plot(x_ac)
    plt.show()

# %%
