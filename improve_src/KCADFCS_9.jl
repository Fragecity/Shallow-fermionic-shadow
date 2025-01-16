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
n = 10
batchs = 64 ÷ 16

mu = 2
delta = 1
t = 0.4
path = "./improve_src/data/"


depth = 9
file = path * "KCADFCSdata$depth.dat"
reg = open(path * "reg_n10.dat", "r") do io
	deserialize(io)
end

ADKCFCSdata = open(file, "r") do io
	deserialize(io)
end


for (k, shots) in enumerate(samples)

	hamil = KiteavChain_hamiltonian_S(n, mu, delta, t)
	hamil_yao = get_hamil_Yao(hamil, n)

	println("Begin FCS , samples = $shots, depth = $depth")
	for batchid in 1:batchs
		ADFCSdata = statistic_results(() -> run_ADFCS(hamil, reg, depth, shots, single_shots))
		kcdata = KCdata(Inf, shots, ADFCSdata)
		push!(ADKCFCSdata, kcdata)
		print("\rProgress: $(batchid/batchs *100) % ")

		open(file, "w") do io
			serialize(io, ADKCFCSdata)
		end
	end
    println("\n")
end

