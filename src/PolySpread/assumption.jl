include("polySpread.jl")

using Dates 
function plot_heatmap(N,t, init, title = "")
    res = poly_spread_N(N, init, t)
    res2 = free_spread(Dict(init=>1.0),t, N)

    mergewith!(-, res, res2)

    mat = zeros(N,N)

    for i in 1:N, j in 1:N
        mat[i,j] = 1/2*(get(res, (i,j), 0) + get(res, (j,i), 0) )
    end
    p = heatmap(mat, xlabel="i", ylabel="j", title=title)
    
    current_datetime = now()
    formatted_datetime = Dates.format(current_datetime, "mm-dd_HH-MM")
    Plots.pdf(p, "figures/assumptions/heatmap_$formatted_datetime.pdf")
end

N = 16
t = 80
init = (1,16)

p = plot_heatmap(N,t, init)

