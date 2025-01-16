include("NewGaussian.jl")
include("alpha_tensor.jl")
include("runKiteav.jl")

using Serialization: serialize, deserialize
using Distributed
# addprocs(31)
# @everywhere 
# function f()
#     return (rand(), rand())  # 示例函数，返回一对随机浮点数
# end
# results = pmap(f, 1:32)
# println(results)

struct CSdata
    Sname::String
    depth::Number
    samples::Int
    mean::Number
    var::Number
end

# a = [CSdata("a", 1, 2,3,4)]
# open("./data/mydata.dat", "w") do io
#     serialize(io, a)
# end


n = 10

S_names = ["ends", "close", "all", "sep5", "rand2", "rand4"]
S_lst = [[1, 20], [10,11], collect(1:20), collect(1:5:20), [9, 11,12,20], [2,6,9,10,11,12,15,16]]
# S_names = ["all", "sep5"]
# S_lst = [collect(1:20), collect(1:5:20)]
# S_names = ["rand2", "rand4"]
# S_lst = [[9, 11,12,20], [2,6,9,10,11,12,15,16]]
hamil_lst = [Dict(S => 1.) for S in S_lst]

samples = [(1024, 2), (2048, 4), (4096,4), (8192, 8), (16384, 8), (32768, 16)]

depths = [5, 9, 15, 19, 23]



# reg = rand_state(n)
reg = open("./data/reg.dat", "r") do io
    deserialize(io)
end


theoretical_data = let hamil_yao_lst = get_hamil_Yao.(hamil_lst, n)
    [expect(ham, reg) for ham in hamil_yao_lst  ]
end
# %%
FCS_data = []

for (Sname,hamil) in zip(S_names, hamil_lst),
    (shots, single_shots) in samples
    
    println("Begin $Sname , samples = $shots")

    FCS_mean, FCS_var = statistic_results(()->run_FCS(hamil, reg, shots, single_shots))
    data = CSdata(Sname, Inf, shots, FCS_mean, FCS_var)
    push!(FCS_data, data)
    println("$Sname , samples = $shots DONE")

end

open("./data/FCSdata_new.dat", "w") do io
    serialize(io, FCS_data)
end


function cal__ADFCS(hamil, bs, perm, cycles_lst, d, n, alp)
	res = 0.0
	for (S, coeff_hamil) in hamil
		S_acted = FGUcliff_apply(S, perm)

		S_acted, swaps = bubble_sort_with_swaps(S_acted)

		coeff = (-1)^swaps * coeff_hamil / alp / length(bs) * accum_phase(cycles_lst, S,n) 

		res += sum(bs) do b
			expect_bgamma(b, S_acted)
		end * coeff 
	end
	# println(accum_phase(cycles_lst, S_acted,n)) 
	return res 
end

run_s_ADFCS(hamil,reg,d, single_shots, alp) = begin
	n = nqubits(reg)
	L = (n-1) * (d÷2) + n÷2
	perms, cyc_lst = rand_n_local_perms(L)
    # println(perms, "\t", n)
    U, perm = ADFCS_U(perms, cyc_lst, n)
	reg2 = apply(reg, U)
    bs = measure(reg2, nshots = single_shots);
	cal__ADFCS(hamil, bs, perm, cyc_lst, d,n, alp)
end

function run_ADFCS(hamil,reg, d, shots, single_shots,alp)
	n = nqubits(reg)
    # println("$d  \n")
	@assert isodd(d)
	@assert iseven(n)

	res = 0.
	L = (n-1) * (d÷2) + n÷2
	r, m = divrem(shots, single_shots)

	for _ in 1:r
		res += run_s_ADFCS(hamil,reg,d, single_shots, alp)
	end
	for _ in 1:m
		res += run_s_ADFCS(hamil,reg,d, 1, alp)
	end
	return res / (r+m)
end

ADFCS_data = []


for (Sname,S, hamil) in zip(S_names, S_lst, hamil_lst),
    depth in depths
    alp = alpha(S, depth, n)
    println("The alpha is $alp")
    for (shots, single_shots) in samples
    
    ADFCS_mean, ADFCS_var = statistic_results(()->run_ADFCS(hamil, reg, depth, shots, single_shots, alp))
    data = CSdata(Sname, depth, shots, ADFCS_mean, ADFCS_var)
    push!(ADFCS_data, data)
        println("""
        Finish working on $Sname
        parameters are shots = $shots, depth = $depth
        results are $ADFCS_mean, $ADFCS_var
        """)
end
end


# open("./data/ADFCSdata_rand.dat", "w") do io
    # serialize(io, ADFCS_data)
# end
# ADFCS_data_new = open("./data/ADFCSdata_ends_close.dat", "r") do io
#         deserialize(io)
#     end

# append!(ADFCS_data_new, ADFCS_data)