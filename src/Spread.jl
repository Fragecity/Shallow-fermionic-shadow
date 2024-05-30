
module TSpreads
export T_origin, T_mix, alpha

using LinearAlgebra
using TensorOperations

include("Utils.jl")
using .SpreadUtils

function _fill_symmetry_mat!(
    Mat::Array{Float64}, 
    idx_lst:: Vector{Tuple{Int64, Int64}},
    fill_number::Number
    )

    for (input, output) in Iterators.product(idx_lst, idx_lst)
        Mat[input[1], input[2], output[1], output[2]] = fill_number
    end

    return
end

T_origin = let T = zeros(Float64, 4,4,4,4)
    T[1,1,1,1] = 1.0

    k1_lst = [(1, 2), (1, 3), (2, 4), (3, 4)]
    k2_lst = [(1, 4), (2, 2), (2, 3), (3, 2), (3, 3), (4, 1)]
    k3_lst = [(2, 1), (3, 1), (4, 2), (4, 3)]

    _fill_symmetry_mat!(T, k1_lst, 1 / 4)
    _fill_symmetry_mat!(T, k2_lst, 1 / 6)
    _fill_symmetry_mat!(T, k3_lst, 1 / 4)

    
    T[4, 4, 4, 4] = 1.0
    T
end

T_mix = let T = zeros(Float64, 3,3,3,3)
    T[1,1,1,1] = 1.0

    k1_lst = [(1, 2), (2, 3)]
    k2_lst = [(2, 1), (3, 2)]
    k3_lst = [(1, 3), (3, 1)]

    _fill_symmetry_mat!(T, k1_lst, 1 / 2)
    _fill_symmetry_mat!(T, k2_lst, 1 / 2)
    _fill_symmetry_mat!(T, k3_lst, 1 / 6)

    T[1,3,2,2] = 2/3
    T[3,1,2,2] = 2/3

    T[2,2,1,3] = 1/6
    T[2,2,3,1] = 1/6
    T[2,2,2,2] = 2/3

    
    T[3, 3, 3, 3] = 1.0
    T
end

function contract_layer(tensor::Array{Float64}, parity::String, pattern::String = "origin")
    N = ndims(tensor)
    T = copy(T_origin)
    
    if pattern == "mix"
        T = copy(T_mix)
    end

    num_T, c = divrem(N, 2)
    tensor_contract_index = collect(1: N)
    beg_index = 1

    if parity == "odd"
        tensor_contract_index[1] = -1
        if c == 0
            tensor_contract_index[N] = -N
        end
        num_T -= 1
        beg_index = 2
    elseif parity == "even"
        if c == 1
            tensor_contract_index[N] = -N
        end
    end

    contracting_T = repeat([T], num_T)

    T_contract_index = [[i, i+1, -i, -i-1]  for i in beg_index:2:N-1]

    return ncon([tensor, contracting_T...], [tensor_contract_index, T_contract_index...])
end


function alpha(S:: Vector, N::Int, d::Int, pattern::String = "origin")
    tensor = Majorana_Pauli_form(S, N, pattern)
    tensor = contract_layer(tensor, "even", pattern)
    measure = measure_tensor(S, N, pattern)

    for i in 1:d-1
        if i%2 == 1
            parity = "odd"
        elseif i%2 == 0
            parity = "even"
        end
        tensor = contract_layer(tensor, parity, pattern)
    end
    
    return ncon([tensor, measure], [collect(1:N), collect(1:N)])
end

end

module PolySpreads
export alpha_poly, poly_spread_N, poly_spread_2N

include("Utils.jl")
using .SpreadUtils



function poly_spread_2N(N::Int64, init::Tuple, t::Int64)
    res = Dict(init => 1//1)

    res = tuple_spread_utils(res, "even", N)

    for i in 1:t
        res = tuple_spread_utils(res, "odd", N)
        res = tuple_spread_utils(res, "even", N)
    end

    return res
end




function poly_spread_N(N::Int64, init::Tuple, t::Int64)
    dct_N = Dict(init => 1//1)
    dct_2N = isometric_inv(dct_N)

    for i in 1:t
        dct_2N = tuple_spread_utils(dct_2N, "odd", 2*N)
        dct_2N = tuple_spread_utils(dct_2N, "even", 2*N)
    end
    dct_N = isometric(dct_2N, N)

    return filter(pair -> pair[2] != 0, dct_N)
end


function alpha_poly(NOTS, N, t, dim = "N")
    if dim == "N"
        spread_func = poly_spread_N
    elseif dim == "2N"
        spread_func = poly_spread_2N
    end

    res = spread_func(N, NOTS, t)
    
    v = 0
    for (key, value) in res
        if key[1] == key[2]
            v += value
        end
    end

    return v
end


end
#%% Test

# PolySpreads.poly_spread_N
# using .TSpreads


# S = [1,4]
# N = 4
# pattern = "mix"

# # tensor = Majorana_Pauli_form(S, N, pattern)


# TSpreads.alpha(S, N, 5, pattern)[]

# TODO: Test alpha_poly N  (和2N 的数值对上)


# PolySpread.alpha_poly((3,4), N, 80, "2N")
# PolySpreads.alpha_poly((2,2), N÷2, 80)