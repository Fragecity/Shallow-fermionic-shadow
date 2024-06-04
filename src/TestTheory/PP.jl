module AnalysisPP
export Lemma_1_2
using Integrals

function Lemma_1_2(N, T)
	# N = 200
	function F(T)
		f(u, p) = cos(u * pi / N)^T
		domain = (1, N / 2 - 1)
		prob = IntegralProblem(f, domain)
		solve(prob, HCubatureJL(); reltol = 1e-3, abstol = 1e-3).u
	end
	# T = 300

	g(x) = cos(x * pi / N)^(T - 1) * sin(x * pi / N) * N / pi / (T)

	diff = (T - 1) / (T) * F(T - 2) + g(N / 2 - 1) - g(1) - F(T)
	
	return diff
end

# function try_test()
# 	print("Hello")
# end


end # module AnalysisPP


#%% Main
using .AnalysisPP
N = 20
T = 30                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
AnalysisPP.Lemma_1_2(N,T)

