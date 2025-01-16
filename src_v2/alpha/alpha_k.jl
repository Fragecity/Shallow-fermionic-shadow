using Memoization

@memoize function theoretical_prediction_k2(i, j, d, n)
	t = (d - 1) ÷ 2
	i, j = (i - 1) ÷ 4 + 1, (j - 1) ÷ 4 + 1
	a = abs(i - j)
	b = i + j - 1
	N = n ÷ 2
	f(x, k) = ℯ^(-(2k * N + x)^2 / 2t)
	return 1 / sqrt(2π * t) * sum(-d*n ÷ 10 : d*n ÷ 10) do k
		f(a, k) + f(b, k)
	end
end

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

function alpha_theory(S, t, n)
	res = 1 / prod(1:2:length(S)-1) * sum(pair_partition(S)) do partition
		prod(theoretical_prediction_k2(i, j, t, n) for (i, j) in partition)
	end
    k = length(S) ÷2
    c = (n/2)^k  * binomial(n, k) / binomial(2n, 2k) 
    return c*res
end