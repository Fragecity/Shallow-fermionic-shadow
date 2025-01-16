using LinearAlgebra
using Yao

convert_dict = Dict('X'=>X, 'Y' =>Y, 'Z'=>Z, 'I' =>I2)

function pauli_string2F2(pauli_string::String)
    P_i = []
    P_N_i = []
    for op in pauli_string
        if op == 'Z'
            push!(P_i, 0)
            push!(P_N_i, 1)
        elseif op == 'X'
            push!(P_i, 1)
            push!(P_N_i, 0)
        elseif op == 'Y'
            push!(P_i, 1)
            push!(P_N_i, 1)
        elseif op == 'I'
            push!(P_i, 0)
            push!(P_N_i, 0)
        else
            throw(ArgumentError("Unknown operator: $op"))
        end
    end
    return vcat(P_i, P_N_i)
end

function pauli_string2F2(pauli_vec::Vector)
    n = div(length(pauli_vec), 2)
    pauli_string = ""
    for i in 1:n
        x, z = pauli_vec[i], pauli_vec[i + n]
        if x == 0 && z == 0
            pauli_string *= "I" # No operator
        elseif x == 0 && z == 1
            pauli_string *= "Z" # Z operator
        elseif x == 1 && z == 0
            pauli_string *= "X" # X operator
        elseif x == 1 && z == 1
            pauli_string *= "Y" # Y operator
        end
    end
    return pauli_string
end




function pauli_string_to_mat(pauli_string)
    result_matrix = pauli_char_to_mat(pauli_string[1])
    for pauli in pauli_string[2:end]
        result_matrix = kron(result_matrix, pauli_char_to_mat(pauli)) # Tensor product for each Pauli character
    end
    return result_matrix
end
 


function mod2_add(vector1, vector2)
    if length(vector1) != length(vector2)
        throw(ArgumentError("Both vectors must have the same length."))
    end
    return [(a + b) % 2 for (a, b) in zip(vector1, vector2)]
end

function symplectic_inner_product(binary_sequence1, binary_sequence2)
    mid = div(length(binary_sequence1), 2)
    X1, Y1 = binary_sequence1[1:mid], binary_sequence1[mid+1:end]
    X2, Y2 = binary_sequence2[1:mid], binary_sequence2[mid+1:end]
    inner_product = 0
    for i in 1:mid
        x1_y2 = X1[i] * Y2[i]
        x2_y1 = X2[i] * Y1[i]
        inner_product += x1_y2 + x2_y1
    end
    return inner_product % 2
end

function are_commuting_string(term1, term2)
    binary_sequence1 = pauli_string_to_F2(term1)
    binary_sequence2 = pauli_string_to_F2(term2)
    return symplectic_inner_product(binary_sequence1, binary_sequence2) == 0
end


function jordan_wigner_single(k::Int, n_qubits::Int)
	if k < 1
        throw(ArgumentError("Index k must be a positive integer."))
    end

    # Determine whether k is odd or even
    j = (k + 1) ÷ 2  # Calculate the j value corresponding to k

    # Initialize the Pauli string
    pauli_string = fill("I", n_qubits)

    # Apply the Jordan-Wigner transformation
    for i in 1:(j - 1)  # Add Z terms for indices < j
        pauli_string[i] = "Z"
    end
    if k % 2 == 1  # If k is odd (2j-1), add X at position j
        pauli_string[j] = "X"
    else  # If k is even (2j), add Y at position j
        pauli_string[j] = "Y"
    end

    return join(pauli_string)
end



function jordan_wigner(pauli::String)

end

function jordan_wigner(S::Vector, n::Int)
    res = repeat([0], 2n)
    for i in S
        pauli_string = jordan_wigner_single(i, n)
        pauli_vec = pauli_string2F2(pauli_string)
        res = mod2_add(res, pauli_vec)
    end
    return pauli_string2F2(res)
end

function pauli_string2Yaoblock(pauli_string::String)
    n = length(pauli_string)  
    blocks = [put(i=>convert_dict[char]) for (i, char) in enumerate(pauli_string) ]

    return chain(n, blocks)
end

# Example usage
# input_str = "XIXY"
# println(pauli_string2Yaoblock(input_str))