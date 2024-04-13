import copy
from itertools import combinations, product
from functools import cache, reduce
from operator import mul

import numpy as np
import scipy

from QCompTool.Texutils import QcomTex, TexTable, pauli2tex
from QCompTool.Pauli import Pauli, pauli_map_bin2str, pauli_map_str


def write_tex_file() -> None:

    Tex = QcomTex(tex_name="gamma2pauli")

    gamma = [None] * 5
    _fillin_gamma(gamma)

    Tex.write("k = 0:")

    qc = pauli2tex("II")
    Tex.write_aligh(["\\gamma_0 = " + qc])

    _write_k(Tex, gamma, 1)

    _write_k(Tex, gamma, 2)

    _write_k(Tex, gamma, 3)
    # Tex.write_aligh(equations)
    _write_k(Tex, gamma, 4)

    # num_range = range(1, 5)
    # equations = [None] * 4
    # for i, j in combinations(num_range, 2):
    #     equations[i - 1] = f"\\gamma_{i} \\gamma_{j} = " + pauli2tex(
    #         str(gamma[i] * gamma[j])
    #     )
    Tex.save()


def write_repr_table() -> None:
    head = [pauli_map_str[i] + pauli_map_str[j] for i, j in product(range(4), repeat=2)]
    data = np.zeros((16, 16), dtype=object)

    # for column_idx, pauli_1 in enumerate(head):
    #     for row_idx, pauli_2 in enumerate(head):
    #         p1 = Pauli(pauli_1)
    #         p2 = Pauli(pauli_2)
    #         data[row_idx, column_idx] = str(p1 * p2)
    table = TexTable(data, head, head)
    print(table)


def _fillin_gamma(gamma: list) -> None:
    gamma[0] = Pauli("II")
    gamma[1] = Pauli("IX")
    gamma[2] = Pauli("IY")
    gamma[3] = Pauli("XZ")
    gamma[4] = Pauli("YZ")


def _get_gamma(n):
    N = 2**n
    gamma = [None] * 2**n

    _fillin_gamma(gamma)
    return gamma[n]


@cache
def _get_first_pauli(p: Pauli) -> tuple[tuple]:
    keys = p.sentence.keys()
    return list(keys)[0]


@cache
def _pauli2str(p: Pauli) -> str:
    p: tuple[tuple] = _get_first_pauli(p)
    return "".join([pauli_map_bin2str[pauli] for pauli in p])


def _write_k(tex_obj: QcomTex, gamma, k: int) -> None:
    tex_obj.write(f"k = {k}:")
    equations = []

    for comb in combinations(range(1, 5), k):
        gam = "".join([f"\\gamma_{i}" for i in comb])
        pauli = reduce(mul, [gamma[i] for i in comb])
        pauli = _pauli2str(pauli)
        equations.append(gam + "=" + pauli2tex(pauli))
    tex_obj.write_aligh(equations)

    # for i in range(1, 5):
    #     pauli = _pauli2str(gamma[i])
    #     equations[i - 1] = f"\\gamma_{i} = " + pauli2tex(pauli)
    # tex_obj.write_aligh(equations)
    # pass


if __name__ == "__main__":
    # write_repr_table()
    write_repr_table()
