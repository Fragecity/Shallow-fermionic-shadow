#%% Utils
using SpecialFunctions
using Caching


function c4t(N::Int, m::Int, t::Int)
    cos( pi*m/2/N)^(4t+2)
end

function B1(N::Int, p::Int)
    beta_inc(1/2+p, 1/2, cos(2*pi/N)^2)[1] * beta(1/2+p, 1/2)
end

function B2(N::Int, p::Int)
    beta_inc(1/2+p, 1/2, sin(pi/N)^2)[1] * beta(1/2+p, 1/2) 
end

function Gamma_term(p::Int)
    gamma(1/2+p) / gamma(1+p)
end

function bond_term(N::Int, t::Int)
    1/pi * (B1(N, 2t+1) + B2(N, 2t+1)) - 1/sqrt(pi) * Gamma_term(2t+1)
end

#%% Main

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


function  PP_full(N::Int, t::Int)
    sum(1:N) do i
        P1(N, i,t)*PN(N, i,t)
    end 
end


function PP_neat(N::Int,t::Int)
    M,c = divrem(N,2)
    term1 = sum(1:M) do m
        c4t(N, 2m, t) 
    end
    term2 = sum(1:M) do m
        c4t(N, 2m-1, t) 
    end

    return 1/N + 2/N * (term1 - term2) - 2c/N * sin(pi/2/N)^(4t+2)
end

function L(N::Int, t::Int)
    return 1/N + bond_term(N, t) - 2/N * sin(pi/2/N)^(4t+2)
end
function U(N::Int, t::Int)
    return 1/N - bond_term(N, t)
end

function I_raw(N::Int, i::Int, j::Int, t::Int)
    if t < N ÷ 3
        return 0.0
    end
    free_term = Ff(N,3,Ff(N, 2, I_raw))(N,i,j,t-1)

    interact_term = 0.0
    if i==j==1
        interact_term = 5/144 * (
            -_PI_diff(N, 1, 1, t-1) 
            -_PI_diff(N, 2, 2, t-1) 
            +_PI_diff(N, 1, 2, t-1) 
            +_PI_diff(N, 1, 2, t-1) 
            )
    elseif (i==1 && j==2 ) || (i==2 && j==1)
        interact_term =  (
            -1/24 * _PI_diff(N, 1, 1, t-1) 
            +1/24 * _PI_diff(N, i, j, t-1) 
            -5/48 * _PI_diff(N, 2, 2, t-1) 
            )
    elseif i==j==N
        interact_term = 5/144 * (
            -_PI_diff(N, N, N, t-1) 
            -_PI_diff(N, N-1, N-1, t-1) 
            +_PI_diff(N, N, N-1, t-1) 
            +_PI_diff(N, N-1, N, t-1) 
            )
    elseif (i==N-1 && j==N ) || (i==N && j==N-1)
        interact_term =  (
            -1/24 * _PI_diff(N, N, N, t-1) 
            +1/24 * _PI_diff(N, i, j, t-1) 
            -5/48 * _PI_diff(N, N-1, N-1, t-1) 
            )
    elseif abs(i-j) == 1
        interact_term =  (
            -5/48 * _PI_diff(N, i, i, t-1) 
            +1/24 * _PI_diff(N, i, j, t-1) 
            -5/48 * _PI_diff(N, j, j, t-1) 
            )
    elseif i==j
        interact_term =  (
            -5/144 * _PI_diff(N, i-1, i-1, t-1) + 1/72 * _PI_diff(N, i-1, i, t-1) + 1/48 * _PI_diff(N, i-1, i+1, t-1)
            + 1/72 * _PI_diff(N, i, i-1, t-1) - 1/9 * _PI_diff(N, i, i, t-1) + 1/72 * _PI_diff(N, i, i+1, t-1)
            + 1/48 * _PI_diff(N, i+1, i-1, t-1) + 1/72 * _PI_diff(N, i+1, i, t-1) - 5/144 * _PI_diff(N, i+1, i+1, t-1)
            )
    end

    return free_term - interact_term
end

function _PI_diff(N::Int, i::Int, j::Int, t::Int)
    return P1(N, i, t)*PN(N, j, t) - I_raw(N, i, j, t)
end

function Ff(N::Int, i::Int, f:: Function)
    function new_func(var...)

        var₋ = [ele for ele in var]
        var₋[i] = var[i] - 1
        
        var₊ = deepcopy(var₋)
        var₊[i] = var[i] + 1

        if i == 1
            return 3/4*f(var...)+1/4*f(var₊...)
        elseif i == N
            return 3/4*f(var...)+1/4*f(var₋...)
        else
            return 1/2*f(var...)+1/4*f(var₋...)+1/4*f(var₊...)
        end
    end
    return new_func
end

#### Test

#%% Panel
using Plots
using LaTeXStrings

N = 40
t = Int(floor(N/2)) : 2N


#%% test Lemma 2
function c4t_sum(N::Int, t::Int, mode::Bool)
    M = (N-1) ÷2
    k = x -> mode ? 2x-1 : 2x
    return 2*pi/N * sum(1:M) do m
        c4t(N, k(m), t) 
    end
end


# function symmetry(N::Int, t::Int)
#     v = 0
#     for i in 1:N
#         v += c4t(N, i, t)
#     end

#     v 

# end


cs_0 = c4t_sum.(N, t, false)
cs_1 = c4t_sum.(N, t, true)

b1 = @. B1(N, 2*t+1)
upp =  @. sqrt(pi) * Gamma_term(2t+1) - B2(N, 2t+1)

cs0_label = L"2 \sum \frac{\pi}{N} \cos^{4t+2} \left(\frac{m \pi}{N} \right)" 
cs1_label = L"2 \sum \frac{\pi}{N} \cos^{4t+2} \left(\frac{(2m-1) \pi}{2N} \right)"

plot(
    t,
    [cs_0, cs_1, b1, upp],
    label=[ cs0_label cs1_label "Lower bond" "Upper bond"],
    title="N = $N"
    )


#%% test Theorem 1

pp_full = PP_full.(N, t)
pp_neat = PP_neat.(N, t)
upp = U.(N, t)
loww = L.(N, t)

# plot(
#     t,
#     [pp_full, upp, loww],
#     label=["Full" "Upper bond" "Lower bond"],
#     title="N = $N"
#     )

# plot(t, [pp_full, upp, loww])
plot(t, [pp_full, pp_neat])