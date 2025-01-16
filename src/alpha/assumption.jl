include("alpha.jl")

function C(i, j, μ, η, d, n)
    tensors, idx = evolved_state_tensornet([i,j],d,n)
    measure_lst = []
    for k in 1:n
        if k<μ || k>η
            push!(measure_lst, [1, 0, 0])
        elseif k == μ || k == η
            push!(measure_lst, [0, 1, 0])
        else
            push!(measure_lst, [0, 0, 1])
        end
    end

    ncon((tensors..., measure_lst...), (idx..., map(x -> [x], d*n+1 : n*(d+1))...))
end

function L(i, μ, t, n)
    N = n÷2
    return 1/3/N + 1/3/n * sum(1: N-1) do k
        cos((μ-1/2)*(π*k)/N) * cos((i-1/2)*(π*k)/N) * cos((π*k)/n)^(2t)
    end
end

function residual(i, j, μ, η, t, n)
    d = 2t-1
    return C(i, j, μ, η, d, n) - L(i, μ, t, n) * L(j, η, t, n)
end

residual(μ, η) = residual(1, 3, μ, η, 3, 6)

C(1,3,2,2,1,2)