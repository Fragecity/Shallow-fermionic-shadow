
module SpreadUtils
include("Paulis.jl")
export Majorana, Majorana_Pauli_form, measure_tensor, tuple_spread_utils, isometric, isometric_inv

using Combinatorics

using Paulis


function Majorana(i::Int, N::Int)
    head::String = ""
    if i%2 == 0
        head = "Y"
    elseif i%2 == 1
        head = "X"
    end

    n = (i+1) ÷ 2
    Zs = "Z"^(n-1)
    Is = "I"^(N-n)
    return Pauli(Is * head * Zs)
end


function Majorana(S::Vector{Int}, N::Int)
    ops = Majorana.(S, N)
    reduce(*, ops)
end


function Majorana_Pauli_form(S::Vector{Int}, N::Int, pattern::String = "origin")
    pauli = Majorana(S, N).name

    dim = 4
    maping = Dict('I' => 1, 'X' => 2, 'Y' => 3, 'Z' => 4)
    coeff = 1.0

    if pattern == "mix"
        dim = 3
        maping = Dict('I' => 1, 'X' => 2, 'Y' => 2, 'Z' => 3)
    end

    shape = repeat([dim] ,length(pauli))
    res = zeros(shape...)
    index = ones(Int, length(pauli))
    for (i, p) in enumerate(pauli)
        idx = maping[p]
        index[i] = idx
    end
    index = [maping[p] for p in pauli]
    res[index...] = coeff

    return res
end


function measure_tensor(S::Vector{Int}, N::Int, pattern::String = "origin")
    k = length(S)
    
    dim = 4
    if pattern == "mix"
        dim = 3
    end

    measure = zeros(repeat([dim], N)...)

    if k%2 == 1
        return measure
    elseif k%2 == 0
        k = k ÷ 2
    end
 
    for comb in combinations(1:N, k)
        index = repeat([1], N)
        for i in comb
            index[i] = dim
        end
        measure[index...] = 1.0
    end

    return measure
end


function ordered(i,j)
    return i>j ? (j,i) : (i,j)
end


function poly2N_spread_odd(pr::Tuple{Int64, Int64}, N::Int64)
    res = Dict{Tuple{Int64, Int64}, Float64}()
    i,j = pr
    (i,j) = i>j ? (j,i) : (i,j)

    c1 = (-1)^(i%2)
    c2 = (-1)^j%2


    if i == 1 && j == 1
        res = Dict((1,1) => 1//1)
    elseif i == 1 && 1<j<N
        res = Dict((1,j) => 1//2, (1, j+c2)=> 1//2 )
    elseif i ==1 && j == N
        res = Dict((1,N) => 1//1)
    elseif 1<i<N && (j == i || j == i+c1)
        res = Dict((i,i) => 1//6, (i+c1,i+c1) => 1//6, ordered(i, i+c1) => 2//3)
    elseif 1<i<N && N > j > i+c1
        res = Dict((i,j) => 1//4, ordered(i,j+c2) => 1//4, ordered(i+c1,j) => 1//4, ordered(i+c1,j+c2) => 1//4)
    elseif 1<i<N && j == N
        res = Dict((i,N) => 1//2, (i+c1,N) => 1//2)
    elseif i == N && j == N
        res = Dict((N,N) => 1//1)
    end
    return res
end

function poly2N_spread_even(pr, N)
    
    if N%2 != 0
        throw(ArgumentError("N must be even"))
    end

    res = Dict{Tuple{Int64, Int64}, Rational{Int64}}()
    i,j = pr
    (i,j) = i>j ? (j,i) : (i,j)

    c1 = (-1)^(i%2 + 1)
    c2 = (-1)^(j%2 + 1)


    if j == i || j == i+c1
     res = Dict((i,i) => 1//6, (i+c1,i+c1) => 1//6, ordered(i, i+c1) => 2//3)
    else
        res = Dict((i,j) => 1//4, ordered(i,j+c2) => 1//4, ordered(i+c1,j) => 1//4, ordered(i+c1,j+c2) => 1//4)
    end

    return res    
end

function tuple_spread_utils(diction::Dict, parity, N)
    lst = Dict()

    if parity == "odd"
        spread_func = poly2N_spread_odd
    elseif parity == "even"
        spread_func = poly2N_spread_even
    end
    
    for (key,value) in diction
        new_dict = spread_func(key, N)

        new_dict = Dict( newkey => value*newvalue for (newkey, newvalue) in new_dict  )

        mergewith!(+, lst, new_dict)
        

    end
        
    return lst
        
end

function basis_map_inv(pair)
    i,j = pair[1]
    c = pair[2]

    if i == j
        res = Dict((2i-1,2i-1) => c/6, (2i-1,2i) => 2c/3, (2i, 2i) => c/6)
    else
        res = Dict((2i-1,2j-1) => c/4, (2i-1,2j) => c/4, (2i,2j-1) => c/4, (2i,2j) => c/4)
    end

    return res
end



function isometric(diction::Dict, N::Int64)
    res = Dict()
    for i in 1:N
        v1, v2, v3 = get(diction, (2i-1,2i-1), 0), get(diction, (2i-1,2i), 0), get(diction, (2i,2i), 0)
        if !(4v1 ≈ 4v3 ≈ v2)
            AssertionError("Fake hypothesis")
        end
        value = v1+v2+v3
        push!(res, (i,i) => value)

        for j in i+1:N
            v1, v2 = get(diction, (2i-1,2j-1), 0), get(diction, (2i-1,2j), 0)
            v3, v4 = get(diction, (2i,  2j-1), 0), get(diction, (2i,  2j), 0)
            if !(v1 ≈ v2 ≈ v3 ≈ v4)
                AssertionError("Fake hypothesis")
            end
            value = v1+v2+v3+v4
            push!(res, (i,j) => value)
        end    
    end
    return res
end


function isometric_inv(diction::Dict)
    res = Dict()
    
    for pair in diction
        maped_term = basis_map_inv(pair)
        merge!(+, res, maped_term)
    end

    return res
end

end


module FormulaUtils
export PP, PP_diag

function c4t(N::Int, m::Int, t::Int)
    cos( pi*m/2/N)^(4t+2)
end

function P1(N::Int, i::Int,t::Int)
    body = sum(1:N-1) do k
        kappa = pi*k/N
        cos( (i - 1/2) * kappa) * cos(kappa/2)^(2t+1)
    end
    return 1/N + 2/N *body
end

function PN(N::Int, i::Int,t::Int)
    body = sum(1:N-1) do k
        kappa = pi*k/N
        cos( (N-1/2)*kappa ) * cos( (i - 1/2) * kappa) * cos(kappa/2)^(2t)
    end
    return 1/N + 2/N *body
end

function PP(N, i, j, t)
    return P1(N, i, t)*PN(N, j, t)
end

function PP_diag(N::Int,t::Int)
    M,c = divrem(N,2)
    term1 = sum(1:M) do m
        c4t(N, 2m, t) 
    end
    term2 = sum(1:M) do m
        c4t(N, 2m-1, t) 
    end

    return 1/N + 2/N * (term1 - term2) - 2c/N * sin(pi/2/N)^(4t+2)
end
    
end




# using .FormulaUtils
# PP(4, 1,4,1)