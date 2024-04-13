module Spread
export C, spread_row


N2 = 10
C = zeros(Float64, N2, 2)
C[1,1] = 1/2
C[2,1] = 1/2
C[N2,1] = 1/2
C[N2,2] = 1/2

function spread_row(M::Matrix{Float64}, row_index::Int64)
    M_cp = zeros(Float64, size(M)... )
    if row_index == 1
        M_cp[1,1] = 1/2 * M[1,1]
        M_cp[2,1] = 1/2 * M[1,1]
        M_cp[1,2] = 1/2 * M[1,2]
        M_cp[2,2] = 1/2 * M[1,2]
    elseif row_index == size(M, 1)
        M_cp[end,1] = 1/2 * M[end,1]
        M_cp[end-1,1] = 1/2 * M[end,1]
        M_cp[end,2] = 1/2 * M[end,2]
        M_cp[end-1,2] = 1/2 * M[end,2]
    else
        M_cp[row_index, 1] = 1/2 * M[row_index, 1]
        M_cp[row_index+1, 1] = 1/4 * M[row_index, 1]
        M_cp[row_index-1, 1] = 1/4 * M[row_index, 1]

        M_cp[row_index, 2] = 1/2 * M[row_index, 2]
        M_cp[row_index+1, 2] = 1/4 * M[row_index, 2]
        M_cp[row_index-1, 2] = 1/4 * M[row_index, 2]
    end

    return M_cp
end


end


C_now = Spread.spread_row(Spread.C, 1)

# println(C_now)
show(C_now)
