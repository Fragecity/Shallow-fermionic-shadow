using Random
using LinearAlgebra

using Yao
using Memoization

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
@const_gate Zπ = RZ(π)
@const_gate XXπ2 = RXX(-π / 2)


@const_gate YS = mat(Y)*Complex{Float64}[1 0; 0 1im]
@const_gate YXX = mat(chain(2, [put([1, 2]=>matblock(RXX(π / 2)) ), put(2 => Y   )]))


# qb2FGU = Dict()
# for i in 1:1000
	
# 	transp, cycles = random_permutation(4)
# 	phase_flip = rand(Bool, 4)

# 	if !(transp in keys(qb2FGU))
# 		U = rand_FGUcliff(cycles, phase_flip, 2)

# 		push!(qb2FGU, transp=>matblock(mat(U)))
# 	end
# end


# reg = zero_state(2)
# begin

# res = kron(I2, Z)
# for key in keys(qb2FGU)
# U = qb2FGU[key]
# U * res * U'
# end
# mat(res)
# end


















function expect_bgamma_k2(b, S::Vector)
	@assert length(S) == 2 "It can only calculate tr(|b><b| gamma_S) for |S|=2"
	expval = 0im
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


FGUcliff_apply_k2(S::Vector, perm::Vector) = [perm[S[1]], perm[S[2]]]
FGUcliff_apply_k2_local(S::Vector, perm::Vector, location::Int) = begin
    @assert length(perm) == 4 "It only works for 2-qubit local permutation"
    permut = perm .+ (2location-2)
    S1 = S[1] in permut ? permut[S[1]-2location+2] : S[1]
	S2 = S[2] in permut ? permut[S[2]-2location+2] : S[2]
	return [S1, S2]
end

function random_permutation(n)

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

function rand_FGUcliff(cycles, phase_flip, n::Int)

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

@memoize rand_FGUcliff(cycles) = rand_FGUcliff(cycles, 2)



include("Pauli.jl")

#%%
random_permutation(4)
transp = [3, 2, 4, 1]
cycles = [(1, 2), (2, 3), (1, 2), (3, 4)]
flip = [0,0,0,0]

S = [1,2]
pstring = jordan_wigner(S, 2)
op = pauli_string2Yaoblock(pstring)
U = rand_FGUcliff_2(cycles, flip, 2)
mat(U * op * U') # YX -> [2, 3]

FGUcliff_apply_k2([1,2], transp)

reg = zero_state(2)
res = measure(reg, nshots = 10)



# for shots in 1:100
	reg = rand_state(2)
	transp, cycles = random_permutation(4)
	phase_flip = rand(Bool, 4)
	U = rand_FGUcliff(cycles, phase_flip, 2)
	reg2 = apply(reg, U')
	res1 = expect(op, reg2)

	# res = measure!(reg2)
	v = FGUcliff_apply_k2(S, transp)
	coeff = v[1]>v[2] ? -1 : 1
	coeff = coeff * (-1)^phase_flip[S[1]] * (-1)^phase_flip[S[2]]
	sort!(v)
	pstring = jordan_wigner(S, 2)
	op2 = pauli_string2Yaoblock(pstring)
	res2 = expect(op2, reg)
	# expval = expval + expect_bgamma_k2(res, v) * coeff 
	# print(expval)
	println(res1 ≈ res2)
# end

mat(U * op * U')


reg = rand_state(2)
transp, cycles = [2,1,3,4], [(1,2)]
phase_flip = [0,0,0,0]
U = rand_FGUcliff(cycles, phase_flip, 2)
reg2 = apply(reg, U')
res1 = expect(op, reg2)

# res = measure!(reg2)
v = FGUcliff_apply_k2(S, transp)
coeff = v[1]>v[2] ? -1 : 1
coeff = coeff * (-1)^phase_flip[S[1]] * (-1)^phase_flip[S[2]]
sort!(v)
pstring = jordan_wigner(S, 2)
op2 = pauli_string2Yaoblock(pstring)
res2 = expect(op2, reg)
# expval = expval + expect_bgamma_k2(res, v) * coeff 
# print(expval)
println(res1 ≈ res2)


for bits in res
	transp, cycles = random_permutation(2)
	expval += expect_bgamma_k2("10", FGUcliff_apply_k2(S, transp))
end

expect(op, reg)

