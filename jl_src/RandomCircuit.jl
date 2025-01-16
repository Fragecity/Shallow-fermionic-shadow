using LinearAlgebra
using Base.Iterators


function sample_qcirc(sample_func::Function, skelon::Vector, num_qubit::Int)
	layer_gates = []
	for layer in skelon
		gates = [sample_func(_) for _ in 1:length(layer)]
		push!(layer_gates, transversal_gates(num_qubit, layer, gates))
	end
	return chain(num_qubit, put(1:num_qubit => layer_gate) for layer_gate in layer_gates)
end

transversal_gates(num_qubit::Int, align::Vector, gates::Vector) = chain(
	num_qubit,
	# put(region => matblock(gate)) for (region, gate) in zip(align, gates)
	put(region => gate) for (region, gate) in zip(align, gates)
	)



odd_layer_skelon(num_qubit::Int) = collect(partition(2:num_qubit-1, 2))
even_layer_skelon(num_qubit::Int) = collect(partition(1:num_qubit, 2))

function hardware_efficient_skelon(num_qubits::Int, depth::Int)

	res = Vector{Vector}()
	for i ∈ 1:depth
		if i % 2 == 1
			push!(res, even_layer_skelon(num_qubits))
		else
			push!(res, odd_layer_skelon(num_qubits))
		end
	end
	return res
end

