include("polySpread.jl")

using Dates
using Plots
using Serialization
function plot_heatmap(N, t, init, title = "")
	res = poly_spread_N(N, init, t)
	res2 = free_spread(Dict(init => 1.0), t, N)

	mergewith!(-, res, res2)

	mat = zeros(N, N)

	for i in 1:N, j in 1:N
		mat[i, j] = 1 / 2 * (get(res, (i, j), 0) + get(res, (j, i), 0))
	end
	p = heatmap(-mat, title = title, c = :acton, colorbar = false, clims = (-0.1, 0.1))
	return p

	# Plots.pdf(p, "figures/assumptions/heatmap_$formatted_datetime.pdf")
end

ps = []
while length(ps) < 20

	N = rand(8:26)
	init = Tuple(sort(rand(1:2N, 2)))
	if init[1] > init[2]-2 || isempty(2*(init[2] - init[1]) :2N)
		continue
	end
	t = rand( 2*(init[2] - init[1]) :2N)
	name = "N=$N, t=$t, i=$(init[1]), j=$(init[2])"
	res = poly_spread_N(N, init, t)
	res2 = free_spread(Dict(init => 1.0), t, N)

	mergewith!(-, res, res2)

	mat = zeros(N, N)

	for i in 1:N, j in 1:N
		mat[i, j] = 1 / 2 * (get(res, (i, j), 0) + get(res, (j, i), 0))
	end
    # pin
    if sum(abs.(mat))<1e-5 || abs(sum(mat))>1e-10
        continue
    end
	# p = heatmap(-mat, title = name, c = :bluesreds, colorbar = false, clims = (-0.0005, 0.0005))
	p = heatmap(-mat, title = name, c = :bluesreds, colorbar = false)
	# p = heatmap(-mat, title = name, c = :acton)
	push!(ps, p)
end


open("./data/assumption_figures.dat", "w") do io
    serialize(io, ps)
end

p = plot(ps..., layout = (5, 4), size = (1120, 1120))


N = 16
t = 80
init = (1, 16)

p = plot_heatmap(N, t, init)
# display()
current_datetime = now()
formatted_datetime = Dates.format(current_datetime, "mm-dd_HH-MM")
Plots.pdf(p, "heatmap_$formatted_datetime.pdf")


cgrad(:acton)