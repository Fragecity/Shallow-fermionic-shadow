using Plots

include("alpha.jl")

n = 10
alpha(S,d) = alpha(S,d, n)
x_axis = 3:2:5n
fitting_coeff = n/(2n-1)/2

function plotting_k2!(p, S, color)
    curve_1 = [alpha(S, i) for i in x_axis]
    curve_1_theory = [fitting_coeff*theoretical_prediction_k2(S[1],S[2],i,n) for i in x_axis]
    p = plot!(p, x_axis,curve_1_theory, color = color)
    scatter!(p, x_axis,curve_1, color = color)    
    return p
end
p = plot()
p = plotting_k2!(p, [1,2], :blue)
p = plotting_k2!(p, [1,20], :red)
p = plotting_k2!(p, [1,5], :green)
title!("compare c\\alpha_{S,d}^L with \\alpha_{S,d}")
xlabel!("depth")                   
ylabel!("\\alpha_{S,d}") 

Plots.pdf(p, "figures/alphaS/alpha_2.pdf")


# plot([alpha([1,20], i) for i in x_axis])
# plot!([fitting_coeff*theoretical_origin_k2(1,20,i,n) for i in x_axis])
