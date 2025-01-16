include("runKiteav.jl")
include("NewGaussian.jl")
using Serialization: serialize, deserialize
struct KCdata
	depth::Number
	samples::Int
	data::Vector
end


samples = [35112]
# samples = [1024, 2048, 4096, 6648, 10088, 14256, 20168, 26608, 35112]
single_shots = 8
depth = 3
n = 10
batchs = 64 ÷ 16

mu = 2
delta = 1
t = 0.4

path = "./improve_src/data/"
reg = open(path * "reg_n10.dat", "r") do io
	deserialize(io)
end

KCFCSdata = open(path * "KCFCSdata.dat", "r") do io
	deserialize(io)
end



hamil = KiteavChain_hamiltonian_S(n, mu, delta, t)
hamil_yao = get_hamil_Yao(hamil, n)

for (k, shots) in enumerate(samples)


	println("Begin FCS , samples = $shots")
	for batchid in 1:batchs
		# f() = run_FCS(hamil, reg, shots, single_shots)
		FCSdata = statistic_results(() -> run_FCS(hamil, reg, shots, single_shots))
		kcdata = KCdata(Inf, shots, FCSdata)
		push!(KCFCSdata, kcdata)
		print("\rProgress: $(batchid/batchs *100) % ")

		open(path * "KCFCSdata.dat", "w") do io
			serialize(io, KCFCSdata)
		end
	end
	println("\n")
end

# theoretical_data = let hamil_yao_lst = get_hamil_Yao.(hamil_lst, n)
#     [expect(ham, reg) for ham in hamil_yao_lst  ]
# end

# open(path*"KCtheory.dat", "w") do io
#     serialize(io, theoretical_data)
# end