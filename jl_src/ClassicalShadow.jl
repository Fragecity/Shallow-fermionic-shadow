using Yao
using Base.Threads
using Statistics


function shadow_pieces(reg::AbstractRegister, circ_block::AbstractBlock, shots::Int = 1)
	num_qubit = nqubits(reg)
	reg = apply(reg, put(1:num_qubit => circ_block))
	res = measure(reg, nshots = shots)

	pieces = []
	for bits in res
		piece = product_state(bits)
		apply!(piece, put(1:num_qubit => circ_block'))
		push!(pieces, piece)
	end
	return pieces
end

function shadow_expval(state_reg, circ_ensemble::Function, operator::AbstractBlock, alpha, shots = 1024, single_experiment_shots = 1)
	r, m = divrem(shots, single_experiment_shots)
	expval = 0

	for _ ∈ 1:r
		pieces = shadow_pieces(state_reg, circ_ensemble(), single_experiment_shots)
		expval += mean(expect(operator, piece) for piece in pieces)
	end

	for _ ∈ 1:m
		piece = shadow_pieces(state_reg, circ_ensemble(), 1)[1]
		expval += expect(operator, piece)
	end
	return expval / (r + m) / alpha
end



