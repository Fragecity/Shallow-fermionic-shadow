include("alpha.jl")
using Combinatorics, Random
using Plots

function pair_partition(S)
	if length(S) == 2
		return [[(S[1], S[2])]]
	else
		res = []
		for i in 2:length(S)
			pair = (S[1], S[i])
			rest = setdiff(S, pair)
			rest_partition = pair_partition(rest)
			push!.(rest_partition, [Tuple(pair)])
			append!(res, rest_partition)
		end
		return res
	end
end


theory(S, t, n) = begin
	res = 1 / prod(1:2:length(S)-1) * sum(pair_partition(S)) do partition
		prod(theoretical_prediction_k2(i, j, t, n) for (i, j) in partition)
	end
	k = length(S) ÷ 2
	c = (n / 2)^k * binomial(n, k) / binomial(2n, 2k)
	return c * res
end


function rand_color(num_color, saturation = 0.8, lightness = 0.5)
	hues = range(1:360, length = num_color)
	return [RGB(HSL(h / 360, saturation, lightness)) for h in hues]
end

rand_color() = rand_color(1)[1]


function plotting!(p, n, k)
    S = (rand ∘ collect ∘ combinations)(1:2n, 2k)
    x_axis = 3:2:21
	curve_1 = [alpha(S, i, n) for i in x_axis]
	curve_1_theory = [theory(S,i,n) for i in x_axis]
	color = rand_color()
	p = plot!(p, x_axis, curve_1_theory, color = color)
	scatter!(p, x_axis, curve_1, color = color)
	return p
end


# %%

figure = plot()
for n in 6:2:10, _ in 1:4
	k = rand(1:n)
	figure = plotting!(figure, n, k)
end
plotting!(figure, 10, 2)
