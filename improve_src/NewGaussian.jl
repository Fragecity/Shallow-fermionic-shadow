# %%
using Yao
using Memoization

using Random
using LinearAlgebra

include("alpha_tensor.jl")


@const_gate Sgate = Complex{Float64}[1 0; 0 1im]

XXπ2 = chain(2, kron(H, H), cnot(1, 2), put(2 => Sgate^3), cnot(1, 2), kron(H, H))

function rand_perm(n)

	transp = collect(1:n)
	nn_transp = []
	# Fisher-Yates shuffle
	for i in 1:n-1
		j = rand(i:n)  # Random index from i to n
		transp[i], transp[j] = transp[j], transp[i]

		append!(nn_transp, [(i + k, i + k + 1) for k in 0:j-i-1])
		append!(nn_transp, [(j - 2 - k, j - 1 - k) for k in 0:j-i-2])

	end

	return transp, nn_transp
end

function cycles_unitary(cycles, n)
	if isempty(cycles)
		return chain(n)
	end
	gates = []
	for (i, _) in cycles
		j = (i + 1) ÷ 2
		if isodd(i)
			gates_layer = append!([put(j => Sgate), put(j => Y)], [put(k => Z) for k in j+1:n])
			# gates_layer = append!([put(j => Sgate), put(j => Y)], [put(k=>Z) for k in 1:j-1])
		else
			gates_layer = append!([put([j, j + 1] => XXπ2), put(j + 1 => Y)], [put(k => Z) for k in j+2:n])
			# gates_layer = append!([put([j, j+1]=>XXπ2 ), put(j+1 => Y   )], [put(k=>Z) for k in 1:j-1])
		end
		append!(gates, gates_layer)
	end

	return chain(n, gates)
end


@memoize cycles_unitary_local(cycles) = cycles_unitary(cycles, 2)



function FGUcliff_apply(S::Vector{Int}, perm::Vector{Int})
	res = Vector{Int}(undef, length(S))
	for (i, s) in enumerate(S)
		res[i] = findall(x -> x == s, perm)[1]
	end
	return res
end

rand_n_local_perms(num_gates) = begin
	perms = Vector(undef, num_gates)
	cycles_lst = Vector(undef, num_gates)

	for i in 1:num_gates
		perm, cycles = rand_perm(4)
		perms[i] = perm
		cycles_lst[i] = cycles
	end
	return perms, cycles_lst
end


carry(location, carryer, n) = begin
	if location >= n
		location += carryer - n
		carryer = (carryer + 1) % 2
		location += carryer
	end
	return location, carryer
end

getphase(S) = begin
	if isodd(S[1])
		return S[2] > S[1] + 1 ? -1 : 1
	else
		return 1
	end

end

i_geq_cycle(i, location) = i > 2location + 2 ? -1 : 1

findi(i, vec) = findall(x -> x == i, vec)[1]

i_phase(i, cycles, location) = begin
	phase = 1
	# println("start i = ", i)
	for cycle in cycles
		phase *= i_geq_cycle(i, location)
		cycle = cycle .+ (2location - 2)
		# println(cycle)
		if i in cycle
			i = i - (-1)^findi(i, cycle)
		end
		# println(i)
	end
	# println("i = ",i, "\tcycles = ", cycles)
	return i, phase
end



accum_phase(cycles_lst, S, n) = begin

	if isempty(cycles_lst)
		return 1
	else
		return prod(S) do i
			location = 1
			carrier = 0
			phase = 1
			for cycles in cycles_lst
				i, phase_ = i_phase(i, cycles, location)
				phase *= phase_
				# println("location = ", location, "\tphase = ", phase, "\ti = ", i)
				location, carrier = carry(location + 2, carrier, n)
			end
			phase
		end
	end
end

function cycle_phase(cycles, i, n)
	phase = 0
	for cycle in cycles
		# if i in cycle
		phase += i in cycle ? 1 : 0
	end
end



function ADFCS_U(perms, cycles_lst, n)
	L = length(perms)
	gates = Vector{AbstractBlock}(undef, L)
	whole_perm = collect(1:2n)

	location = 1
	carrier = 0
	for i in 1:L

		gates[i] = put(n, [location, location + 1] => cycles_unitary_local(cycles_lst[i]))
		whole_perm[2location-1:2location+2] = [whole_perm[perms[i][j]+2location-2] for j ∈ 1:4]
		location, carrier = carry(location + 2, carrier, n)
	end
	return chain(n, gates), whole_perm
end




include("Pauli.jl")
# include("RandomCircuit.jl")
include("alpha.jl")

function expect_bgamma(b, S::Vector)
	res = 1
	for i = 1:2:length(S)
		res *=  expect_bgamma_k2(b, [S[i], S[i+1]])
	end
	return res
end


function expect_bgamma_k2(b, S::Vector)
	@assert length(S) == 2 "It can only calculate tr(|b><b| gamma_S) for |S|=2"
	expval = 0.
	i, j = S
	n = length(b)
	if isodd(i) && j == i + 1
		l = (i + 1) ÷ 2
		# bl = Int(b[l] - '0')
		# bl = b[n-l+1]
		bl = b[l]
		expval = (-1)^bl
	end
	return expval
end

function bubble_sort_with_swaps(arr::Vector{T}) where T
    n = length(arr)
    swap_count = 0
    for i in 1:n-1
        # 设定一个标志位，用于检测这一轮是否有发生过交换
        swapped = false
        for j in 1:n-i
            if arr[j] > arr[j+1]
                # 置换操作
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swap_count += 1
                swapped = true
            end
        end
        # 如果没有发生过交换，说明已经有序，可以提前退出
        if !swapped
            break
        end
    end
    return arr, swap_count
end


function cal_hamil(hamil, bs, perm)
	res = 0.0
	for (S, coeff_hamil) in hamil
		S_acted = FGUcliff_apply(S, perm)
		S_acted, swaps = bubble_sort_with_swaps(S_acted)

		# coeff *= getphase(S_acted) * coeff_hamil
		coeff = (-1)^swaps * coeff_hamil
		res += sum(bs) do b
			expect_bgamma(b, S_acted)
		end * coeff /length(bs)
	end
	return res
end


############################################
##               H  E  A  D               ##
############################################

get_hamil_Yao(hamil, n) = sum(hamil) do (S, coeff)
	pstring = jordan_wigner(S, n)
	op = pauli_string2Yaoblock(pstring)
	op * coeff * getphase(S)
end



# cal_hamil_ADFCS(hamil, bs, perm, cycles_lst, d, n) = begin
# 	alpha_ = alpha_theory()
# 	coeff = accum_phase(cycles_lst, S_acted,n) / alpha_
# 	return cal_hamil(hamil, bs, perm) * coeff
# end
# alpha_theory

function cal_hamil_ADFCS(hamil, bs, perm, cycles_lst, d, n)
	res = 0.0
	for (S, coeff_hamil) in hamil
		
		alpha_ =  d<8 ? alpha(S,d,n) : alpha_theory(S, d, n)
		S_acted = FGUcliff_apply(S, perm)
		coeff = S_acted[1] > S_acted[2] ? -1 : 1
		sort!(S_acted)

		# coeff *= getphase(S_acted) * coeff_hamil/ alpha_ /length(bs)
		coeff *= coeff_hamil / alpha_ / length(bs) * accum_phase(cycles_lst, S,n) 
		res += sum(bs) do b
			expect_bgamma_k2(b, S_acted)
		end * coeff 
	end
	# println(accum_phase(cycles_lst, S_acted,n)) 
	return res 
end

cal_hamil_FCS(hamil, bs, perm, n) = begin
	k = (length ∘ first ∘ keys)(hamil) ÷ 2
	cal_hamil(hamil, bs, perm) * binomial(2n, 2k) / binomial(n, k)
end

run_shots_ADFCS(hamil,reg,d, single_shots) = begin
	n = nqubits(reg)
	L = (n-1) * (d÷2) + n÷2
	perms, cyc_lst = rand_n_local_perms(L)
    U, perm = ADFCS_U(perms, cyc_lst, n)
	reg2 = apply(reg, U)
    bs = measure(reg2, nshots = single_shots);
	cal_hamil_ADFCS(hamil, bs, perm, cyc_lst, d,n)
end



function run_ADFCS(hamil,reg, d, shots, single_shots)
	n = nqubits(reg)
	@assert isodd(d)
	@assert iseven(n)

	res = 0.
	L = (n-1) * (d÷2) + n÷2
	r, m = divrem(shots, single_shots)

	for i in 1:r
		res += run_shots_ADFCS(hamil,reg,d, single_shots)
	end
	for _ in 1:m
		res += run_shots_ADFCS(hamil,reg,d, 1)
	end
	return res / (r+m)
end

run_shots_FCS(hamil,reg,single_shots) = begin
	n = nqubits(reg)
	perm, cycles = rand_perm(2n)
    U = cycles_unitary(cycles, n)
	reg2 = apply(reg, U)
    bs = measure(reg2, nshots = single_shots);
	cal_hamil_FCS(hamil, bs, perm,n)
end


function run_FCS(hamil,reg, shots, single_shots)
	res = 0.
	r, m = divrem(shots, single_shots)

	for i in 1:r
		res += run_shots_FCS(hamil,reg,single_shots)
		if i%4 ==0
		# println("finish job $i")
		end
	end
	for _ in 1:m
		res += run_shots_FCS(hamil,reg,1)
	end
	
	return res / (r+m)
end

