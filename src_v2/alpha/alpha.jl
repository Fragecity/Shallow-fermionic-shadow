# include("../Utils.jl")
# using .Utils
using Pkg
Pkg.activate("venv")
using TensorOperations
using Memoization

const T = begin
    mat = zeros(3,3,3,3)
    mat[1,1,1,1] = 1;      mat[3,3,3,3] = 1
    mat[1,2,1,2] = 1/2;    mat[1,2,2,3] = 1/2
    mat[1,3,1,3] = 1/6;    mat[1,3,2,2] = 2/3;    mat[1,3,3,1] = 1/6
    mat[2,1,2,1] = 1/2;    mat[2,1,3,2] = 1/2
    mat[2,2,1,3] = 1/6;    mat[2,2,2,2] = 2/3;    mat[2,2,3,1] = 1/6
    mat[2,3,1,2] = 1/2;    mat[2,3,2,3] = 1/2
    mat[3,1,1,3] = 1/6;    mat[3,1,2,2] = 2/3;    mat[3,1,3,1] = 1/6
    mat[3,2,2,1] = 1/2;    mat[3,2,3,2] = 1/2

    mat
end

const out_tensor_single = [1, 0, 1]

const wire = [
    1 0 0;
    0 1 0;
    0 0 1;
]


function alpha(S,d,n)
    tensors, idx = evolved_state_tensornet(S,d,n)
    all_tensors = (tensors..., repeat([out_tensor_single], n)...)
    all_idx = (idx..., map(x -> [x], d*n+1 : n*(d+1))...)

    ncon(all_tensors, all_idx)
end


function evolved_state_tensornet(S,d,n)
    """
    n must be an even number
    """
    m = n ÷ 2

    # init_tensors = repeat([out_tensor_single], n)
    T_lst_odd = repeat([T], m)
    T_lst_even = [wire, repeat([T], m-1)..., wire]
    T_layer = []
    for i in 1:d
        if i%2 == 0
            push!(T_layer, T_lst_even...)
        else
            push!(T_layer, T_lst_odd...)
        end
    end
    measure_lst = Majorana_S_2_tensor(S, n)
    all_tensors = (measure_lst..., T_layer...)
    
    init_tensors_idx = map(x -> [x], 1:n)
    # measure_lst_idx = map(x -> [x], d*n+1 : n*(d+1))
    T_lst_idx = []
    for i in 1:d
        if i%2 == 0
            push!(T_lst_idx, [(i-1)*n+1, i*n+1], map(x -> [(i-1)*n+2x, (i-1)*n+2x+1, i*n+2x, i*n+2x+1], 1:m-1)..., [i*n, (i+1)*n])
        else
            push!(T_lst_idx, map(x -> [(i-1)*n+2x-1, (i-1)*n+2x, i*n+2x-1, i*n+2x], 1:m)...)
        end
    end
    all_idx = (init_tensors_idx..., T_lst_idx...)

    return all_tensors, all_idx
end


function Majorana_label_2_F2(i::Int, n::Int)
    parity = i%2
    j = (i + parity)/2 |> Int
    z_mat = zeros(n-j, 2)
    o_mat = ones(j-1, 2)
    mid_mat = [parity (1+parity)%2]

    return vcat(z_mat, mid_mat, o_mat)
end

function Majorana_S(S::Array, n::Int)
    add_majorana_label(mat1,mat2) = mod.(mat1 + mat2, 2)
    Majorana_labels = Majorana_label_2_F2.(S, n)
    reduce(add_majorana_label, Majorana_labels)
end

function Majorana_S_2_tensor(S::Array, n::Int)
    F2mat = Majorana_S(S, n)
    res_list = []
    for i in sum(F2mat, dims=2)
        tensor = zeros(3)
        tensor[Int(i)+1] = 1
        push!(res_list, tensor)
    end
    return res_list
end


function theoretical_prediction_k2(i,j,d,n)
    t = (d-1)÷2
    # gaussian(x) = ℯ^(-x^2/(2t)) / sqrt(2π*t)
    i, j = (i-1)÷4+1, (j-1)÷4+1
    a = abs(i-j)
    b = i+j-1
    N = n÷2
    f(x,k) = ℯ^(-(2k*N+x)^2/2t)
    return 1/sqrt(2π *t) * sum(-2n:2n) do k
        f(a,k) + f(b,k)
    end
    # term(a) = t/2/(a^2+t^2) - cos(a*π) *t*ℯ^(-π*t)/2/(a^2+t^2)
    # return gaussian(a^2) + gaussian(b^2) + 2*gaussian(a^2+n*(n÷2-a)) + 2*gaussian(b^2+n*(n÷2-b))
end

function theoretical_origin_k2(i,j,d,n)
    t = (d-1)÷2
    i, j = i÷4+1, j÷4+1
    a = abs(i-j)
    b = i+j-1
    N = n÷2
    res = sum(0:N-1) do k
       ( cos(a*(π*k)/N) + cos(b*(π*k)/N) ) * cos((π*k)/n)^(4t)
    end
    return -1/N + 1/N*res
end

# P(i,μ,N,t) = 1/N + 2/N *sum(1:N-1) do k
#     cos((μ-1/2)*(π*k)/N) * cos((i-1/2)*(π*k)/N) * cos((π*k)/n)^(2t)
# end

# %%
n = 10
d = 3
i = 1
j = 4
theoretical_prediction_k2(i,j,d,n) * n/(2n-1)/2
# N = 5
# t = 3
# i,j = 1,5
# 1/N+1/N*sum(1:N-1) do k
#     (cos((i-j)*(π*k)/N) + cos((i+j-1)*(π*k)/N)) * cos((π*k)/n)^(4t) 
# end

# 1/N+1/N*sum(1:10N) do k
#     (cos((i-j)*(π*k)/N) + cos((i+j-1)*(π*k)/N)) * exp(-k^2 *π^2/2/N^2*t)
# end

# 1/sqrt(2π *t) * sum(-10N:10N) do k
#     f(x) = ℯ^(-(2k*N+x)^2/2t)
#     f(i-j) + f(i+j-1)
# end


# theoretical_prediction_k2(1,20,7,10)
# theoretical_origin_k2(1,20,7,10)


# π/N*sum(1:N-1) do k
#     cos((i-j)*(π*k)/N) * cos((π*k)/n)^(4t) 
# end 

# 1/sqrt(2π *t) *ℯ^(-(i-j)^2/2/t)




#%% 123




# alpha([1,3], 1, 2)
# alpha([1,3,5,7], 1, 4)
# alpha([1,3], 100, 4)

# mybackend = TensorOperations.cuTENSORBackend()
# mybackend = TensorOperations.StridedNative()
# ncon(([0,1,0], [0,1,0], T, out_tensor_single, out_tensor_single), ([1],  [2], [1,2,3,4], [3], [4]); backend=mybackend)
# ncon(([0,1,0], [0,1,0], T, [1,0,0], [0,0,1]), ([1],  [2], [1,2,3,4], [3], [4]); backend=mybackend)

# @code_warntype alpha([1,3], 1, 2)
# @code_warntype ncon(([0,1,0], [0,1,0], T, out_tensor_single, out_tensor_single), ([1],  [2], [1,2,3,4], [3], [4]))