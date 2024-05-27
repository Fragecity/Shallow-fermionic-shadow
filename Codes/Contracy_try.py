from itertools import product
import copy

import numpy as np
import tensornetwork as tn

from U2representation import get_U_2fold, split_U2


def get_square():
    T_l = get_U_2fold()
    T_l.set_name(f"T_l")

    T_r = get_U_2fold()
    T_r.set_name(f"T_r")

    T_u = get_U_2fold()
    T_u.set_name(f"T_u")

    T_d = get_U_2fold()
    T_d.set_name(f"T_d")

    return T_l, T_r, T_u, T_d


def square_node() -> tn.Node:
    T_l, T_r, T_u, T_d = get_square()

    T_l[2] ^ T_u[1]
    T_l[3] ^ T_d[0]

    T_u[3] ^ T_r[0]
    T_d[2] ^ T_r[1]

    node = tn.contractors.optimal(
        [T_l, T_r, T_u, T_d],
        [T_u[0], T_l[0], T_l[1], T_d[1], T_u[2], T_r[2], T_r[3], T_d[3]],
    )

    return node


def is_square_projection() -> tn.Node:
    sqr_node = square_node()
    sqr_node2 = square_node()

    for i in range(4):
        sqr_node[i + 4] ^ sqr_node2[i]

    edges = [sqr_node[i] for i in range(4)] + [sqr_node2[i + 4] for i in range(4)]
    res = tn.contractors.optimal([sqr_node, sqr_node2], edges)
    return res


def blocks():
    T_up, T_down, _ = split_U2(1e-10)
    T_up[2].disconnect()
    T_up_, T_down_ = copy.deepcopy(T_up), copy.deepcopy(T_down)

    T_up[1] ^ T_down[1]
    T_down_[2] ^ T_up_[0]

    block_1 = tn.contractors.optimal(
        [T_up, T_down], [T_up[0], T_down[2], T_up[2], T_down[0]]
    )
    block_2 = tn.contractors.optimal(
        [T_down_, T_up_], [T_down_[1], T_up_[1], T_down_[0], T_up_[2]]
    )

    return block_1, block_2


def get_tensor_lst(tensor_node: tn.Node, edge_idx_lst):
    shape = tensor_node.shape
    range_lst = [range(shape[i]) for i in edge_idx_lst]
    edge_idx_dict = dict(zip(edge_idx_lst, range(len(edge_idx_lst))))

    tensor_lst = []

    tensor = tensor_node.tensor
    full_rank = slice(0, None)
    for closed_idx in product(*range_lst):
        idx_slice = []

        for full_idx in range(len(shape)):
            if full_idx in edge_idx_lst:
                idx_slice.append(closed_idx[edge_idx_dict[full_idx]])
            else:
                idx_slice.append(full_rank)
        tensor_lst.append(tensor[tuple(idx_slice)])
    return tensor_lst


def min_mat(mat):
    num_lst = []
    for line in mat:
        flt_line = list(filter(lambda x: x > 1e-10, line))
        if flt_line:
            # print(flt_line)
            num_lst.append(min(flt_line))

    if num_lst:
        return min(num_lst)
    else:
        return np.nan


# %%
if __name__ == "__main__":
    b1, b2 = blocks()
    b1_lst = get_tensor_lst(b1, [2, 3])
    b1_min = [min_mat(mat) for mat in b1_lst]

    print(f"The minimum value of each block is:")
    print(b1_min)
    print(f"The minimum value: {min(b1_min)}")

    T_square = square_node()

# %%
