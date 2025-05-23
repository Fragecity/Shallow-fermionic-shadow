#%% 
using TOML, DataFrames, CSV
using Yao

include("IOutils.jl")
include("runKiteav.jl")
include("NewGaussian.jl")

config = TOML.parsefile("./jl_src/config.toml")


column_names = let
	column_names = ["Samples"]
	append!(column_names, [s for i in config["num_qubits"] for s in ("Theory_n=$(i)", "FCS_n=$(i)_mean", "FCS_n=$(i)_var")])
	append!(column_names, [s for n in config["num_qubits"]
						   for d in config["depths"]
						   for s in ("ADFCS_n=$(n)_d=$(d)_mean", "ADFCS_n=$(n)_d=$(d)_var")])
	column_names
end



function create_datafile(column_names)
	df = DataFrame([Symbol(name) => Float16[] for name in column_names])

	filename = save_data(df)
	return filename
end


function main()
    file = create_datafile(column_names)

	shots = 262144
    single_shots = 512
    # shots =20
    # single_shots = 1
    

    datas = Dict(Symbol("Samples")=>Float16(shots))
    for n in config["num_qubits"]
        reg = rand_state(n)
        hamil = KiteavChain_hamiltonian_S(n, config["mu"], config["delta"], config["t"])
        hamil_yao = get_hamil_Yao(hamil, n)

        theory = Symbol("Theory_n=$n")=>expect(hamil_yao, reg)
        push!(datas, theory)
        
        println("n=$(n)")
        println("working on FCS data")
        FCS_mean, FCS_var = statistic_results(()-> run_FCS(hamil, reg, shots, single_shots))
        merge!(datas, Dict(Symbol("FCS_n=$(n)_mean")=>FCS_mean, Symbol("FCS_n=$(n)_var")=>FCS_var))
        
        for depth in config["depths"]
            println("working on ADFCS data \t depth = $depth")
            ADFCS_mean, ADFCS_var = statistic_results(()->run_ADFCS(hamil, reg, depth, shots, single_shots))
            merge!(datas, Dict(Symbol("ADFCS_n=$(n)_d=$(depth)_mean")=>ADFCS_mean, Symbol("ADFCS_n=$(n)_d=$(depth)_var")=>ADFCS_var))
            println("ADFCS_n=$(n)_d=$(depth) DONE!" )
        end
    end
    datas = DataFrame(datas)
    write_data!(file, datas)
	
end

main()
