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

S_names = ["k2d9"]
S_lst = [[5, 14]]
# S_names = ["k2d3", "k2d9", "k4d6", "k4d15", "k6d4", "k6d13"]
# S_lst = [[9, 12], [5, 14], [1, 7, 13, 19], [3, 18, 19, 20], [1, 5, 9, 13, 17, 20], [3, 16, 17, 18, 19, 20]]
hamil_lst = [Dict(S => 1.0) for S in S_lst]

samples = [(32768, 8)]
# samples = [(1024, 8), (2048, 8), (4096, 8), (8192, 8), (16384, 8), (32768, 8)]
depths = [5, 9, 15, 19, 23]


# reg = rand_state(n)
path = "./improve_src/data/"
reg = open(path * "reg_n10.dat", "r") do io
	deserialize(io)
end

FCSdata = open(path * "FCSdata.dat", "r") do io
	deserialize(io)
end


batchs = 64 ÷ 16
for (Sname, S, hamil) in zip(S_names, S_lst, hamil_lst),
	(shots, single_shots) in samples


	println("Begin $Sname , samples = $shots")
	for batchid in 1:batchs
		data = statistic_results(() -> run_FCS(hamil, reg, shots, single_shots))
		cs = CSdata(Sname, S, Inf, shots, data)
		print("\rProgress: $(batchid/batchs *100) % ")
		push!(FCSdata, cs)

		open(path * "FCSdata.dat", "w") do io
			serialize(io, FCSdata)
		end
	end
	println("\n")

end


# theoretical_data = let hamil_yao_lst = get_hamil_Yao.(hamil_lst, n)
#     [expect(ham, reg) for ham in hamil_yao_lst  ]
# end

# open(path*"theory.dat", "w") do io
#     serialize(io, theoretical_data)
# end