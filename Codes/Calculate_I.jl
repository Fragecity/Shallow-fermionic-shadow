#%% Using packages
using Symbolics, LinearAlgebra

#%% Global variables
const N = 6


#%% Define the function
# I = Symbolics.variables(:I, 1:N, 1:N)

# S[1, 1] = - sqrt(5)
# S[1, 2] = S[2, 1] = sqrt(5)

I = Symbolics.variables(:I, 1:N)

I_vec = let diag_ele(i) = (i+1)÷2, near(i) = (i÷2, i÷2 +1)
    [ i%2==1 ? I[diag_ele(i)] : I[near(i)[1]] + I[near(i)[2]] for i in 1:2N-1]
end

S = diagm([-1.0 for i in 1:N])
S[1,:]

#%%
# function ⊗(a,b)
#     return kron(a,b)
# end


#%% isometric between matrix and vector
φ(i::Int, j::Int) = N*i + j
φ⁺(k::Int) = (k÷N, k%N)

#%% build maping in matrix
@variables x0, x1, x2, y0, y1, y2

function F(i, x)
    if x == "x"
        v0, v1, v2 = x0, x1, x2
    else
        v0, v1, v2 = y0, y1, y2
    end 

    if i == 1
        return 3/4 * v1 + 1/4 * v2
    elseif i == N
        return 3/4 * v1 + 1/4 * v0
    else
        return 1/4*v0 + 2/4 * v1 + 1/4 * v2
    end

end

function spread((i,j))
    rst = Dict()
    f = F(i, "x") * F(j, "y") |> expand
    
    dxy00 = Differential(x0) * Differential(y0)
    dxy10 = Differential(x1) * Differential(y0)
    dxy20 = Differential(x2) * Differential(y0)
    dxy01 = Differential(x0) * Differential(y1)
    dxy11 = Differential(x1) * Differential(y1)
    dxy21 = Differential(x2) * Differential(y1)
    dxy02 = Differential(x0) * Differential(y2)
    dxy12 = Differential(x1) * Differential(y2)
    dxy22 = Differential(x2) * Differential(y2)

    


    return rst
end
