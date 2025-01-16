#%%

include("RandomCircuit.jl")
include("ClassicalShadow.jl")
include("alpha.jl")
include("Hamiltonian.jl")


using Base.Threads
using Statistics

#%%
function run_Kiteav_ADFCS(state_reg, num_qubit, depth, shots, single_shots, hamiltonian)
	local_FGU_sampler(i) = begin
		# _, U = new_rand_FGUclifford(2)
		_, U = random_FGUclifford(2)
		return U
	end
	ADFCS_sampler() = begin
		skelon = hardware_efficient_skelon(num_qubit, depth)
		sample_qcirc(local_FGU_sampler, skelon, num_qubit)
	end

	res = 0.0
	for (i, op_pair) in enumerate(hamiltonian)
		alpha = alpha_theory(op_pair.first, depth, num_qubit)
		pstring = jordan_wigner(op_pair.first, num_qubit)
		op = pauli_string2Yaoblock(pstring)
		res = res + shadow_expval(state_reg, ADFCS_sampler, op, alpha, shots, single_shots) * op_pair.second
	end
	return res
end

function run_Kiteav_FCS(state_reg, num_qubit, shots, single_shots, hamiltonian)
	hamil = sum(hamiltonian) do op_pair
		pstring = jordan_wigner(op_pair.first, num_qubit)
		op = pauli_string2Yaoblock(pstring)
		op * op_pair.second
	end

	FCS_sampler() = begin
		_, unitary = random_FGUclifford(num_qubit)
		return matblock(unitary)
	end
	alpha = binomial(num_qubit, 1) / binomial(2num_qubit, 2)
	FCS_res = shadow_expval(
		state_reg,
		FCS_sampler,
		hamil,
		alpha,
		shots,
		single_shots,
	)
	return FCS_res
end


function theory_expval(state_reg, hamiltonian)
	n = nqubits(state_reg)
	hamil = sum(hamiltonian) do op_pair
		pstring = jordan_wigner(op_pair.first, n)
		op = pauli_string2Yaoblock(pstring)
		op * op_pair.second
	end
	expect(hamil, state_reg)
end


function statistic_results(experiment::Function, nrepeat = 16)
    res = Vector{Float32}(undef, nrepeat)
    # for i in 1:nrepeat
    @threads for i in 1:nrepeat
		r = experiment()
        res[i] = r
    end
    return res
end



