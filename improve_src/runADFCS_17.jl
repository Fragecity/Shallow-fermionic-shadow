include("NewGaussian.jl")
include("alpha_tensor.jl")
include("runKiteav.jl")

using Serialization: serialize, deserialize
using Distributed

struct CSdata
	Sname::String
	S::Vector
	depth::Number
	samples::Int
	data::Vector
end


n = 10

S_names = ["k6d13"]
S_lst = [[3, 16, 17, 18, 19, 20]]
# S_names = ["k2d3", "k2d9", "k4d6", "k4d15", "k6d4", "k6d13"]
# S_lst = [[9, 12], [5, 14], [1, 7, 13, 19], [3, 18, 19, 20], [1, 5, 9, 13, 17, 20], [3, 16, 17, 18, 19, 20]]
hamil_lst = [Dict(S => 1.0) for S in S_lst]

samples = [(32768, 8)]
# samples = [(1024, 8), (2048, 8), (4096, 8), (8192, 8), (16384, 8), (32768, 8)]

depth = 17



# reg = rand_state(n)
path = "./improve_src/data/"
reg = open(path * "reg_n10.dat", "r") do io
	deserialize(io)
end

function cal__ADFCS(hamil, bs, perm, cycles_lst, d, n, alp)
	res = 0.0
	for (S, coeff_hamil) in hamil
		S_acted = FGUcliff_apply(S, perm)

		S_acted, swaps = bubble_sort_with_swaps(S_acted)

		coeff = (-1)^swaps * coeff_hamil / alp / length(bs) * accum_phase(cycles_lst, S, n)

		res += sum(bs) do b
			expect_bgamma(b, S_acted)
		end * coeff
	end
	# println(accum_phase(cycles_lst, S_acted,n)) 
	return res
end

run_s_ADFCS(hamil, reg, d, single_shots, alp) = begin
	n = nqubits(reg)
	L = (n - 1) * (d ÷ 2) + n ÷ 2
	perms, cyc_lst = rand_n_local_perms(L)
	# println(perms, "\t", n)
	U, perm = ADFCS_U(perms, cyc_lst, n)
	reg2 = apply(reg, U)
	bs = measure(reg2, nshots = single_shots)
	cal__ADFCS(hamil, bs, perm, cyc_lst, d, n, alp)
end

function run_ADFCS(hamil, reg, d, shots, single_shots, alp)
	n = nqubits(reg)
	# println("$d  \n")
	@assert isodd(d)
	@assert iseven(n)

	res = 0.0
	L = (n - 1) * (d ÷ 2) + n ÷ 2
	r, m = divrem(shots, single_shots)

	for _ in 1:r
		res += run_s_ADFCS(hamil, reg, d, single_shots, alp)
	end
	for _ in 1:m
		res += run_s_ADFCS(hamil, reg, d, 1, alp)
	end
	return res / (r + m)
end

ADFCSdata = open(path * "ADFCSdata$depth.dat", "r") do io
	deserialize(io)
end

batchs = 64 ÷ 16


for (Sname, S, hamil) in zip(S_names, S_lst, hamil_lst)
  
	alp = alpha(S, depth, n)
	println("The alpha is $alp")
	for (shots, single_shots) in samples
		println("Begin $Sname , depth = $depth, samples = $shots")
		for batchid in 1:batchs
			data = statistic_results(() -> run_ADFCS(hamil, reg, depth, shots, single_shots, alp))
			cs = CSdata(Sname, S, depth, shots, data)
			print("\rProgress: $(batchid/batchs *100) % ")
			push!(ADFCSdata, cs)
			open(path * "ADFCSdata$depth.dat", "w") do io
				serialize(io, ADFCSdata)
			end
		end
		println("\n")
	end
end
