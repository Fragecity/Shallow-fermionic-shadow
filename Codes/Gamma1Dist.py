from itertools import product

import numpy as np


def T_mat(dim) -> np.array:
    T = np.zeros((dim, dim))
    for i, line in enumerate(T):
        if i % 2 == 0:
            _fill_T_line(line, i)
        elif i % 2 == 1:
            _fill_T_line(line, i - 1)

    return T / 4


def T_neat(dim) -> np.array:
    T = np.zeros((dim, dim))
    for i in range(dim):
        if i == 0:
            T[i, 0] = 3
            T[i, 1] = 1
        elif i == dim - 1:
            T[i, dim - 2] = 1
            T[i, dim - 1] = 3
        else:
            T[i, i - 1] = 1
            T[i, i] = 2
            T[i, i + 1] = 1
    return T / 4


def Four_T(dim):
    F = np.fft.fft(np.eye(dim))
    T = T_neat(dim)
    return F @ T @ F.conj().T


from numpy import cos, pi


def get_P(n0, N):
    def P(n, t):
        series = [1 / N]
        for k in range(1, N):
            eta = pi * k / N
            series.append(
                (2 / N)
                * cos((n - 1 / 2) * eta)
                * cos((n0 - 1 / 2) * eta)
                * (cos(eta / 2)) ** (2 * t)
            )
        return sum(series)

    return P


# Utils


def _fill_T_line(L, i):
    n = len(L)
    if i == 0:
        L[0] = 2
        L[1] = 1
        L[2] = 1
    elif i + 2 >= len(L):
        if n % 2 == 0:
            L[n - 3] = 1
            L[n - 2] = 1
            L[n - 1] = 2
        else:
            L[n - 2] = 2
            L[n - 1] = 2
    else:
        L[i - 1] = 1
        L[i] = 1
        L[i + 1] = 1
        L[i + 2] = 1


def get_T_evl(dim, n0):
    T = T_mat(dim)
    state_int = np.zeros(dim)
    state_int[n0] = 1

    def T_evl(t):
        return np.linalg.matrix_power(T, t) @ state_int

    return T_evl


def compare_evl(n0, N):
    np.set_printoptions(precision=3)
    P = get_P(n0 + 1, N // 2)
    T_evl = get_T_evl(N, n0)
    for t in range(N):
        print(f"\n-----------\nt = {t}:\n ")
        P_vec = [P(n, t) for n in range(1, N // 2 + 1)]
        print(f"P = {np.array(P_vec)},\nT_evl = {np.array(T_evl(t+1))}")


def alpha_sim(t, N):
    res = []
    P1 = get_P(1, N)
    PN = get_P(N, N)
    for i in range(N):
        res.append(P1(i, t) * PN(i, t) / 2)
    return sum(res)


# def board(dim):
#     mat = np.zeros((dim, dim))
#     mat[0, dim-1] = 1


def evolve_board(board):
    new_board = np.zeros_like(board)

    n = len(board)
    for i in range(n):
        for j in range(i,n):
            if i == 0 and j == n-1:
                new_board[i,j] += 1/4*board[i,j]
                new_board[i+1,j] += 1/4*board[i,j]
                new_board[i,j-1] += 1/4*board[i,j]
                new_board[i+1,j-1] += 1/4*board[i,j]
            elif i == 0 and j %2 ==0:
                new_board[i,j] += 1/4*board[i,j]


def spread_odd(board):
    new_board = np.zeros_like(board)

    n = len(board)
    for i in range(n):
        for j in range(i,n):
            if i == 0:
                if j == n-1:
                    new_board[i,j] += board[i,j]
                elif j %2 == 0:
                    if j == 0:
                        new_board[i,j] += board[i,j]
                    else:
                        new_board[i,j] += 1/2*board[i,j]
                        new_board[i,j-1] += 1/2*board[i,j]
                else:
                    new_board[i,j] += 1/2*board[i,j]
                    new_board[i,j+1] += 1/2*board[i,j]
            elif i %2:
                if j % 2 == 0:
                    if np.abs(i-j) == 0:
                        new_board[i,j] += 1/2*board[i,j]
                        new_board[i,j] += 1/2*board[i,j]

                            


        




if __name__ == "__main__":
    # print(
    #     f"\n\n-----------------------------------------\n        Data for N = 8          \n--------------------------------------  \n"
    # )
    # compare_evl(0, 8)

    # print(
    #     f"\n\n-----------------------------------------\n        Data for N = 12          \n--------------------------------------  \n"
    # )
    # compare_evl(0, 12)

    N = 8
    t_range = 6 * N

    alp_lst = [alpha_sim(t, N) for t in range(t_range)]
    print(alp_lst)

    import matplotlib.pyplot as plt

    plt.title(f"N = {2*N}")

    plt.plot(alp_lst)
    plt.savefig("./figures/N=8.png")
    plt.show()
