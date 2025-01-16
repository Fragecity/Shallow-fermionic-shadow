include("Pauli.jl")

function KiteavChain_hamiltonian_S(qubit_num, mu, delta, t) 
    hamil = Dict()

    pushing_fermi_ops!(hamil, [[ 2 * j - 1,  2 * j] for j in 1:qubit_num], mu / 2)
    pushing_fermi_ops!(hamil, [[2 * j, 2 * j + 1] for j in 1:(qubit_num - 1)], -(delta + t) / 2)
    pushing_fermi_ops!(hamil, [[2 * j - 1, 2 * j + 2] for j in 1:(qubit_num - 1)], -(delta - t) / 2)

    return hamil
end

function pushing_fermi_ops!(h, op_vec, coeff)
    for S in op_vec
        push!(h, S=>coeff)
    end
end



