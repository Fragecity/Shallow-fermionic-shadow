module Paulis
    export Pauli, *
    
    
    str2bin = Dict('I' => (false, false), 'X' => (true, false), 'Y' => (true, true), 'Z' => (false, true))
    bin2str = Dict((false, false) => 'I', (true, false) => 'X', (true, true) => 'Y', (false, true) => 'Z')

    struct Pauli
    name::String
    bin::Tuple{Vararg{Bool}}

    function Pauli(name::String)
        vec = [str2bin[p] for p in name]
        vec = (Tuple ∘ collect ∘ Iterators.flatten)(vec)
        new(name, vec)
    end

    function Pauli(bin::Tuple{Vararg{Bool}})
        name = join([bin2str[ (bin[ind], bin[ind+1]) ] for ind in 1:2:length(bin) ])
        new(name, bin)
    end
 
    end

    function Base.:*(a::Pauli, b::Pauli)
        new_bin = a.bin .⊻ b.bin
        Pauli(new_bin)
    end
end

