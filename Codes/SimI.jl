#%%
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

function Ff(N::Int, i::Int, f:: Function)
    function new_func(var...)

        var₋ = [ele for ele in var]
        var₋[i] = var[i] - 1
        
        var₊ = deepcopy(var₋)
        var₊[i] = var[i] + 1

        if var[i] == 1
            return 3/4*f(var...)+1/4*f(var₊...)
        elseif var[i] == N
            return 3/4*f(var...)+1/4*f(var₋...)
        else
            return 1/2*f(var...)+1/4*f(var₋...)+1/4*f(var₊...)
        end
    end
    return new_func
end

function get_ele(M::Matrix{Float64}, i::Int, j::Int)
    return M[i,j]    
end

function I_next(M::Matrix{Float64}, t::Int)
    N = size(M, 1)
    M_cp = zeros(Float64, N,N)

    
    for index in eachindex(view(M, 1:N, 1:N))
        i = index[1]
        j = index[2]

        free_term = Ff(N,3, Ff(N, 2, get_ele))(M, i, j)
        interact_term = 0.0

        if i==j==1
            interact_term = 5/144 * (
                -_PI_diff(M, 1, 1, t-1) 
                -_PI_diff(M, 2, 2, t-1) 
                +_PI_diff(M, 1, 2, t-1) 
                +_PI_diff(M, 2, 1, t-1) 
                )
        elseif (i==1 && j==2 ) || (i==2 && j==1)
            interact_term =  (
                -1/24 * _PI_diff(M, 1, 1, t-1) 
                +1/24 * _PI_diff(M, i, j, t-1) 
                -5/48 * _PI_diff(M, 2, 2, t-1) 
                )
        elseif i==j==N
            interact_term = 5/144 * (
                -_PI_diff(M, N, N, t-1) 
                -_PI_diff(M, N-1, N-1, t-1) 
                +_PI_diff(M, N, N-1, t-1) 
                +_PI_diff(M, N-1, N, t-1) 
                )
        elseif (i==N-1 && j==N ) || (i==N && j==N-1)
            interact_term =  (
                -1/24 * _PI_diff(M, N, N, t-1) 
                +1/24 * _PI_diff(M, i, j, t-1) 
                -5/48 * _PI_diff(M, N-1, N-1, t-1) 
                )
        elseif abs(i-j) == 1
            interact_term =  (
                -5/48 * _PI_diff(M, i, i, t-1) 
                +1/24 * _PI_diff(M, i, j, t-1) 
                -5/48 * _PI_diff(M, j, j, t-1) 
                )
        elseif i==j
            interact_term =  (
                -5/144 * _PI_diff(M, i-1, i-1, t-1) + 1/72 * _PI_diff(M, i-1, i, t-1) + 1/48  * _PI_diff(M, i-1, i+1, t-1)
                + 1/72 * _PI_diff(M, i, i-1, t-1)   - 1/9  * _PI_diff(M, i, i, t-1)   + 1/72  * _PI_diff(M, i, i+1, t-1)
                + 1/48 * _PI_diff(M, i+1, i-1, t-1) + 1/72 * _PI_diff(M, i+1, i, t-1) - 5/144 * _PI_diff(M, i+1, i+1, t-1)
                )
        end

        M_cp[i,j] = free_term - interact_term

    end

    return M_cp
end



function _PI_diff(M::Matrix{Float64}, i::Int, j::Int, t::Int)
    N = size(M, 1)
    return P1(N, i, t)*PN(N, j, t) - M[i,j]
end

filt_eps(x::Float64) = abs(x) < 1e-16 ? 0.0 : x

function I_raw(N::Int, T::Int)
    if T < N ÷ 2 -1
        return 0.0
    end

    M = zeros(Float64, N, N)
    t = 0
    while t ≤ T
        t += 1
        M = I_next(M, t)
    end
    return M .|> filt_eps
end



function P_mat(N::Int, T::Int)
    M = zeros(Float64, N, N)
    for ind in eachindex(view(M, 1:N, 1:N))
        i = ind[1]
        j = ind[2]
        M[i,j] = P1(N, i, T)*PN(N, j, T)
    end
    return filt_eps.(M)
end


# filter(I_raw(10, 10)) do ele
#     abs(ele)> 1e-10
# end
N = 6
i,j = 3,4
t = 2

P1(N, i, t)*PN(N, j, t)