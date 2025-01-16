include("Spread.jl")

using .TSpreads

board


f(x) = ℯ^(2π *im/4 *x) +  ℯ^(6π *im/4 *x)
for i in 1:4
    println(f(i))
end
