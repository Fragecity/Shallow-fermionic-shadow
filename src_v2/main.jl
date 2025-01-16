include("Spread.jl")
include("Utils.jl")

using .PolySpreads
using .FormulaUtils


#%%
N = 6
init = (1,N)
t = 80

spreaded = poly_spread_N(N, init,t)

sum(spreaded) do pair
    if pair[1][1] == pair[1][2]
        return pair[2]
    else
        return 0   
    end
end / 3

1/23

new_dct = Dict()
not_around0(pair) = abs(pair[2]) < 1e-15 ? false : true
select_diag(pair) = pair[1][1] == pair[1][2]


for (key, value) in spreaded
    if key[1] == key[2]
        push!(new_dct, key => value- PP(N, key..., t) )
    else
        PPvalue = PP(N, key..., t) + PP(N, key[2], key[1], t)
        new_value = value - PPvalue
        push!(new_dct, key => new_value)
    end
    # push!(new_dct, key => value - PP(N, key..., t) )
end

spreaded[(3,4)] - PP(N, 3,4, t) - PP(N, 4,3, t)

filter!(not_around0, new_dct)

dct_diag = filter(select_diag, new_dct)
dct_offdiag = mergewith(-, new_dct, dct_diag) 
filter!(not_around0, dct_offdiag)

for (key, value) in dct_offdiag
    println(key, " => ", value)
end

# sum(new_dct) do pair
#     pair[2]
# end

#%% 

using .Iterators

# for i in product(1:N, 1:N)
#     println(i[1])
# end

sum(spreaded) do pair
    pair[2]
end

sum(product(1:N, 1:N)) do tup
    PP(N, tup..., t)
end


poly_spread_N(16, (3,6), 1)
