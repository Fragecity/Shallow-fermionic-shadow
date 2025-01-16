import numpy as np


def pauli_char_to_mat(pauli):
    if pauli == "x":
        return np.array([[0, 1], [1, 0]])  # Pauli-X 矩阵
    elif pauli == "y":
        return np.array([[0, -1j], [1j, 0]])  # Pauli-Y 矩阵
    elif pauli == "z":
        return np.array([[1, 0], [0, -1]])  # Pauli-Z 矩阵
    elif pauli == "e":
        return np.array([[1, 0], [0, 1]])  # 单位矩阵 I
    else:
        raise ValueError(f"未知的操作符: {pauli}")


def pauli_string_to_mat(pauli_string):
    result_matrix = pauli_char_to_mat(pauli_string[0])
    for pauli in pauli_string[1:]:
        result_matrix = np.kron(
            result_matrix, pauli_char_to_mat(pauli)
        )  # 逐个对每个 Pauli 符号进行张量积
    return result_matrix


def pauli_F2_to_string(vector):
    n = len(vector) // 2
    pauli_string = ""
    for i in range(n):
        x, z = vector[i], vector[i + n]
        if x == 0 and z == 0:
            pauli_string += "e"  # 无操作符
        elif x == 0 and z == 1:
            pauli_string += "z"  # Z 操作符
        elif x == 1 and z == 0:
            pauli_string += "x"  # X 操作符
        elif x == 1 and z == 1:
            pauli_string += "y"  # Y 操作符
    return pauli_string


def pauli_string_to_F2(pauli_string):
    P_i = []
    P_N_i = []
    for op in pauli_string:
        if op == "z":
            P_i.append(0)
            P_N_i.append(1)
        elif op == "x":
            P_i.append(1)
            P_N_i.append(0)
        elif op == "y":
            P_i.append(1)
            P_N_i.append(1)
        elif op == "e":
            P_i.append(0)
            P_N_i.append(0)
        else:
            raise ValueError(f"未知的操作符: {op}")
    binary_sequence = P_i + P_N_i
    return binary_sequence


def transform_pauli_string(pauli_string):
    """
    Transform a given Pauli string by applying the following rules:
    - 'X', 'Y', 'Z' (uppercase) are converted to 'x', 'y', 'z' (lowercase).
    - 'I' (uppercase) is converted to 'e'.

    Parameters:
        pauli_string (str): The input Pauli string.

    Returns:
        str: The transformed string.
    """
    # Define the transformation rules
    transformation = {"X": "x", "Y": "y", "Z": "z", "I": "e"}

    # Apply the transformation using a list comprehension
    transformed_string = "".join(
        transformation[char] for char in pauli_string if char in transformation
    )

    return transformed_string


def transform_pauli_string_x2X(pauli_string):
    transformation = {"x": "X", "y": "Y", "z": "Z", "e": "I"}
    transformed_string = "".join(
        transformation[char] for char in pauli_string if char in transformation
    )

    return transformed_string


def mod2_add(vector1, vector2):
    """
    Perform modulo 2 addition of two 0-1 vectors.

    Parameters:
        vector1 (list[int]): The first 0-1 vector.
        vector2 (list[int]): The second 0-1 vector.

    Returns:
        list[int]: The result of the modulo 2 addition.
    """
    # Check if both vectors have the same length
    if len(vector1) != len(vector2):
        raise ValueError("Both vectors must have the same length.")

    # Perform element-wise addition modulo 2
    result = [(a + b) % 2 for a, b in zip(vector1, vector2)]

    return result


def symplectic_inner_product(binary_sequence1, binary_sequence2):
    mid = len(binary_sequence1) // 2
    X1, Y1 = binary_sequence1[:mid], binary_sequence1[mid:]
    X2, Y2 = binary_sequence2[:mid], binary_sequence2[mid:]
    # 计算 X1 · Y2 + X2 · Y1 的逐位乘积并取模2
    inner_product = 0
    for i in range(mid):
        # 逐位乘积
        x1_y2 = int(X1[i]) * int(Y2[i])
        x2_y1 = int(X2[i]) * int(Y1[i])
        # 逐位相加并取模2
        inner_product += x1_y2 + x2_y1

    # 最终结果取模2
    return inner_product % 2


def are_commuting_string(term1, term2):
    # 检查两个项是否可对易
    binary_sequence1 = pauli_string_to_F2(term1)
    binary_sequence2 = pauli_string_to_F2(term2)

    return symplectic_inner_product(binary_sequence1, binary_sequence2) == 0


if __name__ == "__main__":
    pauli_string = "xyez"
    binary_sequence = pauli_string_to_F2(pauli_string)
    print(binary_sequence)
