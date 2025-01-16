using Yao


using Random
using LinearAlgebra

# Z gate
function RZ(theta)
	return Complex{Float64}[
		exp(-1im * theta / 2) 0;
		0 exp(1im * theta / 2)
	]
end

# Two-qubit XX rotation
function RXX(theta)
	return Complex{Float64}[
		cos(theta / 2) 0 0 -1im*sin(theta / 2);
		0 cos(theta / 2) -1im*sin(theta / 2)   0;
		0 -1im*sin(theta / 2)   cos(theta / 2) 0;
		-1im*sin(theta / 2)   0 0 cos(theta / 2)
	]
end

@const_gate Zπ2 = RZ(π / 2)
@const_gate XXπ2 = RXX(π / 2)




function random_permutation(n)
	"""
	random_transp(n::Int) -> Tuple{Vector{Int}, Vector{Tuple{Int, Int}}}

	Generate a random permutation of integers from `1` to `n` and decompose the permutation 
	into a series of transpositions (pairwise swaps).

	# Arguments
	- `n::Int`: The size of the permutation to generate. Must be a positive integer.

	# Returns
	A tuple containing:
	1. `transp::Vector{Int}`: A vector representing the randomly permuted integers from `1` to `n`.
	2. `nn_transp::Vector{Tuple{Int, Int}}`: A vector of tuples representing the transpositions used 
	to achieve the random permutation. Each tuple `(a, b)` indicates a swap of positions `a` and `b`.

	# Algorithm
	The function uses the Fisher-Yates shuffle algorithm to generate the random permutation. 
	During the shuffle process:
	- Random indices are selected from the current position `i` to the end of the array.
	- The elements at positions `i` and the selected random index `j` are swapped.
	- Transpositions used during the swaps are recorded in `nn_transp` as pairs of indices.

	# Examples

	```julia
	# Generate a random permutation and its transpositions for n = 4
	transp, nn_transp = random_transp(4)

	# Example output:
	# transp = [3, 1, 4, 2]
	# nn_transp = [(2, 3), (3, 4), (1, 2), (2, 3)]
	println("Random permutation: ", transp)
	println("Transpositions: ", nn_transp)
	"""
	transp = collect(1:n)
	nn_transp = [(1, 1)]

	# Fisher-Yates shuffle
	for i in 1:n-1
		j = rand(i:n)  # Random index from i to n
		transp[i], transp[j] = transp[j], transp[i]

		append!(nn_transp, [(i + k, i + k + 1) for k in 0:j-i-1])
		append!(nn_transp, [(j - 2 - k, j - 1 - k) for k in 0:j-i-2])

	end

	return transp, nn_transp
end

# Random Clifford Generator
function permute_2_Q(permutation)
	d = length(permutation)
	Q = Matrix{Float32}(I, d, d)
	return Q[:, permutation]
end


function random_FGUclifford(n, transp, cycles, Q_phase_flip)
	"""outputs uniformly random 2n*2n signed permutation matrix i.e. matchgate Clifford
	if ret_unitary is set to True, the n-qubit unitary is returned as well"""
	Q = permute_2_Q(transp)

	unitary = Matrix{Complex{Float64}}(I, 2^n, 2^n)
	id = Matrix{Complex{Float64}}(I, 2, 2)

	for (i, j) in cycles
		if i == j == 1
			continue
		end
		if i % 2 == 1
			if i == 1
				gate = reduce(kron, append!([mat(Y) * RZ(π / 2)], [RZ(π) for _ in 1:n-1]))
			else
				gate = reduce(kron, [id for _ in 1:i÷2])
				gate = kron(gate, mat(Y) * RZ(π / 2))
				gate = reduce(kron, append!([gate], [RZ(π) for _ in i÷2+1:n-1]))
			end

		else
			if i == 2
				gate = kron(mat(X), RZ(π)) * RXX(π / 2)
				for qubit in 2:n-1
					gate = kron(gate, RZ(π))
				end
			else
				gate = id
				for qubit in 1:i÷2-2
					gate = kron(gate, id)
				end
				gate = kron(gate, kron(mat(X), RZ(π)) * RXX(π / 2))
				for qubit in i÷2+1:n-1
					gate = kron(gate, RZ(π))
				end
			end
		end
		unitary = gate * unitary
	end

	# Signed permutations
	for (i, isflip) in enumerate(Q_phase_flip)

		if isflip == 1  # Random flip
			Q[i, :] *= -1

			if i % 2 == 1
				if i == 1
					gate = mat(Y)
					for qubit in 2:n
						gate = kron(gate, RZ(π))
					end
				else
					gate = id
					for qubit in 1:i÷2-1
						gate = kron(gate, id)
					end
					gate = kron(gate, mat(Y))
					for qubit in i÷2+1:n-1
						gate = kron(gate, RZ(π))
					end
				end
			else
				if i == 2
					gate = mat(X)
					gate = reduce(kron, append!([gate], [RZ(π) for _ in 1:(n-1)]))
				else

					identity_gates = [id for _ in 1:(i//2-1)]
					gate = reduce(kron, identity_gates)
					gate = kron(gate, mat(X))
					z_gates = [RZ(π) for _ in (i//2):n-1]
					gate = reduce(kron, append!([gate], z_gates))
				end
			end
			unitary = gate * unitary
		end
	end
	return Q, unitary

end


random_FGUclifford(n) = begin
	transp, cycles = random_permutation(2 * n)
	phase_flip = rand(Bool, 2 * n)
	random_FGUclifford(n, transp, cycles, phase_flip)
end

function permutation_to_adjacent_transpositions(permutation::Vector{Int})
    n = length(permutation)
    transpositions = []

    # 创建一个副本，以便我们可以在不改变原始置换的情况下进行操作
    perm_copy = copy(permutation)

    for i in 1:n
        while perm_copy[i] != i
            j = perm_copy[i]
            # 交换位置 i 和 j 的元素
            perm_copy[i], perm_copy[j] = perm_copy[j], perm_copy[i]
            # 记录相邻2轮换 (需要将非相邻的交换分解为一系列相邻的交换)
            if abs(i - j) > 1
                for k in min(i, j)+1:max(i, j)-1
                    push!(transpositions, (k, k+1))
                    # 反转这些交换以保持等价性
                    for l in reverse(min(i, j)+1:max(i, j)-1)
                        push!(transpositions, (l, l+1))
                    end
                end
            else
                push!(transpositions, (i, j))
            end
        end
    end

    return transpositions
end


function new_rand_FGUcliff(cycles, phase_flip, n::Int)

    if isempty(cycles)
        return chain(n)
    end
    gates = []
    for (i,_) in cycles
		j = (i+1)÷2
        if isodd(i)
			gates_layer = append!([put(j => Zπ2), put(j => Y)], [put(k=>Z) for k in j+1:n])
        else
			gates_layer = append!([put([j, j+1]=>XXπ2 ), put(j+1 => Y   )], [put(k=>Z) for k in j+2:n])
        end
		append!(gates, gates_layer)  
    end
	
    for (i, isflip) in enumerate(phase_flip)
		j = (i+1)÷2
		if isflip == 1  # Random flip
			if isodd(i)
				append!(gates, [put(j => Y), (put(k=>Z) for k in j+1:n)...])  
			else
				append!(gates, [put(j => X), (put(k=>Z) for k in j+1:n)...])  
			end
		end
			
	end

	return chain(n, gates)
	
end

new_rand_FGUclifford(n) = begin
	transp, cycles = random_permutation(2 * n)
	phase_flip = rand(Bool, 2 * n)
	new_rand_FGUcliff(cycles, phase_flip, n)
end









