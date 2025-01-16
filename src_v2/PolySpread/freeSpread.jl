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
                new_dict = Dict(key3 => value3*value2*value)
                mergewith!(+, res, new_dict)
            end
        end
    end
    return res
end

#%%


function dic2mat(dict)
    x_lst = []
    y_lst = []
    for key in keys(dict)
        push!(x_lst, key[1])
        push!(y_lst, key[2])
    end
    x_min = min(x_lst...)
    x_max = max(x_lst...)
    y_min = min(y_lst...)
    n = x_max-x_min+1
    mat = zeros(n, n)

    for (key, value) in dict
        mat[key[1]-x_min+1, key[2]-y_min+1] = value
    end

    return mat
end

init = Dict((8,8)=>-1//1, (8,9)=>1//1, (9,8)=>1//1, (9,9)=>-1//1)
res = free_spread(init, 16)
res = free_spread(res, 16)
dic2mat(res)


# function freeSpread_1d_forward(dict)
#     for 
# end