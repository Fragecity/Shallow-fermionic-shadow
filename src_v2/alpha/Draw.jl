include("alpha.jl")
include("alpha_k.jl")
using Combinatorics, Plots, LaTeXStrings

# function rand_color(num_color, hue_range = 1:360, saturation = 1, lightness = 0.7)
# 	hues = rand(1:360, num_color)
    
# 	return [RGB(HSL(h, saturation, lightness)) for h in hues]
# end

# rand_color() = rand_color(1)[1]

function rand_color(hue = 200, saturation = 1, lightness = 0.6)
    hue = rand(max(hue - 40, 1) : min(hue+40, 360))
    saturation = rand(max(saturation - 0.2, 0) : min(saturation+0.2, 1))
    lightness = rand(max(lightness - 0.2, 0.4) : min(lightness+0.2, 1))
    RGB(HSL(hue, saturation, lightness))
end



function plotting!(p, S, n, x_axis)
	curve_1 = [alpha(S, i, n) for i in x_axis]
	curve_1_theory = [alpha_theory(S,i,n) for i in x_axis]
	color = rand_color(rand(45:135), 0.9, 0.5)
    dint = diff(S) |> maximum
	p = plot!(p, 
        x_axis, 
        curve_1_theory, 
        color = color, 
        alpha=1,
        markerstrokewidth=0, 
        label= L"d_{\mathrm{int}} = %$dint" ,
        width = 1.6
        # label= "123" ,
        )
	scatter!(p, x_axis, curve_1, color = color, alpha=0.8, markerstrokewidth=0.5, width=1.2, label=false)
	# p = plot!(p, x_axis, curve_1_theory, alpha=1,markerstrokewidth=0, legend=false, width = 1.2)
	# scatter!(p, x_axis, curve_1, alpha=0.8, markerstrokewidth=0.5, width=1.2, legend=false)
	return p
end


# %%

# figure = plot(title="Proposed \\alpha'_{S,d} curve vs true \\alpha_{S,d} data", xlabel="depth", ylabel="\\alpha_{S,d}")
figure = plot(size = (650,160))
n=6; k=1;
x_axis = 5:2:21
# for _ in 1:4
# S = (rand ∘ collect ∘ combinations)(1:2n, 2k)
S = [1, 4]
println(diff(S) |> maximum )
plotting!(figure, S, n, x_axis)
S = [4, 10]
println(diff(S) |> maximum )
plotting!(figure, S, n, x_axis)
S = [6,10]
println(diff(S) |> maximum )
plotting!(figure, S, n, x_axis)
# println(S)

# end
figure


#%% 
figure = plot(size = (650,160))
n=6; k=3;
x_axis = 5:2:21
S =   [1, 2, 5, 6, 7, 12]
plotting!(figure, S, n, x_axis)
S =   [1, 3,4,10,11,12]
plotting!(figure, S, n, x_axis)
S =   [1, 3,4,5,7,8]
plotting!(figure, S, n, x_axis)
# S = (rand ∘ collect ∘ combinations)(1:2n, 2k)
figure
# S = (rand ∘ collect ∘ combinations)(1:2n, 2k)

#%% 
figure = plot(size = (650,160))
n=12; k=1;
x_axis = 7:2:33
S = [18,22]
plotting!(figure, S, n, x_axis)
S = [1,17]
plotting!(figure, S, n, x_axis)
S = [2,10]
plotting!(figure, S, n, x_axis)
S = [2,14]
plotting!(figure, S, n, x_axis)
figure

#%% 
figure = plot(size = (650,160))
n=12; k=4;
x_axis = 7:2:33
S = [3, 7, 9, 11, 14, 16,17, 22]
plotting!(figure, S, n, x_axis)
# S = [1,2,4,15,17,20,21,22]
# plotting!(figure, S, n, x_axis)
# S = [1,2, 4,9, 17, 18, 19, 20, 22, 23]
# plotting!(figure, S, n, x_axis)
S = [3,4, 7,8,  13, 14, 20, 21, 23, 24]
plotting!(figure, S, n, x_axis)
S = [7,10, 14,15, 17, 20, 21, 23]
plotting!(figure, S, n, x_axis)
S = [10,13,14,17,19,21,23,24]
plotting!(figure, S, n, x_axis)
figure