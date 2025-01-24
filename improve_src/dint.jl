using Plots, LaTeXStrings
# include("NewGaussian.jl")
include("alpha_tensor.jl")
include("alpha.jl")
# include("runKiteav.jl")


n = 10
x_axis = 9:2:55
function plottingDint!(p, S, color)
	curve_1 = [alpha(S, i, n) for i in x_axis]
	curve_1_theory = [alpha_theory(S,i,n) for i in x_axis]

	p = plot!(p, 
        x_axis, 
        curve_1_theory, 
        color = color, 
        alpha=1,
        markerstrokewidth=0, 
        label= "S = $S" ,
        width = 1.6
        )
	scatter!(p, x_axis, curve_1, color = color, markerstrokewidth=0, width=1.6, label=false)
	return p
end

colors = [RGB(165/255,28/255,54/255), RGB(122/255, 187/255, 219/255), RGB(132/255, 186/255, 66/255), RGB(104/255, 36/255, 135/255)]


figure = Plots.plot(size = (800,600))
S1 = [1 6 11 16]
plottingDint!(figure, S1, colors[1])
S2 = [9 10 13 18]
plottingDint!(figure, S2, colors[2])
S3 = [1 6 19 20]
plottingDint!(figure, S3, colors[3])
S4 = [3 9 15 20]
plottingDint!(figure, S4, colors[4])

Plots.title!(L"d_{\mathrm{int}}=5")
Plots.ylabel!(L"\alpha_{S,d}", ylabelfontsize = 16)
Plots.xlabel!("depth", ylabelfontsize = 20)
Plots.pdf("fix_dint.pdf")