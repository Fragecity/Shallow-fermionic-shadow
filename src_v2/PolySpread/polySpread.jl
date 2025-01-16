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

function poly_spread_N(N::Int64, init::Tuple, t::Int64)
    # dct_N = Dict(init => 1//1)
    dct_N = Dict(init => 1.0)
    dct_2N = isometric_inv(dct_N)

    for i in 1:t
        dct_2N = tuple_spread_utils(dct_2N, "odd", 2*N)
        dct_2N = tuple_spread_utils(dct_2N, "even", 2*N)
    end
    dct_N = isometric(dct_2N, N)

    return filter(pair -> pair[2] != 0, dct_N)
end

function free_spread_tup(tup, location, N)
    res = Dict()
    
    tup = [tup...]
    # coeff = pair[2]

    i = tup[location]
    
    
    if i == 1
        spread_tup_right = deepcopy(tup)
        spread_tup_right[location] = 2
        # spread_tup_right = SpreadUtils.ordered(spread_tup_right...)
        res = Dict(Tuple(tup)=>  3//4,  Tuple(spread_tup_right) =>  1//4)
    elseif i == N
        spread_tup_left = deepcopy(tup)
        spread_tup_left[location] = N-1
        # spread_tup_left = SpreadUtils.ordered(spread_tup_left...)
        res = Dict(Tuple(tup)=>  3//4,  Tuple(spread_tup_left) =>  1//4)
    else
        spread_tup_left = deepcopy(tup)
        spread_tup_left[location] = i-1
        spread_tup_right = deepcopy(tup)
        spread_tup_right[location] = i+1

        # spread_tup_left = SpreadUtils.ordered(spread_tup_left...)
        # spread_tup_right = SpreadUtils.ordered(spread_tup_right...)
        res = Dict(Tuple(tup)=>  1//2,  Tuple(spread_tup_left) =>  1//4, Tuple(spread_tup_right) =>  1//4)
    end

    return res
end


function free_spread(diction, N)
    res = Dict()
    for (key, value) in diction
        spread1 = free_spread_tup(key, 1, N)
        for (key2, value2) in spread1
            spread2 = free_spread_tup(key2, 2, N)
            for (key3, value3) in spread2
                key3 = ordered(key3...)
                new_dict = Dict(key3 => value3*value2*value)
                mergewith!(+, res, new_dict)
                # push!(res, ) 
            end
        end
    end
    return res
end


function free_spread(diction, t, N)
    for i in 1:t
        diction = free_spread(diction, N)
    end
    return diction
end

# res = free_spread(Dict((1,2)=>1), 1, 4)


function spread_from_status(board, N)
    res = Dict()
    for (key, value) in board
        new_dict = poly_spread_N(N, key, 1)
        new_dict = Dict( newkey => value*newvalue for (newkey, newvalue) in new_dict  )
        res = mergewith(+, res, new_dict)
    end
    return res
end

#%%

# N = 16
# t = 1
# # init = (1,8)

# dictt = Dict((7,7) => 1//1, (7,8) => 4//1, (8,8) => 1//1)

# res = tuple_spread_utils(dictt, "odd", N)
# res = tuple_spread_utils(res, "even", N)


# l = []
# for (key, value) in res
#     if key[1] == 4
#         push!(l, key => value)
#     end
# end
# sort!(l, by = x -> x[1][2])

# res = isometric(res, N)
# res = filter(pair -> pair[2] != 0, res)
# basis_map_inv()
# res = poly_spread_N(N, init, t)
# free_spread(Dict(init=>1), N)

# # mergewith!(-, res, free_spread(Dict(init=>1), N))


# #%% 

# init_board = Dict((2,2)=>-1, (2,3)=>1, (3,2)=>1, (3,3)=>-1)
# free_spread(init_board, N)

# #%%

# res = poly_spread_N(8, (1,2), 60)
# s = 0
# for (key, value) in res
#     if key[1] == key[2]
#         s += value
#     end 
# end
# print(s)



#%% assumptions 


